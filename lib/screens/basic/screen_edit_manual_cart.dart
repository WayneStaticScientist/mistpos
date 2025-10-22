import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';

class ScreenEditManualCart extends StatefulWidget {
  final Map<String, dynamic> map;
  const ScreenEditManualCart({super.key, required this.map});

  @override
  State<ScreenEditManualCart> createState() => _ScreenEditManualCartState();
}

class _ScreenEditManualCartState extends State<ScreenEditManualCart> {
  final _itemsListController = Get.find<ItemsController>();
  late int count = widget.map['count'] as int;
  late int track = widget.map['count'] as int;
  double price = 0;
  late double floatAmount = widget.map['qouted'] as double? ?? 0.0;
  late final Map<String, bool> dataMap =
      widget.map['dataMap'] as Map<String, bool>? ?? {};
  late final item = widget.map['item'] as ItemModel;
  late final priceTextController = TextEditingController(
    text: (widget.map['addenum'] as double? ?? 0.0).toString(),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    price = count * item.price + floatAmount;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: ["$price".text().padding(EdgeInsets.only(right: 14))],
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
          if (item.modifierIds != null && item.modifierIds!.isNotEmpty)
            _generatedModifiers(),
          if (item.price == 0) ...[
            18.gapHeight,
            "Item Price".text(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            MistFormInput(
              label: "Price Value",
              keyboardType: TextInputType.number,
              controller: priceTextController,
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          child: "Update Cart"
              .text()
              .elevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.primary,
                  foregroundColor: Get.theme.colorScheme.onPrimary,
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
    if (count >= item.stockQuantity && item.trackStock) {
      Toaster.showError("stock out");
      return;
    }
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
      ...item.modifierIds!.map<Widget>((e) => _makeModifierTab(e)),
    ].column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _makeModifierTab(int id) {
    try {
      final modifier = _itemsListController.modifiers.firstWhere(
        (element) => element.id == id,
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
      addenum = double.tryParse(priceTextController.text);
      if (addenum == null) {
        Toaster.showError("invalid price");
        return;
      }
    }

    _itemsListController.addSelectedItem(
      item,
      count: count,
      dataMap: dataMap,
      addenum: addenum,
      qouted: floatAmount,
      restoreAmount: track - count,
    );
    Get.back();
  }
}
