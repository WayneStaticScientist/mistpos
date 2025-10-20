import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MistFormButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final Function()? onTap;
  const MistFormButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return label
        .text(style: TextStyle(color: Colors.white))
        .outlinedIconButton(
          onPressed: onTap,
          icon: icon,
          style: OutlinedButton.styleFrom(
            iconColor: Colors.white,
            backgroundColor: Get.theme.colorScheme.primary,
            minimumSize: Size(250, 50),
          ),
        );
  }
}
