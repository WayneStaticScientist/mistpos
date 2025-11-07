import 'package:exui/exui.dart';
import 'package:flutter/widgets.dart';
import 'package:mistpos/themes/app_theme.dart';

class MistMordernLayout extends StatelessWidget {
  final List<Widget> children;
  final String label;
  const MistMordernLayout({
    super.key,
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return [
          label.text(
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          ...children,
        ]
        .column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        )
        .padding(EdgeInsets.all(12))
        .decoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
          ),
        );
  }
}
