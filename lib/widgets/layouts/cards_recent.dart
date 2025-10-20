import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/currence_converter.dart';

class CardsRecent extends StatelessWidget {
  final String label;
  final int quantity;
  final int price;
  const CardsRecent({
    super.key,
    required this.label,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return [
          [
            Iconify(Bx.cart, color: Get.theme.colorScheme.primary),
            12.gapWidth,
            label.text(),
          ].row(),
          14.gapHeight,
          ["$quantity items".text(), 12.gapWidth, "on sale".text()].row(),
          14.gapHeight,
          CurrenceConverter.getCurrenceInStrings(price)
              .text(style: TextStyle(color: Colors.white))
              .padding(EdgeInsets.symmetric(horizontal: 24, vertical: 12))
              .decoratedBox(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
        ]
        .column()
        .padding(EdgeInsets.all(29))
        .decoratedBox(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        )
        .sizedBox(height: 60, width: 200);
  }
}
