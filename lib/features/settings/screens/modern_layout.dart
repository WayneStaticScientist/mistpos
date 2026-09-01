import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/themes/app_theme.dart';

class MistMordernLayout extends StatelessWidget {
  final List<Widget> children;
  final String label;
  const MistMordernLayout({
    super.key,
    required this.label,
    required this.children,
  });

  static Widget get divider => Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: isDark
                ? Colors.white.withAlpha(10)
                : Colors.black.withAlpha(10),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withAlpha(10)
                  : Colors.black.withAlpha(10),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ],
    );
  }
}
