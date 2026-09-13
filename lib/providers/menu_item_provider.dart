import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Manages restaurant menu items state, synced with REST API.
class MenuItemProvider with ChangeNotifier {
  final ApiService _api;

  List<MenuItemModel> _menuItems = [];
  bool _isLoading = false;
  String? _error;

  MenuItemProvider(this._api);

  // ── Getters ────────────────────────────────────────────────────────────

  List<MenuItemModel> get menuItems => _menuItems;
  List<MenuItemModel> get products => _menuItems; // Legacy alias
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<MenuItemModel> get popularItems =>
      _menuItems.where((i) => i.isPopular).toList();

  // ── Fetch ──────────────────────────────────────────────────────────────

  /// GET /api/menu-items
  Future<void> fetchMenuItems({int? categoryId, String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _api.get(
        ApiEndpoints.menuItems,
        queryParameters: queryParams,
      );

      if (response is List) {
        _menuItems = response
            .whereType<Map>()
            .map((j) => MenuItemModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      }
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET /api/menu-items/{id}
  Future<MenuItemModel?> getMenuItemById(int id) async {
    try {
      final idx = _menuItems.indexWhere((i) => i.id == id);
      if (idx != -1 && _menuItems[idx].ingredients.isNotEmpty) {
        return _menuItems[idx];
      }
      final response = await _api.get(ApiEndpoints.menuItemById(id));
      if (response is Map) {
        return MenuItemModel.fromJson(Map<String, dynamic>.from(response));
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

/// Type alias for legacy ProductProvider references
typedef ProductProvider = MenuItemProvider;
