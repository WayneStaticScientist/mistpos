import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/devices_controller.dart';

class ScreenCashPayment extends StatefulWidget {
  const ScreenCashPayment({super.key});

  @override
  State<ScreenCashPayment> createState() => _ScreenCashPaymentState();
}

class _ScreenCashPaymentState extends State<ScreenCashPayment> {
  final _userController = Get.find<UserController>();
  final _printerController = Get.find<DevicesController>();
  final _itemsListController = Get.find<ItemsController>();
  bool _loading = false;

  late final TextEditingController _amountController = TextEditingController(
    text: CurrenceConverter.prevailingAmount(
      _itemsListController.totalPrice.value,
      _userController.user.value?.baseCurrence ?? '',
    ).toString(),
  );

  double change = 0.0;
  Timer? _debounce;
  String _debounceCache = "";
  bool _savingReceit = false;

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
        title: "Payment Summary".text(),
        actions: [
          IconButton(
            onPressed: _cancelPayment,
            icon: Iconify(Carbon.close, color: AppTheme.color(context)),
          ),
          IconButton(
            onPressed: _savePayment,
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Iconify(Carbon.save, color: AppTheme.color(context)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:
            [
              "Amount to Pay".text(
                style: Get.textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              CurrenceConverter.getCurrenceFloatInStrings(
                _itemsListController.totalPrice.value,
                _userController.user.value?.baseCurrence ?? '',
              ).text(
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
              24.gapHeight,
              MistFormInput(
                label: "Amount Tendered",
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              24.gapHeight,
              _buildBalanceDisplay(),
            ].column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
      ).center().padding(const EdgeInsets.all(30)),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  /// Displays either the change due or an error if funds are insufficient
  Widget _buildBalanceDisplay() {
    if (change < 0.0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            8.gapWidth,
            "Insufficient Funds".text(
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        "Change Due".text(
          style: Get.textTheme.bodySmall?.copyWith(letterSpacing: 1.2),
        ),
        CurrenceConverter.getCurrenceFloatInStrings(
          change,
          _userController.user.value?.baseCurrence ?? '',
        ).text(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  /// Modern dual-button action bar
  Widget _buildBottomActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Pay on Credit Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _payOnCredit,
                icon: const Iconify(Carbon.user_avatar, color: Colors.orange),
                label: "Credit".text(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: const BorderSide(color: Colors.orange, width: 1.5),
                  foregroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Pay Now Button (Primary)
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _pay,
                icon: _savingReceit
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Iconify(
                        Carbon.checkmark_filled,
                        color: Colors.white,
                      ),
                label: "Pay Now".text(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: change >= 0.0
                      ? Get.theme.colorScheme.primary
                      : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startDebouncer() {
    _debounce = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_debounceCache == _amountController.text) return;
      _debounceCache = _amountController.text;

      final amount = double.tryParse(_amountController.text);
      final total = CurrenceConverter.prevailingAmount(
        _itemsListController.totalPrice.value,
        _userController.user.value?.baseCurrence ?? '',
      );

      setState(() {
        if (amount == null) {
          change = -total;
        } else {
          change = amount - total;
        }
      });
    });
  }

  void _cancelPayment() {
    Get.dialog(
      AlertDialog(
        title: "Cancel Transaction?".text(),
        content: "This will remove all items and close the payment screen."
            .text(),
        actions: [
          "Go Back".text().textButton(onPressed: () => Get.back()),
          "Cancel All".text().textButton(
            onPressed: () async {
              Get.back();
              try {
                await _itemsListController.removeAllSelected();
                Get.back();
                Toaster.showSuccess("Transaction cancelled");
              } catch (e) {
                Toaster.showError("Failed to cancel: $e");
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
        title: "Save for Later".text(),
        content: MistFormInput(
          label: "Reference Name (e.g. Table 5)",
          controller: savedName,
        ),
        actions: [
          "Cancel".text().textButton(onPressed: () => Get.back()),
          "Save Draft".text().textButton(
            onPressed: () => _saveItem(savedName.text),
          ),
        ],
      ),
    );
  }

  void _saveItem(String text) async {
    if (text.trim().isEmpty) {
      Toaster.showError("A reference name is required");
      return;
    }
    Get.back();
    setState(() => _loading = true);
    try {
      await _itemsListController.saveItem(text);
      if (!mounted) return;
      setState(() => _loading = false);
      Get.back();
      Toaster.showSuccess("Payment saved as draft");
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      Toaster.showError("Failed to save: $e");
    }
  }

  void _payOnCredit() {
    Get.defaultDialog(
      title: "Purchase On Credit",
      content: "This will mark this payment as credit sale , continue".text(),
      textCancel: "close",
      textConfirm: "continue",
      onConfirm: () {
        Get.back();
        _pay(creditPayment: true);
      },
    );
  }

  void _pay({bool creditPayment = false}) async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      Toaster.showError("Please enter a valid amount");
      return;
    }

    final total = CurrenceConverter.prevailingAmount(
      _itemsListController.totalPrice.value,
      _userController.user.value?.baseCurrence ?? '',
    );

    if (amount < total) {
      Toaster.showError("Insufficient funds for cash payment");
      return;
    }

    setState(() => _savingReceit = true);

    if (_userController.user.value == null) {
      Toaster.showError("User registration needed");
      setState(() => _savingReceit = false);
      return;
    }

    final state = await _itemsListController.addReceitFromItemModel(
      CurrenceConverter.baseCurrency(amount),
      "cash",
      creditPayment: creditPayment,
      allowOfflinePurchase:
          _userController.user.value?.allowOfflinePurchase ?? false,
      user: _userController.user.value!,
      printReceits: _printerController.isPrinterConnected(),
    );

    if (mounted) setState(() => _savingReceit = false);

    if (state) {
      Get.back();
      Toaster.showSuccess("Payment successful");
    }
  }
}
