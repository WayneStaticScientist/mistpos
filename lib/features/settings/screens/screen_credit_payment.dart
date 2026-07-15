import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/core/widgets/inputs/input_form.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';

class ScreenCreditPayment extends StatefulWidget {
  final ItemReceitModel receitModel;
  const ScreenCreditPayment({super.key, required this.receitModel});

  @override
  State<ScreenCreditPayment> createState() => _ScreenCreditPaymentState();
}

class _ScreenCreditPaymentState extends State<ScreenCreditPayment> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();

  late final TextEditingController _amountController;

  double remaining = 0.0;
  double change = 0.0;
  Timer? _debounce;
  String _debounceCache = "";
  bool _savingReceit = false;

  @override
  void initState() {
    super.initState();
    final total = widget.receitModel.total;
    final paid = widget.receitModel.currentAmountPayed;
    remaining = total - paid;
    if (remaining < 0) remaining = 0;

    _amountController = TextEditingController(
      text: CurrenceConverter.prevailingAmount(
        remaining,
        _userController.user.value?.baseCurrence ?? '',
      ).toStringAsFixed(2),
    );

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
        title: const Text(
          "Settle Credit Balance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 32),
              const Text(
                "Payment Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              MistFormInput(
                label: "Amount Tendered",
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickPicks(),
              const SizedBox(height: 32),
              _buildChangeDisplay(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildBalanceCard() {
    final currency = _userController.user.value?.baseCurrence ?? '';
    final primary = Get.theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Invoice:",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                CurrenceConverter.getCurrenceFloatInStrings(
                  widget.receitModel.total,
                  currency,
                ),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Paid so far:",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                CurrenceConverter.getCurrenceFloatInStrings(
                  widget.receitModel.currentAmountPayed,
                  currency,
                ),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          const Text(
            "Remaining Balance",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrenceConverter.getCurrenceFloatInStrings(remaining, currency),
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: primary,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPicks() {
    final totalRemaining = CurrenceConverter.prevailingAmount(
      remaining,
      _userController.user.value?.baseCurrence ?? '',
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickPickChip("25%", totalRemaining * 0.25),
        _buildQuickPickChip("50%", totalRemaining * 0.50),
        _buildQuickPickChip("75%", totalRemaining * 0.75),
        _buildQuickPickChip("Full", totalRemaining),
      ],
    );
  }

  Widget _buildQuickPickChip(String label, double value) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _amountController.text = value.toStringAsFixed(2);
      },
      backgroundColor: Get.theme.colorScheme.primary.withAlpha(20),
      labelStyle: TextStyle(
        color: Get.theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Get.theme.colorScheme.primary.withAlpha(50)),
      ),
    );
  }

  Widget _buildChangeDisplay() {
    final currency = _userController.user.value?.baseCurrence ?? '';
    if (change <= 0.0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Partial deposit — No change due",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Text(
          "Change Due",
          style: TextStyle(
            color: Colors.grey,
            letterSpacing: 1.2,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          CurrenceConverter.getCurrenceFloatInStrings(change, currency),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton.icon(
          onPressed: _savingReceit ? null : _pay,
          icon: _savingReceit
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Iconify(Carbon.checkmark_filled, color: Colors.white),
          label: const Text(
            "Confirm Payment",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  void _startDebouncer() {
    _debounce = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_debounceCache == _amountController.text) return;
      _debounceCache = _amountController.text;

      final amountTendered = double.tryParse(_amountController.text) ?? 0.0;
      final remainingLocal = CurrenceConverter.prevailingAmount(
        remaining,
        _userController.user.value?.baseCurrence ?? '',
      );

      setState(() {
        if (amountTendered > remainingLocal) {
          change = amountTendered - remainingLocal;
        } else {
          change = 0.0; // Partial payment
        }
      });
    });
  }

  void _pay({bool creditPayment = false}) async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      Toaster.showError("Please enter a valid amount");
      return;
    }

    setState(() => _savingReceit = true);

    if (_userController.user.value == null) {
      Toaster.showError("User registration needed");
      setState(() => _savingReceit = false);
      return;
    }

    final response = await _itemsListController.payReceitCredit(
      amount: amount,
      id: widget.receitModel.hexId,
    );

    if (response) {
      // Update local model
      widget.receitModel.currentAmountPayed += amount;
      if (widget.receitModel.currentAmountPayed >= widget.receitModel.total) {
        widget.receitModel.creditSale = false;
      }
      Get.back(result: widget.receitModel);
      Toaster.showSuccess("Payment processed successfully");
    }

    if (mounted) setState(() => _savingReceit = false);
  }
}
