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
    final rawMData = json['menu_item'] ?? json['product'];
    final Map<String, dynamic>? mData =
        rawMData is Map ? Map<String, dynamic>.from(rawMData) : null;

    return FavoriteItemModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      menuItemId: int.tryParse(
              (json['menu_item_id'] ?? json['product_id'])?.toString() ?? '') ??
          0,
      menuItem: mData != null ? MenuItemModel.fromJson(mData) : null,
    );
  }

  // Compatibility getters
  int get productId => menuItemId;
  MenuItemModel? get product => menuItem;
}

/// Type alias for legacy WishlistItemModel references
typedef WishlistItemModel = FavoriteItemModel;
