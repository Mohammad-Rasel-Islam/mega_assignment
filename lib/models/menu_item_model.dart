import 'ingredient_model.dart';

/// Represents a restaurant food menu item.
class MenuItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int categoryId;
  final int calories;
  final int prepTimeMinutes;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final List<IngredientModel> ingredients;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.calories,
    required this.prepTimeMinutes,
    required this.rating,
    required this.reviewCount,
    required this.isPopular,
    required this.ingredients,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final rawIngs = json['ingredients'] as List<dynamic>? ?? [];
    final ingredients = rawIngs
        .map((i) => IngredientModel.fromJson(i as Map<String, dynamic>))
        .toList();

    String img = json['image_url'] as String? ?? '';
    if (img.isEmpty) {
      final rawImages = json['product_images'] as List<dynamic>? ?? [];
      if (rawImages.isNotEmpty) {
        img = rawImages.first['image_url']?.toString() ?? '';
      }
    }

    return MenuItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: img,
      categoryId: json['category_id'] as int? ?? 0,
      calories: json['calories'] as int? ?? 350,
      prepTimeMinutes: json['prep_time_minutes'] as int? ?? 15,
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      reviewCount: json['review_count'] as int? ?? 100,
      isPopular: json['is_popular'] as bool? ?? false,
      ingredients: ingredients,
    );
  }

  // Backwards compatibility getters
  String get primaryImage => imageUrl;
  List<String> get images => [imageUrl];
  List<String> get colors => [];
  List<String> get sizes => [];
}

/// Type alias for legacy ProductModel references
typedef ProductModel = MenuItemModel;
