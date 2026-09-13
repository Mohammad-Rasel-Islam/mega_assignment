import 'address_model.dart';

/// Represents an order item embedded inside an order.
class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final String? color;
  final String? size;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    this.color,
    this.size,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    final images = (product?['product_images'] as List<dynamic>?)
            ?.map((img) => img['image_url']?.toString() ?? '')
            .where((u) => u.isNotEmpty)
            .toList() ??
        [];

    return OrderItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: product?['name'] as String? ?? 'Product',
      productImage: images.isNotEmpty ? images.first : '',
      quantity: json['quantity'] as int? ?? 1,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      color: json['color'] as String?,
      size: json['size'] as String?,
    );
  }

  double get lineTotal => price * quantity;
}

/// Represents an order returned by GET /api/orders or GET /api/orders/{id}.
///
/// Laravel response shape:
/// {
///   "id": 10,
///   "status": "pending",
///   "subtotal": "259.98",
///   "delivery_fee": "15.00",
///   "total": "274.98",
///   "created_at": "2025-01-01T00:00:00.000000Z",
///   "address": { ...AddressModel fields... },
///   "items": [ ...OrderItemModel list... ]
/// }
class OrderModel {
  final int id;
  final String status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime? createdAt;
  final AddressModel? address;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.createdAt,
    this.address,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'pending',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      deliveryFee:
          double.tryParse(json['delivery_fee']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      items: rawItems
          .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Returns a colour string matching the order status for UI display.
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
