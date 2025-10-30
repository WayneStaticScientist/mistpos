import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:mistpos/themes/app_theme.dart';

class CardsRecent extends StatelessWidget {
  final ItemSavedItemsModel savedModel;
  const CardsRecent({super.key, required this.savedModel});

  @override
  Widget build(BuildContext context) {
    return [
          [
            Iconify(Bx.cart, color: Get.theme.colorScheme.primary),
            12.gapWidth,
            savedModel.name.text(),
          ].row(),
          14.gapHeight,
          [
            "${savedModel.dataMap.length} items".text(),
            12.gapWidth,
            "on sale".text(),
          ].row(),
          14.gapHeight,
          "open cart"
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
            color: AppTheme.surface.withAlpha(100),
            borderRadius: BorderRadius.circular(30),
          ),
        )
        .sizedBox(height: 60, width: 200);
  }
}
