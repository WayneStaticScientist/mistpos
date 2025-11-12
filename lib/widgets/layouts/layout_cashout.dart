import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_checkout.dart';
import 'package:mistpos/screens/basic/screen_selected_items_readjust.dart';

class LayoutCashout extends StatefulWidget {
  final GlobalKey bottomBarKey;
  const LayoutCashout({super.key, required this.bottomBarKey});
  @override
  State<LayoutCashout> createState() => _LayoutCashoutState();
}

class _LayoutCashoutState extends State<LayoutCashout> {
  static const double moveDistance = 10.0;
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  static const Duration moveDuration = Duration(seconds: 2);
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.bottomBarKey,
      child: Row(
        children: [
          Obx(
            () =>
                [
                      Badge.count(
                        count: _itemsListController.checkOutItems.length,
                        child:
                            CurrenceConverter.getCurrenceFloatInStrings(
                                  _itemsListController.totalPrice.value,
                                  _userController.user.value?.baseCurrence ??
                                      '',
                                )
                                .text(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                                .textButton(
                                  onPressed: () => Get.to(
                                    () => ScreenSelectedItemsReadjust(),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        Get.theme.colorScheme.primary,
                                  ),
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
          ),
          12.gapWidth,
          Chip(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(side: BorderSide.none),
            avatar: Iconify(Bx.chevron_right, color: AppTheme.color(context))
                .animate(onComplete: (controller) => controller.reverse())
                .moveX(begin: 0, end: moveDistance, duration: moveDuration),
            label: "Checkout".text(
              style: TextStyle(
                color: AppTheme.color(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ).textButton(onPressed: () => Get.to(() => ScreenCheckout())),
        ],
      ).padding(EdgeInsets.all(5)),
    );
  }
}
