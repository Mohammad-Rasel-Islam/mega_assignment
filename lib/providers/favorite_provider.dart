import 'package:flutter/material.dart';
import '../models/favorite_item_model.dart';
import '../models/menu_item_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages restaurant favorites state, synced with REST API.
class FavoriteProvider with ChangeNotifier {
  final ApiService _api;

  List<FavoriteItemModel> _items = [];
  Set<int> _favoriteIds = {};
  bool _isLoading = false;
  String? _error;

  FavoriteProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<FavoriteItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;

  bool isFavorite(int menuItemId) => _favoriteIds.contains(menuItemId);
  bool isWishlisted(int id) => isFavorite(id); // Legacy alias

  // ── Fetch ──────────────────────────────────────────────────────────────

  /// GET /api/favorites
  Future<void> fetchFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.favorites);
      if (response is List) {
        _items = response
            .whereType<Map>()
            .map((j) => FavoriteItemModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        _favoriteIds = _items.map((i) => i.menuItemId).toSet();
      }
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWishlist() => fetchFavorites();

  // ── Toggle ─────────────────────────────────────────────────────────────

  /// Toggle favorite status with optimistic update and full model preservation.
  Future<void> toggleFavorite(int menuItemId, {MenuItemModel? menuItem}) async {
    if (isFavorite(menuItemId)) {
      // ── Un-favourite ──────────────────────────────────────────────────
      final existingItem = _items.firstWhere(
        (i) => i.menuItemId == menuItemId,
        orElse: () => FavoriteItemModel(id: 0, menuItemId: menuItemId, menuItem: menuItem),
      );
      final existingIndex = _items.indexWhere((i) => i.menuItemId == menuItemId);

      // Optimistic removal
      _favoriteIds.remove(menuItemId);
      _items.removeWhere((i) => i.menuItemId == menuItemId);
      notifyListeners();

      try {
        await _api.delete(ApiEndpoints.favoriteItem(menuItemId));
      } catch (e) {
        // Rollback — always restore at original position
        _favoriteIds.add(menuItemId);
        final insertAt = existingIndex.clamp(0, _items.length);
        _items.insert(insertAt, existingItem);
        notifyListeners();
      }
    } else {
      // ── Add to favourites ─────────────────────────────────────────────
      _favoriteIds.add(menuItemId);
      final tempFav = FavoriteItemModel(
        id: 0,
        menuItemId: menuItemId,
        menuItem: menuItem,
      );
      _items.removeWhere((i) => i.menuItemId == menuItemId);
      // Insert at top so newest favourites appear first
      _items.insert(0, tempFav);
      notifyListeners();

      try {
        final response = await _api.post(
          ApiEndpoints.favorites,
          data: {
            'menu_item_id': menuItemId,
            'product_id': menuItemId,
          },
        );

        if (response is Map) {
          final newItem = FavoriteItemModel.fromJson(Map<String, dynamic>.from(response));
          _items.removeWhere((i) => i.menuItemId == menuItemId);

          if (newItem.menuItem != null) {
            // Server returned full embedded menu item — use it
            _items.insert(0, newItem);
            notifyListeners();
          } else if (menuItem != null) {
            // Server didn't embed the item but we have it from the caller
            _items.insert(0, FavoriteItemModel(
              id: newItem.id,
              menuItemId: menuItemId,
              menuItem: menuItem,
            ));
            notifyListeners();
          } else {
            // Nothing locally available — re-fetch to get full data for the grid
            await fetchFavorites();
          }
        } else {
          // Unexpected response shape — re-fetch for consistency
          await fetchFavorites();
        }
      } catch (e) {
        // Rollback optimistic add
        _favoriteIds.remove(menuItemId);
        _items.removeWhere((i) => i.menuItemId == menuItemId);
        notifyListeners();
      }
    }
  }

  Future<void> toggleWishlist(int id, {MenuItemModel? product}) =>
      toggleFavorite(id, menuItem: product);

  /// Explicitly remove by ID with re-sync on failure.
  Future<void> removeById(int favoriteId, int menuItemId) async {
    _favoriteIds.remove(menuItemId);
    _items.removeWhere((i) => i.id == favoriteId || i.menuItemId == menuItemId);
    notifyListeners();
    try {
      await _api.delete(ApiEndpoints.favoriteItem(menuItemId));
    } catch (_) {
      await fetchFavorites();
    }
  }
}

/// Type alias for legacy WishlistProvider references
typedef WishlistProvider = FavoriteProvider;
