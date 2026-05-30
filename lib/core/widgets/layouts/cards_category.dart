import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
    bool selected = isSelected == true;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: selected ? Get.theme.colorScheme.primary : AppTheme.surface(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? Get.theme.colorScheme.primary : Colors.grey.withAlpha(50),
            width: 1,
          ),
          boxShadow: selected ? [
            BoxShadow(
              color: Get.theme.colorScheme.primary.withAlpha(80),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ] : [],
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected ? Colors.white : AppTheme.color(context),
            ),
          ),
        ),
      ),
    );
  }
}
