import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';

class ScreensSeleectedDiscountsView extends StatefulWidget {
  const ScreensSeleectedDiscountsView({super.key});

  @override
  State<ScreensSeleectedDiscountsView> createState() =>
      _ScreensSeleectedDiscountsViewState();
}

class _ScreensSeleectedDiscountsViewState
    extends State<ScreensSeleectedDiscountsView> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Invoice Discounts".text()),
      body: Obx(() {
        if (_itemsListController.selectedDiscounts.isEmpty) {
          return "No Selected Discounts".text().center();
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            return _buildTile(_itemsListController.selectedDiscounts[index]);
          },
          itemCount: _itemsListController.selectedDiscounts.length,
        );
      }),
    );
  }

  ListTile _buildTile(DiscountModel discount) {
    return ListTile(
      title: discount.name.text(),
      leading: Iconify(Carbon.money, color: Get.theme.colorScheme.primary),
      trailing: IconButton(
        onPressed: () {
          _itemsListController.removeDiscountFromProduct(discount);
        },
        icon: Icon(Icons.close),
      ),
      subtitle:
          (discount.percentage
                  ? "${discount.value.toStringAsFixed(2)}%"
                  : CurrenceConverter.getCurrenceFloatInStrings(
                      discount.value,
                      _userController.user.value?.baseCurrence ?? '',
                    ))
              .text(),
    );
  }
}
