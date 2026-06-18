import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/themes/app_theme.dart';

class CardsCategory extends StatelessWidget {
  final String category;
  final bool? isSelected;
  final Function()? onTap;
  const CardsCategory({
    super.key,
    required this.category,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = isSelected == true;
    final primary = Get.theme.colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Selected: subtle primary tint fill, not harsh solid
          color: selected
              ? primary.withAlpha(isDark ? 40 : 30)
              : AppTheme.surface(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? primary.withAlpha(isDark ? 160 : 180)
                : (isDark
                    ? Colors.white.withAlpha(12)
                    : Colors.grey.withAlpha(35)),
            width: 1,
          ),
        ),
        child: Text(
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
      ),
    );
  }
}
