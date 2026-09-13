import 'package:flutter/material.dart';
import '../models/wishlist_item_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages the wishlist state, synced with Laravel API.
class WishlistProvider with ChangeNotifier {
  final ApiService _api;

  List<WishlistItemModel> _items = [];
  Set<int> _wishlistedIds = {}; // product IDs for fast O(1) lookup
  bool _isLoading = false;
  String? _error;

  WishlistProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<WishlistItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;

  bool isWishlisted(int productId) => _wishlistedIds.contains(productId);

  // ── Fetch ──────────────────────────────────────────────────────────────

  /// GET /api/wishlist
  Future<void> fetchWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.wishlist);
      final list = response as List<dynamic>;
      _items = list
          .map((j) => WishlistItemModel.fromJson(j as Map<String, dynamic>))
          .toList();
      _wishlistedIds = _items.map((i) => i.productId).toSet();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Toggle ─────────────────────────────────────────────────────────────

  /// Adds or removes a product from the wishlist with optimistic local update.
  Future<void> toggleWishlist(int productId) async {
    if (isWishlisted(productId)) {
      // Find the wishlist item id for this product
      final wishlistItem =
          _items.firstWhere((i) => i.productId == productId);

      // Optimistic remove
      _wishlistedIds.remove(productId);
      _items.removeWhere((i) => i.productId == productId);
      notifyListeners();

      try {
        await _api.delete(ApiEndpoints.wishlistItem(wishlistItem.id));
      } catch (e) {
        // Roll back
        _wishlistedIds.add(productId);
        _items.add(wishlistItem);
        notifyListeners();
      }
    } else {
      // Optimistic add
      _wishlistedIds.add(productId);
      notifyListeners();

      try {
        final response = await _api.post(
          ApiEndpoints.wishlist,
          data: {'product_id': productId},
        );
        final newItem =
            WishlistItemModel.fromJson(response as Map<String, dynamic>);
        // Replace the optimistic placeholder with real data
        _items.add(newItem);
        notifyListeners();
      } catch (e) {
        // Roll back
        _wishlistedIds.remove(productId);
        notifyListeners();
      }
    }
  }

  // ── Remove from list screen ────────────────────────────────────────────

  /// Explicitly remove by wishlist entry id (used from the Wishlist screen).
  Future<void> removeById(int wishlistItemId, int productId) async {
    _wishlistedIds.remove(productId);
    _items.removeWhere((i) => i.id == wishlistItemId);
    notifyListeners();
    try {
      await _api.delete(ApiEndpoints.wishlistItem(wishlistItemId));
    } catch (_) {
      await fetchWishlist(); // re-sync on failure
    }
  }
}
