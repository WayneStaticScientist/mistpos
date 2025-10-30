import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';

class MistLoadIconButton extends StatelessWidget {
  final String label;
  final bool? isLoading;
  final Function()? onPressed;
  const MistLoadIconButton({
    super.key,
    required this.label,
    this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return label
        .text()
        .elevatedIconButton(
          icon: isLoading == true
              ? Padding(
                  padding: EdgeInsets.all(2),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : SizedBox.shrink(),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.colorScheme.onPrimary,
            foregroundColor: Colors.white,
          ),
        )
        .padding(EdgeInsets.only(right: 12));
  }
}
