import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/screens/basic/screen_checkout.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/avatars.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_edit_manual_cart.dart';
import 'package:mistpos/screens/basic/screens_seleected_discounts_view.dart';

class ScreenSelectedItemsReadjust extends StatefulWidget {
  const ScreenSelectedItemsReadjust({super.key});

  @override
  State<ScreenSelectedItemsReadjust> createState() =>
      _ScreenSelectedItemsReadjustState();
}

class _ScreenSelectedItemsReadjustState
    extends State<ScreenSelectedItemsReadjust> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Invoice Cart".text(),
        actions: [
          IconButton(
            onPressed: _clearCart,
            icon: Iconify(Bx.trash_alt, color: AppTheme.color(context)),
          ),
          IconButton(
            onPressed: _savePayment,

            icon: _loading
                ? CircularProgressIndicator()
                : Iconify(Carbon.save, color: AppTheme.color(context)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: [
          Obx(
            () => "View discounts"
                .text()
                .elevatedButton(
                  onPressed: () =>
                      Get.to(() => ScreensSeleectedDiscountsView()),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Get.theme.colorScheme.primary,
                  ),
                )
                .padding(EdgeInsets.all(8))
                .visibleIf(_itemsListController.discounts.isNotEmpty),
          ),
        ].row(mainAxisAlignment: MainAxisAlignment.center),
      ),
      floatingActionButton: "Checkout"
          .text()
          .elevatedButton(
            onPressed: () => Get.to(() => ScreenCheckout()),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Get.theme.colorScheme.primary,
            ),
          )
          .padding(EdgeInsets.all(8)),
      body: [
        "Tap on the item to change discounts and modifiers"
            .text()
            .padding(EdgeInsets.all(8))
            .sizedBox(width: double.infinity)
            .decoratedBox(
              decoration: BoxDecoration(color: Get.theme.colorScheme.primary),
            ),
        15.gapHeight,
        Obx(() {
          final items = _itemsListController.checkOutItems;
          return ListView.builder(
            itemBuilder: (context, index) => _makeItem(items[index]),
            itemCount: items.length,
          );
        }).expanded1,
      ].column(),
    );
  }

  _clearCart() {
    Get.dialog(
      AlertDialog(
        title: "Remove Payment".text(),
        content: "are you sure you want to remove payment".text(),
        actions: [
          "No".text().textButton(onPressed: () => Get.back()),
          "Remove".text().textButton(
            onPressed: () async {
              Get.back();
              try {
                await _itemsListController.removeAllSelected();
                Get.back();
                Toaster.showSuccess("payment removed");
              } catch (e) {
                Toaster.showError("failed to remove payment : $e");
              }
            },
          ),
        ],
      ),
    );
  }

  void _savePayment() {
    final savedName = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: "Save Invoice".text(),
        content: MistFormInput(label: "Enter Save Name", controller: savedName),
        actions: [
          "Cancel".text().textButton(onPressed: () => Get.back()),
          "Save".text().textButton(onPressed: () => _saveItem(savedName.text)),
        ],
      ),
    );
  }

  void _saveItem(String text) async {
    if (text.trim().isEmpty) {
      Toaster.showError("name is required");
      return;
    }
    Get.back();
    setState(() {
      _loading = true;
    });
    try {
      await _itemsListController.saveItem(text);
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
      Get.back();
      Toaster.showSuccess("payment saved");
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      Toaster.showError("failed to save payment : $e");
    }
  }

  Widget _makeItem(Map<String, dynamic> item) {
    final model = item['item'] as ItemModel;
    final count = item['count'] as int;
    final addenum = item['addenum'] as double? ?? 0.0;
    final qouted = item['qouted'] as double? ?? 0.0;
    bool percentageDiscount = item['percentageDiscount'] as bool? ?? true;
    double price =
        count *
            (model.wholesaleActivated && count >= model.miniItems
                ? model.wholesalePrice
                : (model.price + qouted)) +
        addenum;
    double discount = (item['discount'] as num?)?.toDouble() ?? 0.0;
    if (item['discountId'] != null) {
      price = percentageDiscount
          ? price * (1 - discount / 100)
          : price - discount;
    }
    return InkWell(
          onTap: () => Get.to(() => ScreenEditManualCart(map: item)),
          child: [
            MistAvatar.getAvatar(model),
            10.gapWidth,
            [
                  model.name.text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  "Price ${CurrenceConverter.getCurrenceFloatInStrings(model.price, _userController.user.value?.baseCurrence ?? '')}"
                      .text(),
                  "Discount ${percentageDiscount ? "$discount%" : CurrenceConverter.getCurrenceFloatInStrings(discount, _userController.user.value?.baseCurrence ?? '')}"
                      .text(
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .visibleIf(item['discountId'] != null),
                  "Full Price ${CurrenceConverter.getCurrenceFloatInStrings((model.price + addenum + qouted) * count, _userController.user.value?.baseCurrence ?? '')}"
                      .text(),
                  if (model.wholesaleActivated) ...[
                    "Wholesale Price ${CurrenceConverter.getCurrenceFloatInStrings(model.wholesalePrice, _userController.user.value?.baseCurrence ?? '')}"
                        .text(),
                  ],
                  "Sub Total ${CurrenceConverter.getCurrenceFloatInStrings(price, _userController.user.value?.baseCurrence ?? '')}"
                      .text(),

                  "remove"
                      .text(
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .textIconButton(
                        onPressed: () =>
                            _itemsListController.removeSelectedItem(item),
                        icon: Iconify(Bx.trash_alt, color: Colors.red),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                      ),
                ]
                .column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                )
                .expanded1,
            [
              IconButton(
                onPressed: () => _add(item),
                icon: Iconify(Bx.plus, color: AppTheme.color(context)),
              ),
              count.toString().text(),
              IconButton(
                onPressed: () => _sub(item),
                icon: Iconify(Bx.minus, color: AppTheme.color(context)),
              ),
            ].column(mainAxisSize: MainAxisSize.min),
          ].row(),
        )
        .decoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.withAlpha(50)),
              bottom: BorderSide(color: Colors.grey.withAlpha(50)),
            ),
          ),
        )
        .padding(EdgeInsets.symmetric(vertical: 5, horizontal: 9));
  }

  void _add(Map<String, dynamic> item) {
    _itemsListController.incrItem(item, 1);
  }

  void _sub(Map<String, dynamic> item) {
    if (item['count'] <= 1) {
      return;
    }
    _itemsListController.incrItem(item, -1);
  }
}
