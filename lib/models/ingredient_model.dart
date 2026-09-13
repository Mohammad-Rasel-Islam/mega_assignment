/// Represents an ingredient item belonging to a food menu item.
class IngredientModel {
  final int id;
  final int menuItemId;
  final String ingredientName;
  final String imageUrl;
  final int quantityGm;
  final int baseServings;

  IngredientModel({
    required this.id,
    required this.menuItemId,
    required this.ingredientName,
    required this.imageUrl,
    required this.quantityGm,
    this.baseServings = 1,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] as int? ?? 0,
      menuItemId: json['menu_item_id'] as int? ?? 0,
      ingredientName: json['ingredient_name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      quantityGm: json['quantity_gm'] as int? ?? 50,
      baseServings: json['base_servings'] as int? ?? 1,
    );
  }

  /// Calculates scaled gram amount for given number of servings.
  int getScaledQuantity(int servings) {
    if (baseServings <= 0) return quantityGm * servings;
    return ((quantityGm / baseServings) * servings).round();
  }
}
