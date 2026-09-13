import 'menu_item_model.dart';

/// Represents a favorite item entry returned by GET /api/favorites.
class FavoriteItemModel {
  final int id;
  final int menuItemId;
  final MenuItemModel? menuItem;

  FavoriteItemModel({
    required this.id,
    required this.menuItemId,
    this.menuItem,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    final mData = json['menu_item'] ?? json['product'];
    return FavoriteItemModel(
      id: json['id'] as int? ?? 0,
      menuItemId: json['menu_item_id'] as int? ?? json['product_id'] as int? ?? 0,
      menuItem: mData != null
          ? MenuItemModel.fromJson(mData as Map<String, dynamic>)
          : null,
    );
  }

  // Compatibility getters
  int get productId => menuItemId;
  MenuItemModel? get product => menuItem;
}

/// Type alias for legacy WishlistItemModel references
typedef WishlistItemModel = FavoriteItemModel;
