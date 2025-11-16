import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';

class CardOverview extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final Color? textColor;
  const CardOverview({
    super.key,
    this.color,
    this.textColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return [
          label.text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor),
          ),
          18.gapHeight,
          value.text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ]
        .column(crossAxisAlignment: CrossAxisAlignment.start)
        .sizedBox(width: 150, height: 100)
        .padding(EdgeInsets.all(12))
        .decoratedBox(
          decoration: BoxDecoration(
            color: color ?? AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
        )
        .padding(EdgeInsets.symmetric(horizontal: 3));
  }
}
