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
        .whereType<Map>()
        .map((i) => IngredientModel.fromJson(Map<String, dynamic>.from(i)))
        .toList();

    String img = json['image_url']?.toString() ?? '';
    if (img.isEmpty) {
      final rawImages = json['product_images'] as List<dynamic>? ?? [];
      if (rawImages.isNotEmpty) {
        final firstImg = rawImages.first;
        if (firstImg is Map) {
          img = firstImg['image_url']?.toString() ?? '';
        }
      }
    }

    final rawPopular = json['is_popular'];
    final isPopular = rawPopular == true || rawPopular == 1 || rawPopular == '1';

    return MenuItemModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      imageUrl: img,
      categoryId: int.tryParse(json['category_id']?.toString() ?? '') ?? 0,
      calories: int.tryParse(json['calories']?.toString() ?? '') ?? 350,
      prepTimeMinutes: int.tryParse(json['prep_time_minutes']?.toString() ?? '') ?? 15,
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      reviewCount: int.tryParse(json['review_count']?.toString() ?? '') ?? 100,
      isPopular: isPopular,
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
