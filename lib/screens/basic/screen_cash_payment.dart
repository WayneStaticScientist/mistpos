import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/models/item_receit_item.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';

class ScreenCashPayment extends StatefulWidget {
  const ScreenCashPayment({super.key});

  @override
  State<ScreenCashPayment> createState() => _ScreenCashPaymentState();
}

class _ScreenCashPaymentState extends State<ScreenCashPayment> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  bool _loading = false;

  final TextEditingController _amountController = TextEditingController();
  double change = 0.0;
  Timer? _debounce;
  String _debounceCache = "";
  bool _savingReceit = false;
  List<ItemReceitItem> _rejects = [];
  @override
  void initState() {
    super.initState();
    _startDebouncer();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Cash Payment".text(),
        actions: [
          IconButton(
            onPressed: _cancelPayment,
            icon: Iconify(Carbon.close, color: AppTheme.color),
          ),
          IconButton(
            onPressed: _savePayment,

            icon: _loading
                ? CircularProgressIndicator()
                : Iconify(Carbon.save, color: AppTheme.color),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _rejects.isEmpty
            ? [
                "Cash Payment".text(),
                CurrenceConverter.getCurrenceFloatInStrings(
                  _itemsListController.totalPrice.value,
                ).text(
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
                18.gapHeight,
                MistFormInput(
                  label: "Amount Payed",
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                ),
                18.gapHeight,
                (change < 0.0)
                    ? "Not Enough Funds".text(
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : "Change ${CurrenceConverter.getCurrenceFloatInStrings(change)}"
                          .text(),
              ].column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              )
            : _listRejects(),
      ).center().padding(EdgeInsets.all(30)),
      bottomNavigationBar: SafeArea(
        child: "Pay"
            .text()
            .elevatedIconButton(
              icon: _savingReceit
                  ? CircularProgressIndicator(color: Colors.white)
                  : Iconify(Carbon.money, color: Colors.white),
              onPressed: _pay,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                backgroundColor: change >= 0.0
                    ? Get.theme.colorScheme.primary
                    : Colors.red,
                foregroundColor: Colors.white,
              ),
            )
            .padding(EdgeInsets.all(12)),
      ),
    );
  }

  void _startDebouncer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_debounceCache == _amountController.text) {
        return;
      }
      _debounceCache = _amountController.text;
      final amount = double.tryParse(_amountController.text);
      if (amount == null) {
        setState(() {
          change = -_itemsListController.totalPrice.value;
        });
        return;
      }
      setState(() {
        change = amount - _itemsListController.totalPrice.value;
      });
    });
  }

  void _cancelPayment() {
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
        title: "Save Payment".text(),
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

  void _pay() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      Toaster.showError("invalid amount");
      return;
    }
    if (amount < _itemsListController.totalPrice.value) {
      Toaster.showError("not enough funds");
      return;
    }
    setState(() {
      _savingReceit = true;
    });
    final state = await _itemsListController.addReceitFromItemModel(
      amount,
      "cash",
      allowOfflinePurchase:
          _userController.user.value != null &&
          _userController.user.value!.allowOfflinePurchase,
    );
    setState(() {
      _savingReceit = false;
    });
    if (state.success) {
      if (state.rejects != null && state.rejects!.isNotEmpty) {
        setState(() {
          _rejects = state.rejects!;
        });
        return;
      }
      Get.back();
      Toaster.showSuccess("payment done");
    }
  }

  Widget _listRejects() {
    return [
      "Reject Notice".text(
        style: TextStyle(
          fontSize: 32,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      14.gapHeight,
      "Your payment has rejected the following items but others have proceeded payment"
          .text(),
      22.gapHeight,
      ..._rejects.map(
        (e) => ListTile(
          leading: Text(e.count.toString()),
          title: Text(e.name),
          trailing: Text(
            CurrenceConverter.getCurrenceFloatInStrings(
              (e.price + e.addenum) * e.count,
            ),
          ),
          subtitle: Text(e.rejectedReason, overflow: TextOverflow.ellipsis),
        ),
      ),
    ].column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
