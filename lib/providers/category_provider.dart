import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages the list of product categories from GET /api/categories.
class CategoryProvider with ChangeNotifier {
  final ApiService _api;

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  int _selectedIndex = 0; // 0 = "All" virtual category

  CategoryProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedIndex => _selectedIndex;

  /// The currently selected category's ID, or null when "All" is selected.
  int? get selectedCategoryId =>
      _selectedIndex == 0 ? null : _categories[_selectedIndex - 1].id;

  // ── Fetch ──────────────────────────────────────────────────────────────

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get(ApiEndpoints.categories);
      final list = response as List<dynamic>;
      _categories =
          list.map((j) => CategoryModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Selection ──────────────────────────────────────────────────────────

  void selectCategory(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
