import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/category_model.dart';
import '../utils/constants.dart';
import 'shimmer_loading.dart';

class CategoryIconWidget extends StatelessWidget {
  final CategoryModel? category;
  final bool isAll;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryIconWidget({
    Key? key,
    this.category,
    this.isAll = false,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String label = isAll ? 'All' : (category?.name ?? '');

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.categorySelected : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.categorySelectedBorder : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.categorySelectedBorder.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Icon Badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
              ),
              child: ClipOval(
                child: isAll
                    ? Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      )
                    : (category?.imageUrl != null && category!.imageUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: category!.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ShimmerBox(width: 32, height: 32, borderRadius: 16),
                            errorWidget: (context, url, error) => Center(
                              child: Text(
                                category?.icon ?? '🛍️',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              category?.icon ?? '🛍️',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
