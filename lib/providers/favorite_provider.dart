import 'package:flutter/material.dart';
import '../models/favorite_item_model.dart';
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
      final list = response as List<dynamic>;
      _items = list
          .map((j) => FavoriteItemModel.fromJson(j as Map<String, dynamic>))
          .toList();
      _favoriteIds = _items.map((i) => i.menuItemId).toSet();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWishlist() => fetchFavorites();

  // ── Toggle ─────────────────────────────────────────────────────────────

  /// Toggle favorite status with optimistic update.
  Future<void> toggleFavorite(int menuItemId) async {
    if (isFavorite(menuItemId)) {
      final existingItem = _items.firstWhere(
        (i) => i.menuItemId == menuItemId,
        orElse: () => FavoriteItemModel(id: 0, menuItemId: menuItemId),
      );

      _favoriteIds.remove(menuItemId);
      _items.removeWhere((i) => i.menuItemId == menuItemId);
      notifyListeners();

      try {
        await _api.delete(ApiEndpoints.favoriteItem(menuItemId));
      } catch (e) {
        if (existingItem.id != 0) {
          _favoriteIds.add(menuItemId);
          _items.add(existingItem);
          notifyListeners();
        }
      }
    } else {
      _favoriteIds.add(menuItemId);
      notifyListeners();

      try {
        final response = await _api.post(
          ApiEndpoints.favorites,
          data: {'menu_item_id': menuItemId},
        );
        final newItem =
            FavoriteItemModel.fromJson(response as Map<String, dynamic>);
        _items.add(newItem);
        notifyListeners();
      } catch (e) {
        _favoriteIds.remove(menuItemId);
        notifyListeners();
      }
    }
  }

  Future<void> toggleWishlist(int id) => toggleFavorite(id);

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
