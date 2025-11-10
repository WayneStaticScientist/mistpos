import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/currence_converter.dart';

class SalesDiscountsList extends StatefulWidget {
  const SalesDiscountsList({super.key});

  @override
  State<SalesDiscountsList> createState() => _SalesDiscountsListState();
}

class _SalesDiscountsListState extends State<SalesDiscountsList> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsListController.discounts.isNotEmpty
          ? SliverList.builder(
              itemBuilder: (context, index) {
                return Obx(() {
                  final discount = _itemsListController.discounts[index];
                  final selected =
                      !(_itemsListController.selectedDiscounts.indexWhere(
                            (e) => e.hexId == discount.hexId,
                          ) ==
                          -1);
                  return ListTile(
                    onTap: () =>
                        _itemsListController.addDiscountToProduct(discount),
                    tileColor: selected
                        ? Get.theme.colorScheme.secondary.withAlpha(100)
                        : null,
                    title: discount.name.text(),
                    leading: Iconify(
                      Bx.bxs_discount,
                      color: AppTheme.color(context),
                    ),
                    trailing: selected
                        ? IconButton(
                            onPressed: () {
                              _itemsListController.removeDiscountFromProduct(
                                discount,
                              );
                            },
                            icon: Iconify(Bx.x, color: AppTheme.color(context)),
                          )
                        : null,
                    subtitle:
                        (discount.percentage
                                ? "${discount.value}%"
                                : CurrenceConverter.getCurrenceFloatInStrings(
                                    discount.value,
                                    _userController.user.value?.baseCurrence ??
                                        '',
                                  ))
                            .text(),
                  ).padding(EdgeInsets.symmetric(vertical: 12));
                });
              },
              itemCount: _itemsListController.discounts.length,
            )
          : SliverFillRemaining(
              child:
                  [
                        Iconify(Bx.cart_alt, color: AppTheme.color(context)),
                        12.gapHeight,
                        "no discounts".text(),
                      ]
                      .column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                      .center(),
            ),
    );
  }
}
