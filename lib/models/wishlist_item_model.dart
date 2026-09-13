import 'product_model.dart';

/// Represents a wishlist entry returned by GET /api/wishlist.
///
/// Laravel response shape:
/// { "id": 3, "product_id": 7, "product": { ...ProductModel fields... } }
class WishlistItemModel {
  final int id;
  final int productId;
  final ProductModel? product; // full product embedded in GET /api/wishlist

  WishlistItemModel({
    required this.id,
    required this.productId,
    this.product,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}
