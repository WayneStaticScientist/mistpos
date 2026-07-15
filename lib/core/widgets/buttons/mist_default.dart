import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MistButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const MistButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return text.text().elevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
