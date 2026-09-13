import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages order history and order details.
class OrderProvider with ChangeNotifier {
  final ApiService _api;

  List<OrderModel> _orders = [];
  OrderModel? _selectedOrder;
  bool _isLoading = false;
  bool _isDetailLoading = false;
  String? _error;

  OrderProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<OrderModel> get orders => _orders;
  OrderModel? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  bool get isDetailLoading => _isDetailLoading;
  String? get error => _error;

  // ── Fetch list ─────────────────────────────────────────────────────────

  /// GET /api/orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.orders);
      final list = response as List<dynamic>;
      _orders = list
          .map((j) => OrderModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch single ───────────────────────────────────────────────────────

  /// GET /api/orders/{id}
  Future<void> fetchOrderById(int id) async {
    _isDetailLoading = true;
    _error = null;
    _selectedOrder = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.orderById(id));
      _selectedOrder = OrderModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }
}
