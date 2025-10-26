import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MistFormButton extends StatelessWidget {
  final bool? isLoading;
  final String label;
  final Widget icon;
  final Function()? onTap;
  const MistFormButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return label
        .text(
          style: TextStyle(
            color: isLoading == true ? Colors.white70 : Colors.white,
          ),
        )
        .outlinedIconButton(
          onPressed: isLoading == true ? null : onTap,
          icon: isLoading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : icon,
          style: OutlinedButton.styleFrom(
            iconColor: Colors.white,
            backgroundColor: Get.theme.colorScheme.primary,
            minimumSize: Size(250, 50),
          ),
        );
  }
}
