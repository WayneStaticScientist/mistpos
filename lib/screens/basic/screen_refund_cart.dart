import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/item_receit_item.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/items_controller.dart';

class ScreenRefundCart extends StatefulWidget {
  final ItemReceitModel receitModel;
  const ScreenRefundCart({super.key, required this.receitModel});

  @override
  State<ScreenRefundCart> createState() => _ScreenRefundCartState();
}

class _ScreenRefundCartState extends State<ScreenRefundCart> {
  bool _loading = false;
  late ItemReceitModel localReceit;
  final _itemController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    localReceit = localReceit;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 1. Blocks the automatic "silent" back navigation
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back(result: localReceit);
      },
      child: Scaffold(
        appBar: AppBar(title: "Refund Cart".text()),
        body: _loading
            ? Center(
                child: CircularProgressIndicator().sizedBox(
                  height: 40,
                  width: 40,
                ),
              )
            : SingleChildScrollView(
                child: [
                  18.gapHeight,
                  ...localReceit.items.indexed.map(
                    (e) => ListTile(
                      tileColor: e.$2.refunded
                          ? Colors.red.withAlpha(100)
                          : null,
                      onTap: () => _refund(e.$1, e.$2),
                      subtitle:
                          "${e.$2.count.toString()} x ${CurrenceConverter.getCurrenceFloatInStrings(e.$2.price + e.$2.addenum, _userController.user.value?.baseCurrence ?? '')}"
                              .text(),
                      title: e.$2.name.text(),
                      trailing: CurrenceConverter.getCurrenceFloatInStrings(
                        (e.$2.price + e.$2.addenum) * e.$2.count,
                        _userController.user.value?.baseCurrence ?? '',
                      ).text(),
                    ),
                  ),
                  18.gapHeight,
                  Divider(color: Colors.grey, thickness: 1),
                  18.gapHeight,
                  ListTile(
                    title: 'Total'.text(),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      localReceit.total,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(),
                  ),
                  ListTile(
                    title: localReceit.payment.text(),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      localReceit.amount,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(),
                  ),
                ].column(),
              ),
      ),
    );
  }

  void _refund(int index, ItemReceitItem e) {
    if (e.count > 1) {
      _openModal(index, e);
      return;
    }
    if (e.count == 1) {
      _proceedToRefund(index, e, e.count);
    }
  }

  void _openModal(int index, ItemReceitItem e) {
    final controller = TextEditingController(text: e.count.toString());
    Get.bottomSheet(
      SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            24.gapHeight,
            MistFormInput(
              label: "Item Quanity",
              controller: controller,
              keyboardType: TextInputType.number,
            ),
            24.gapHeight,

            "Refund".text().textButton(
              onPressed: () {
                final count = int.tryParse(controller.text);
                if (count == null) {
                  Toaster.showError("Invalid number");
                  return;
                }
                if (count > e.count) {
                  Toaster.showError("number should be less than ${e.count}");
                  return;
                }
                Get.back();
                _proceedToRefund(index, e, count);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.colorScheme.surface,
      isScrollControlled: true,
    );
  }

  void _proceedToRefund(int index, ItemReceitItem e, int count) {
    Get.dialog(
      AlertDialog(
        title: Text('Refund ${e.name}'),
        content: "Refund $count items".text(),
        actions: [
          "close".text().textButton(onPressed: () => Get.back()),
          "Refund".text().textButton(
            onPressed: () => _confirmRefund(index, e, count),
          ),
        ],
      ),
    );
  }

  void _confirmRefund(int index, ItemReceitItem e, int count) async {
    Get.back();
    setState(() {
      _loading = true;
    });
    final state = await _itemController.refundItem(
      localReceit,
      e,
      count,
      index,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
    });
    if (state == null) {
      return;
    }
    setState(() {
      localReceit = state;
    });
    Toaster.showSuccess("refunded");
  }
}
