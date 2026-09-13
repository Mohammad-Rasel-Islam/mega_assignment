import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages the product catalogue, including search and per-product detail.
class ProductProvider with ChangeNotifier {
  final ApiService _api;

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  bool _isDetailLoading = false;
  String? _error;
  String? _detailError;

  ProductProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  bool get isDetailLoading => _isDetailLoading;
  String? get error => _error;
  String? get detailError => _detailError;

  // ── Fetch list ─────────────────────────────────────────────────────────

  /// Fetch products optionally filtered by [categoryId] and/or [search] query.
  /// Calls GET /api/products?category_id=X&search=Y
  Future<void> fetchProducts({int? categoryId, String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final params = <String, dynamic>{};
      if (categoryId != null) params['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) params['search'] = search;

      final response =
          await _api.get(ApiEndpoints.products, queryParameters: params);

      final list = response as List<dynamic>;
      _products = list
          .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch single product ───────────────────────────────────────────────

  /// Fetch a single product by ID. Calls GET /api/products/{id}.
  Future<void> fetchProductById(int id) async {
    _isDetailLoading = true;
    _detailError = null;
    _selectedProduct = null;
    notifyListeners();

    try {
      final response = await _api.get(ApiEndpoints.productById(id));
      _selectedProduct =
          ProductModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      _detailError = e is ApiException ? e.message : e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
  }
}
