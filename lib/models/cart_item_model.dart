import 'menu_item_model.dart';

/// Represents a cart item returned by GET /api/cart.
class CartItemModel {
  final int id;
  final int menuItemId;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final MenuItemModel? menuItem;

  CartItemModel({
    required this.id,
    required this.menuItemId,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    this.menuItem,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final mData = json['menu_item'] ?? json['product'];
    return CartItemModel(
      id: json['id'] as int? ?? 0,
      menuItemId: json['menu_item_id'] as int? ?? json['product_id'] as int? ?? 0,
      color: json['color'] as String? ?? '',
      size: json['size'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      menuItem: mData != null
          ? MenuItemModel.fromJson(mData as Map<String, dynamic>)
          : null,
    );
  }

  CartItemModel copyWith({
    int? id,
    int? menuItemId,
    String? color,
    String? size,
    int? quantity,
    double? price,
    MenuItemModel? menuItem,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      color: color ?? this.color,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      menuItem: menuItem ?? this.menuItem,
    );
  }

  double get totalPrice => price * quantity;
  String get productName => menuItem?.name ?? 'Food Item';
  String get primaryImage => menuItem?.imageUrl ?? '';

  // Compatibility getters
  int get productId => menuItemId;
  MenuItemModel? get product => menuItem;
  String get productImage => menuItem?.imageUrl ?? '';
  String get selectedColor => color;
  String get selectedSize => size;
}
