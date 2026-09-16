import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/constants.dart';

/// Maps category names to emojis for a food app feel.
String _categoryEmoji(String name) {
  final n = name.toLowerCase();
  if (n.contains('breakfast')) return '🍳';
  if (n.contains('lunch')) return '🍱';
  if (n.contains('dinner')) return '🍽️';
  if (n.contains('dessert')) return '🍰';
  if (n.contains('drink')) return '🥤';
  if (n.contains('snack')) return '🍟';
  if (n.contains('pizza')) return '🍕';
  if (n.contains('burger')) return '🍔';
  if (n.contains('chicken')) return '🍗';
  if (n.contains('sushi')) return '🍣';
  return '🍴';
}

class CategoryPill extends StatelessWidget {
  final CategoryModel? category;
  final bool isAll;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    this.category,
    this.isAll = false,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = isAll ? 'All' : (category?.name ?? '');
    final emoji = isAll ? '🍴' : _categoryEmoji(label);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
