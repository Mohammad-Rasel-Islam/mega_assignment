import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item_model.dart';
import '../models/ingredient_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../utils/constants.dart';
import '../utils/price_formatter.dart';
import '../widgets/custom_button.dart';
import '../widgets/shimmer_loading.dart';

class FoodDetailScreen extends StatefulWidget {
  final MenuItemModel item;

  const FoodDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  // Serving multiplier: 1 = base servings, 2 = double, etc.
  int _servings = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _servings = widget.item.ingredients.isNotEmpty
        ? (widget.item.ingredients.first.baseServings > 0
            ? widget.item.ingredients.first.baseServings
            : 1)
        : 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final success = await cartProvider.addToCart(
      productId: widget.item.id,
      color: 'Default',
      size: 'Standard',
      quantity: _quantity,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle_rounded : Icons.error_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  success
                      ? '${widget.item.name} added to cart!'
                      : cartProvider.error ?? 'Failed to add to cart',
                ),
              ),
            ],
          ),
          backgroundColor: success ? AppColors.accentGreen : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavoriteProvider>();
    final isFav = favProv.isFavorite(widget.item.id);
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Expanded Content ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Image Section ──────────────────────────
                  Stack(
                    children: [
                      // Food Image
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const ShimmerBox(
                            width: double.infinity,
                            height: 300,
                            borderRadius: 0,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.restaurant_rounded,
                                  size: 80, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay at top for buttons
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 90,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.45),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Back Button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        child: _CircleButton(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: AppColors.textPrimary, size: 22),
                        ),
                      ),

                      // Favourite Button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        right: 16,
                        child: _CircleButton(
                          onTap: () => favProv.toggleFavorite(item.id, menuItem: item),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(isFav),
                              color: isFav
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: 22,
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay at bottom of image
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.background,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Details Container ───────────────────────────
                  Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & Rating Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.accentYellow
                                    .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 16,
                                      color: AppColors.accentYellow),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    ' (${item.reviewCount})',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Info chips row
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.timer_outlined,
                              label: '${item.prepTimeMinutes} min',
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            _InfoChip(
                              icon: Icons.local_fire_department_rounded,
                              label: '${item.calories} kcal',
                              color: AppColors.accentYellow,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Price
                        Text(
                          PriceFormatter.format(item.price),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tab Bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: AppColors.textSecondary,
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                            unselectedLabelStyle:
                                const TextStyle(fontSize: 13),
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: 'Description'),
                              Tab(text: 'Ingredients'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tab Content
                        SizedBox(
                          height: _tabController.index == 1 &&
                                  item.ingredients.isNotEmpty
                              ? 260
                              : 120,
                          child: AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, _) {
                              return TabBarView(
                                controller: _tabController,
                                children: [
                                  // Description tab
                                  SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Text(
                                      item.description.isNotEmpty
                                          ? item.description
                                          : 'A delicious dish crafted with the finest ingredients.',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        height: 1.65,
                                      ),
                                    ),
                                  ),

                                  // Ingredients tab
                                  _IngredientsTab(
                                    ingredients: item.ingredients,
                                    servings: _servings,
                                    onServingsChanged: (v) {
                                      setState(() => _servings = v);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Add to Cart Bar ────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              14 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Row(
              children: [
                // Quantity stepper
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepperButton(
                        icon: Icons.remove,
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _StepperButton(
                        icon: Icons.add,
                        onPressed: () => setState(() => _quantity++),
                        isActive: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Add to Cart button
                Expanded(
                  child: CustomButton(
                    text:
                        'Add to Cart • ${PriceFormatter.format(item.price * _quantity)}',
                    icon: Icons.shopping_bag_rounded,
                    onPressed: _handleAddToCart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ingredients Tab Widget ───────────────────────────────────────────────────

class _IngredientsTab extends StatelessWidget {
  final List<IngredientModel> ingredients;
  final int servings;
  final ValueChanged<int> onServingsChanged;

  const _IngredientsTab({
    required this.ingredients,
    required this.servings,
    required this.onServingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Center(
        child: Text(
          'No ingredient information available.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    final base = ingredients.first.baseServings > 0
        ? ingredients.first.baseServings
        : 1;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Serving selector
          Row(
            children: [
              const Text(
                'Servings:',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 13),
              ),
              const SizedBox(width: 12),
              _StepperButton(
                icon: Icons.remove,
                onPressed:
                    servings > base ? () => onServingsChanged(servings - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$servings',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary),
                ),
              ),
              _StepperButton(
                icon: Icons.add,
                isActive: true,
                onPressed: () => onServingsChanged(servings + 1),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ingredients list
          ...ingredients.map((ing) {
            final scaledQty = base > 0
                ? (ing.quantityGm * servings / base).toStringAsFixed(0)
                : '${ing.quantityGm}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ing.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: ing.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.eco_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                          )
                        : const Icon(Icons.eco_rounded,
                            color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ing.ingredientName,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '$scaledQty g',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Small helper widgets ─────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _CircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12), blurRadius: 8)
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;

  const _StepperButton({
    required this.icon,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed == null
              ? Colors.grey[100]
              : isActive
                  ? AppColors.primary
                  : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed == null
              ? Colors.grey[400]
              : isActive
                  ? Colors.white
                  : AppColors.primary,
        ),
      ),
    );
  }
}
