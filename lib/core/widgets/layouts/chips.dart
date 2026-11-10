import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/themes/app_theme.dart';

class MistChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Widget? icon;
  const MistChip({
    super.key,
    required this.label,
    required this.selected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;
    return Chip(
      avatar: selected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : icon,
      side: selected
          ? BorderSide(color: primary, width: 1.5)
          : BorderSide(color: Colors.grey.withAlpha(50)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      label: label.text(
        style: TextStyle(
          color: selected ? Colors.white : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: selected
          ? primary
          : AppTheme.surface(context),
    ).paddingZero.padding(const EdgeInsets.all(5));
  }
}
