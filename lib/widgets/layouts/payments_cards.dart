import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';

class MistPaymentCards extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback ontTap;
  const MistPaymentCards({
    super.key,
    required this.label,
    this.color,
    required this.ontTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.375 / 2.125,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
          side: BorderSide(color: color ?? Colors.red),
        ),
        color: AppTheme.surface(context),
        child: [label.text()].column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    ).sizedBox(height: 90).onTap(ontTap);
  }
}
