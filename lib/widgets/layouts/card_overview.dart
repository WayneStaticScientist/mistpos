import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';

class CardOverview extends StatelessWidget {
  final String label;
  final String value;
  const CardOverview({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return [
          label.text(maxLines: 1, overflow: TextOverflow.ellipsis),
          value.text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ]
        .column(crossAxisAlignment: CrossAxisAlignment.start)
        .sizedBox(height: 100, width: 150)
        .padding(EdgeInsets.all(12))
        .decoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
        );
  }
}
