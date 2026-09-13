/// Represents a product returned by GET /api/products or GET /api/products/{id}.
///
/// Laravel response shape (example):
/// {
///   "id": 1,
///   "name": "Running Shoes",
///   "price": "129.99",
///   "description": "...",
///   "category_id": 3,
///   "colors": ["#FF0000", "#0000FF"],
///   "sizes": ["S", "M", "L", "XL"],
///   "rating": 4.5,
///   "is_popular": true,
///   "product_images": [
///     { "id": 1, "image_url": "https://..." },
///     ...
///   ]
/// }
class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final int categoryId;
  final List<String> colors;
  final List<String> sizes;
  final double rating;
  final bool isPopular;
  final List<String> images; // extracted from product_images[].image_url

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.colors,
    required this.sizes,
    this.rating = 4.5,
    this.isPopular = false,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle product_images array
    final rawImages = json['product_images'] as List<dynamic>? ?? [];
    final images = rawImages
        .map((img) => img['image_url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    // Fallback: if product has a single 'image' field
    if (images.isEmpty && json['image'] != null) {
      images.add(json['image'].toString());
    }

    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] as String? ?? '',
      categoryId: json['category_id'] as int? ?? 0,
      colors: List<String>.from(json['colors'] as List<dynamic>? ?? []),
      sizes: List<String>.from(json['sizes'] as List<dynamic>? ?? []),
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      isPopular: json['is_popular'] as bool? ?? false,
      images: images,
    );
  }

  /// The first image URL, used as the product's thumbnail.
  String get primaryImage => images.isNotEmpty ? images.first : '';

  /// Convenience string ID for widgets that expect a String key.
  String get idStr => id.toString();
}
