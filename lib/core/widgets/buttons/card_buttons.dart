import 'package:exui/exui.dart';
import 'package:flutter/material.dart';

class CardButtons extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color? color;
  final Function()? onTap;
  const CardButtons({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child:
          InkWell(
            onTap: onTap,
            child: [12.gapHeight, icon, label.text()].column(),
          ).decoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: color,
            ),
          ),
    ).padding(EdgeInsets.all(12));
  }
}
