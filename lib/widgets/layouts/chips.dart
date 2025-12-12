import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/themes/app_theme.dart';

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
    return Chip(
      avatar: icon,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      label: label.text(
        style: TextStyle(color: selected ? Colors.white : null),
      ),
      backgroundColor: selected
          ? Get.theme.colorScheme.primary
          : AppTheme.surface(context),
    ).paddingZero.padding(EdgeInsets.all(5));
  }
}
