import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenManualCart extends StatefulWidget {
  final ItemModel item;
  const ScreenManualCart({super.key, required this.item});

  @override
  State<ScreenManualCart> createState() => _ScreenManualCartState();
}

class _ScreenManualCartState extends State<ScreenManualCart> {
  final _itemsListController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();
  double count = 1;
  double price = 0;
  double floatAmount = 0;
  final Map<String, bool> dataMap = {};
  final priceTextController = TextEditingController();
  final _countController = TextEditingController(text: "1");
  @override
  Widget build(BuildContext context) {
    price =
        (double.tryParse(_countController.text) ?? 0) *
        (widget.item.price + floatAmount);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          CurrenceConverter.getCurrenceFloatInStrings(
            price,
            _userController.user.value?.baseCurrence ?? '',
          ).text().padding(EdgeInsets.only(right: 14)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          "Quantity".text(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          18.gapHeight,
          TextField(
            keyboardType: TextInputType.number,
            controller: _countController,
            onChanged: (e) => setState(() {}),
            decoration: InputDecoration(
              label: "Quantity".text(),
              fillColor: Colors.grey.withAlpha(30),
              filled: true,
            ),
          ),
          18.gapHeight,
          if (widget.item.modifiers != null &&
              widget.item.modifiers!.isNotEmpty)
            _generatedModifiers(),
          if (widget.item.price == 0) ...[
            18.gapHeight,
            "Item Price".text(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            MistFormInput(
              label: "Price Value",
              icon: (_userController.user.value?.baseCurrence ?? 'USD').text(
                style: TextStyle(fontSize: 8),
              ),
              keyboardType: TextInputType.number,
              controller: priceTextController,
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          child: "Add to Cart"
              .text()
              .elevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              )
              .padding(EdgeInsets.all(12)),
        ),
      ),
    );
  }

  Widget _generatedModifiers() {
    return Obx(
      () =>
          [
            "Modifiers".text(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (_itemsListController.modifiersLoading.value) MistLoader1(),
            18.gapHeight,
            ...widget.item.modifiers!.map<Widget>((e) => _makeModifierTab(e)),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
    );
  }

  Widget _makeModifierTab(String id) {
    try {
      final modifier = _itemsListController.modifiers.firstWhere(
        (element) => element.hexId == id,
      );
      return [
        modifier.name.text(
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...modifier.list.map<Widget>((e) {
          return Card(
            child: ListTile(
              title: e.key.text(),
              subtitle: CurrenceConverter.selectedCurrencyInString(
                e.value,
              ).text(),
              tileColor: dataMap.containsKey("$id-${e.key}${e.value}")
                  ? Get.theme.colorScheme.primary
                  : null,
            ),
          ).onTap(() => _addToMap("$id-${e.key}${e.value}", e.value));
        }),
      ].column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } catch (e) {
      return SizedBox();
    }
  }

  void _addToMap(String s, double amount) {
    if (dataMap.containsKey(s)) {
      dataMap.remove(s);
      setState(() {
        floatAmount -= amount;
      });
    } else {
      dataMap[s] = true;
      setState(() {
        floatAmount += amount;
      });
    }
  }

  void _addToCart() {
    double? addenum = 0.0;
    if (widget.item.price == 0 && priceTextController.text.isEmpty) {
      Toaster.showError("price is required for non price items");
      return;
    }
    if (widget.item.price == 0) {
      final val = double.tryParse(priceTextController.text);
      if (val == null) {
        Toaster.showError("invalid price");
        return;
      }
      widget.item.price = CurrenceConverter.baseCurrency(val);
    }
    if (widget.item.soldBy == "Each") {
      final int? projected = int.tryParse(_countController.text);
      if (projected == null || projected <= 0) {
        Toaster.showError(
          "Invalid descrete number for non weighted items , valids numbers are only  1 , 2 , 3 and so on",
        );
        return;
      }
    } else {
      double? projected = double.tryParse(_countController.text);
      if (projected == null) {
        Toaster.showError("Invalid quantity number");
        return;
      }
    }
    _itemsListController.addSelectedItem(
      widget.item,
      addenum: addenum,
      count: double.tryParse(_countController.text) ?? 1,
      qouted: floatAmount,
      dataMap: dataMap,
    );
    Get.back();
  }
}
