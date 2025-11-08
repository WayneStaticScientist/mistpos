import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/screens/basic/screen_selected_items_readjust.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/screen_checkout.dart';

class LayoutCashout extends StatefulWidget {
  final GlobalKey bottomBarKey;
  const LayoutCashout({super.key, required this.bottomBarKey});

  @override
  State<LayoutCashout> createState() => _LayoutCashoutState();
}

class _LayoutCashoutState extends State<LayoutCashout> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.bottomBarKey,
      child: Row(
        children: [
          [
                CurrenceConverter.getCurrenceFloatInStrings(
                      _itemsListController.totalPrice.value,
                      _userController.user.value?.baseCurrence ?? '',
                    )
                    .text(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                    .textButton(
                      onPressed: () =>
                          Get.to(() => ScreenSelectedItemsReadjust()),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Get.theme.colorScheme.primary,
                      ),
                    ),
                18.gapWidth,
                "${_itemsListController.checkOutItems.length} items".text(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ]
              .row()
              .padding(EdgeInsets.all(3))
              .decoratedBox(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              )
              .expanded1,
          12.gapWidth,
          "Checkout"
              .text(
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
              .textButton(onPressed: () => Get.to(() => ScreenCheckout())),
        ],
      ).padding(EdgeInsets.all(10)),
    );
  }
}
