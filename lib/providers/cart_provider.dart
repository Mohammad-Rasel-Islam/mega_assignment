import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages the shopping cart state, synced with Laravel API.
class CartProvider with ChangeNotifier {
  final ApiService _api;

  List<CartItemModel> _cartItems = [];
  bool _isLoading = false;
  String? _error;

  /// Delivery fee is set to 0.0 (Free Delivery).
  static const double defaultDeliveryFee = 0.0;

  CartProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<CartItemModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => 0.0;

  double get total => subtotal;

  // ── Fetch ──────────────────────────────────────────────────────────────

  /// Load cart from GET /api/cart.
  Future<void> fetchCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.cart);
      final list = response as List<dynamic>;
      _cartItems = list
          .map((j) => CartItemModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Add to cart ────────────────────────────────────────────────────────

  /// POST /api/cart
  Future<bool> addToCart({
    required int productId,
    required String color,
    required String size,
    int quantity = 1,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.cart,
        data: {
          'product_id': productId,
          'color': color,
          'size': size,
          'quantity': quantity,
        },
      );
      // Add the returned item to local state for immediate UI update
      final newItem =
          CartItemModel.fromJson(response as Map<String, dynamic>);
      _cartItems.add(newItem);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Update quantity ────────────────────────────────────────────────────

  /// PUT /api/cart/{id} — optimistic local update, then syncs with server.
  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    if (newQuantity < 1) {
      await removeItem(cartItemId);
      return;
    }
    // Optimistic update
    final idx = _cartItems.indexWhere((i) => i.id == cartItemId);
    if (idx != -1) {
      _cartItems[idx] = _cartItems[idx].copyWith(quantity: newQuantity);
      notifyListeners();
    }
    try {
      await _api.put(
        ApiEndpoints.cartItem(cartItemId),
        data: {'quantity': newQuantity},
      );
    } catch (e) {
      // Roll back on failure by re-fetching
      await fetchCart();
    }
  }

  // ── Remove item ────────────────────────────────────────────────────────

  /// DELETE /api/cart/{id} — optimistic local remove.
  Future<void> removeItem(int cartItemId) async {
    // Optimistic remove
    final removed = _cartItems.where((i) => i.id == cartItemId).toList();
    _cartItems.removeWhere((i) => i.id == cartItemId);
    notifyListeners();

    try {
      await _api.delete(ApiEndpoints.cartItem(cartItemId));
    } catch (e) {
      // Roll back
      _cartItems.addAll(removed);
      notifyListeners();
    }
  }

  // ── Clear local cart ───────────────────────────────────────────────────

  /// Called after a successful order placement.
  void clearLocalCart() {
    _cartItems = [];
    notifyListeners();
  }
}
