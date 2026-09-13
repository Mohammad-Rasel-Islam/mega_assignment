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
    final rawMData = json['menu_item'] ?? json['product'];
    final Map<String, dynamic>? mData =
        rawMData is Map ? Map<String, dynamic>.from(rawMData) : null;

    return CartItemModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      menuItemId: int.tryParse(
              (json['menu_item_id'] ?? json['product_id'])?.toString() ?? '') ??
          0,
      color: json['color']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      menuItem: mData != null ? MenuItemModel.fromJson(mData) : null,
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
