import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/screens/basic/screen_select_discount.dart';

class ScreenEditManualCart extends StatefulWidget {
  final Map<String, dynamic> map;
  const ScreenEditManualCart({super.key, required this.map});

  @override
  State<ScreenEditManualCart> createState() => _ScreenEditManualCartState();
}

class _ScreenEditManualCartState extends State<ScreenEditManualCart> {
  final _itemsListController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();
  late int count = widget.map['count'] as int;
  late int track = widget.map['count'] as int;
  late String? discountId = widget.map['discountId'] as String?;
  late bool percentageDiscount =
      widget.map['percentageDiscount'] as bool? ?? true;
  late double discount = (widget.map['discount'] as num?)?.toDouble() ?? 0.0;
  double price = 0;
  late double floatAmount = widget.map['qouted'] as double? ?? 0.0;
  late final Map<String, bool> dataMap =
      widget.map['dataMap'] as Map<String, bool>? ?? {};
  late final item = widget.map['item'] as ItemModel;
  late final priceTextController = TextEditingController(
    text: (CurrenceConverter.selectedCurrency(item.price)).toString(),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    price = count * item.price + floatAmount;
    if (discountId != null) {
      price = !percentageDiscount
          ? (price - discount)
          : (price - discount * price / 100);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          CurrenceConverter.getCurrenceFloatInStrings(
                price,
                _userController.user.value?.baseCurrence ?? '',
              )
              .text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
              .padding(EdgeInsets.only(right: 14)),
          (percentageDiscount
                  ? "$discount%"
                  : CurrenceConverter.getCurrenceFloatInStrings(
                      discount,
                      _userController.user.value?.baseCurrence ?? '',
                    ))
              .text(style: TextStyle(color: Colors.red, fontSize: 12))
              .padding(EdgeInsets.only(right: 14))
              .visibleIf(discountId != null),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          "Quantity".text(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          18.gapHeight,
          [
            IconButton.filled(
              onPressed: _dec,
              icon: Iconify(Bx.chevron_left, color: Colors.white, size: 50),
            ),
            [
              "$count".text(
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ].row(mainAxisAlignment: MainAxisAlignment.center).expanded1,
            IconButton.filled(
              onPressed: _inc,
              icon: Iconify(Bx.chevron_right, color: Colors.white, size: 50),
            ),
          ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          18.gapHeight,
          if (item.modifiers != null && item.modifiers!.isNotEmpty)
            _generatedModifiers(),
          if (item.price == 0) ...[
            18.gapHeight,
            "Item Price".text(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            MistFormInput(
              label: "Price Value",
              icon: (_userController.user.value?.baseCurrence ?? 'USD').text(),
              keyboardType: TextInputType.number,
              controller: priceTextController,
            ),
          ],
          18.gapHeight,
          [
                MistFormButton(
                  label: "Remove Discount",
                  onTap: _removeDiscount,
                  fillColor: Colors.red,
                ),
              ]
              .row(mainAxisAlignment: MainAxisAlignment.center)
              .visibleIf(discountId != null),

          18.gapHeight,
          [
            MistFormButton(
              label: discountId == null ? "Add Discount" : "Edit Discount",
              onTap: _addDiscount,
            ),
          ].row(mainAxisAlignment: MainAxisAlignment.center),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          child: "Update Cart"
              .text()
              .elevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Get.theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              )
              .padding(EdgeInsets.all(12)),
        ),
      ),
    );
  }

  void _dec() {
    if (count <= 1) return;
    setState(() {
      count--;
    });
  }

  void _inc() {
    setState(() {
      count++;
    });
  }

  Widget _generatedModifiers() {
    return [
      "Modifiers".text(
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      18.gapHeight,
      ...item.modifiers!.map<Widget>((e) => _makeModifierTab(e)),
    ].column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              subtitle: "${e.value}".text(),
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
    if (item.price == 0 && priceTextController.text.isEmpty) {
      Toaster.showError("price is required for non price items");
      return;
    }
    if (item.price == 0) {
      double? val = double.tryParse(priceTextController.text);
      if (val == null || val <= 0) {
        Toaster.showError("invalid price");
        return;
      }
      item.price = CurrenceConverter.baseCurrency(val);
    }

    _itemsListController.addSelectedItem(
      item,
      count: count,
      dataMap: dataMap,
      addenum: addenum,
      qouted: floatAmount,
      restoreAmount: track - count,
      discountId: discountId,
      discount: discount,
      percentageDiscount: percentageDiscount,
    );
    Get.back();
  }

  Future<void> _addDiscount() async {
    final result = await Get.to(() => ScreenSelectDiscount());
    if (result == null) return;
    setState(() {
      discount = result.value;
      discountId = result.hexId;
      percentageDiscount = result.percentage;
    });
  }

  void _removeDiscount() {
    setState(() {
      discount = 0.0;
      discountId = null;
    });
  }
}
