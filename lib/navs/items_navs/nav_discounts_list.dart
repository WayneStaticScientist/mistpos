import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/screens/basic/screen_edit_discount.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class NavDiscountsList extends StatefulWidget {
  const NavDiscountsList({super.key});

  @override
  State<NavDiscountsList> createState() => _NavDiscountsListState();
}

class _NavDiscountsListState extends State<NavDiscountsList> {
  final _userController = Get.find<UserController>();
  final _itemController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_itemController.syncingDiscounts.value) {
        return Center(child: MistLoader1());
      }
      if (_itemController.syncingDiscountsFailed.value.isNotEmpty) {
        return Center(
          child: Text(_itemController.syncingDiscountsFailed.value),
        );
      }
      if (_itemController.discounts.isEmpty) {
        return Center(child: Text("No Discounts"));
      }
      return ListView.builder(
        itemCount: _itemController.discounts.length,
        itemBuilder: (context, index) {
          final model = _itemController.discounts[index];
          return ListTile(
            onTap: () {
              Get.to(() => ScreenEditDiscount(model: model));
            },
            leading: Iconify(Bx.bxs_discount, color: AppTheme.color(context)),
            title: Text(model.name),
            subtitle:
                (model.percentage
                        ? "${model.value}%"
                        : CurrenceConverter.getCurrenceFloatInStrings(
                            model.value,
                            _userController.user.value?.baseCurrence ?? '',
                          ))
                    .text(),
            trailing: IconButton(
              onPressed: () {
                _alertDelete(model);
              },
              icon: Icon(Icons.delete),
            ),
          );
        },
      );
    });
  }

  void _alertDelete(DiscountModel model) {
    Get.defaultDialog(
      title: "Delete",
      content: "Are you sure you want to delete ${model.name}".text(),
      actions: [
        "close".text().textButton(
          onPressed: () {
            Get.back();
          },
        ),
        "delete".text().textButton(
          onPressed: () {
            Get.back();
            _itemController.deleteDiscount(model.hexId);
          },
        ),
      ],
    );
  }
}
