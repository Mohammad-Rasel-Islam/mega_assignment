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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      menuItemId: int.tryParse(json['menu_item_id']?.toString() ?? '') ?? 0,
      ingredientName: json['ingredient_name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      quantityGm: int.tryParse(json['quantity_gm']?.toString() ?? '') ?? 50,
      baseServings: int.tryParse(json['base_servings']?.toString() ?? '') ?? 1,
    );
  }

  /// Calculates scaled gram amount for given number of servings.
  int getScaledQuantity(int servings) {
    if (baseServings <= 0) return quantityGm * servings;
    return ((quantityGm / baseServings) * servings).round();
  }
}
