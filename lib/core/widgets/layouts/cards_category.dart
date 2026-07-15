import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/themes/app_theme.dart';

class CardsCategory extends StatelessWidget {
  final String category;
  final bool? isSelected;
  final Function()? onTap;
  final Color? categoryColor;
  const CardsCategory({
    super.key,
    required this.category,
    this.isSelected,
    this.onTap,
    this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = isSelected == true;
    final primary = categoryColor ?? Get.theme.colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          // Selected: subtle tint fill of the category's own color
          color: selected
              ? primary.withAlpha(isDark ? 40 : 30)
              : AppTheme.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? primary.withAlpha(isDark ? 160 : 180)
                : (isDark
                    ? Colors.white.withAlpha(12)
                    : Colors.grey.withAlpha(35)),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (categoryColor != null && !selected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: categoryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: categoryColor!.withAlpha(80),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? primary
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
