/// Represents a product category returned by GET /api/categories.
///
/// Laravel response shape:
/// { "id": 1, "name": "Shoes", "icon": "👟", "image_url": "https://..." }
class CategoryModel {
  final int id;
  final String name;
  final String icon;   // emoji or icon name
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon = '🛍️',
    this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '🛍️',
      imageUrl: json['image_url'] as String?,
    );
  }

  String get idStr => id.toString();
}
