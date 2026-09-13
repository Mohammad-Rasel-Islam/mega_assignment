import 'product_model.dart';

/// Represents a single line-item in the cart, as returned by GET /api/cart.
///
/// Laravel response shape (example):
/// {
///   "id": 42,
///   "product_id": 7,
///   "quantity": 2,
///   "color": "#FF0000",
///   "size": "M",
///   "price": "129.99",
///   "product": { ...ProductModel fields... }
/// }
class CartItemModel {
  final int id;
  final int productId;
  int quantity;
  final String selectedColor;
  final String selectedSize;
  final double price;
  final ProductModel? product; // full product embedded in GET /api/cart

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.price,
    this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int? ?? 1,
      selectedColor: json['color'] as String? ?? '',
      selectedSize: json['size'] as String? ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Line-item total price.
  double get totalPrice => price * quantity;

  /// Display name from embedded product, falls back to "Product #id".
  String get productName => product?.name ?? 'Product #$productId';

  /// Thumbnail from embedded product.
  String get productImage => product?.primaryImage ?? '';

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      productId: productId,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      price: price,
      product: product,
    );
  }
}
