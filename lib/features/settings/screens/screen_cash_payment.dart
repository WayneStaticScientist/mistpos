import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/inputs/input_form.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';

class ScreenCashPayment extends StatefulWidget {
  const ScreenCashPayment({super.key});

  @override
  State<ScreenCashPayment> createState() => _ScreenCashPaymentState();
}

class _ScreenCashPaymentState extends State<ScreenCashPayment> {
  final _userController = Get.find<UserController>();
  final _printerController = Get.find<DevicesController>();
  final _invController = Get.find<InventoryController>();
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

  String _selectedPaymentMethod = "Cash";
  final List<Map<String, dynamic>> _paymentMethods = [
    {"name": "Cash", "color": Colors.green.shade600, "icon": Icons.payments},
    {"name": "EcoCash", "color": const Color(0xFF0078C1), "icon": Icons.phone_android},
    {"name": "InBucks", "color": Colors.teal.shade600, "icon": Icons.phone_iphone},
    {"name": "OneMoney", "color": Colors.orange.shade800, "icon": Icons.mobile_friendly},
    {"name": "Telecash", "color": Colors.red.shade600, "icon": Icons.send_to_mobile},
    {"name": "ZimSwitch", "color": const Color(0xFF1B3A68), "icon": Icons.credit_card},
    {"name": "Visa", "color": const Color(0xFF1A1F71), "icon": Icons.credit_card},
    {"name": "MasterCard", "color": const Color(0xFFEB001B), "icon": Icons.credit_card},
    {"name": "Bank Transfer", "color": Colors.deepPurple, "icon": Icons.account_balance},
  ];

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: "Checkout".text(
          style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
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
        child: Column(
          children: [
            _buildTotalSummaryCard(isDark),
            24.gapHeight,
            _buildPaymentMethodsCard(isDark),
            24.gapHeight,
            _buildTenderedCard(isDark),
            12.gapHeight,
            _buildBalanceDisplay(),
            40.gapHeight,
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildTotalSummaryCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Get.theme.colorScheme.primary,
            Get.theme.colorScheme.primary.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.primary.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          "TOTAL AMOUNT TO PAY".text(
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          12.gapHeight,
          CurrenceConverter.getCurrenceFloatInStrings(
            _itemsListController.totalPrice.value,
            _userController.user.value?.baseCurrence ?? '',
          ).text(
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "PAYMENT METHOD".text(
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ).padding(const EdgeInsets.only(left: 8, bottom: 16)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: _paymentMethods.length,
          itemBuilder: (context, index) {
            final method = _paymentMethods[index];
            final name = method['name'] as String;
            final color = method['color'] as Color;
            final icon = method['icon'] as IconData;
            final isSelected = _selectedPaymentMethod == name;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = name;
                  if (name != "Cash") {
                    _amountController.text = CurrenceConverter.prevailingAmount(
                      _itemsListController.totalPrice.value,
                      _userController.user.value?.baseCurrence ?? '',
                    ).toString();
                    _debounceCache = ""; 
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? color.withAlpha(20) : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? color : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: color.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? color : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      size: 28,
                    ),
                    8.gapHeight,
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? color : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTenderedCard(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "AMOUNT TENDERED".text(
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ).padding(const EdgeInsets.only(left: 8, bottom: 12)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              Text(
                _userController.user.value?.baseCurrence ?? '\$',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
              ),
              16.gapWidth,
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Displays either the change due or an error if funds are insufficient
  Widget _buildBalanceDisplay() {
    if (change < 0.0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withAlpha(60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 28),
            12.gapWidth,
            "Insufficient Funds".text(
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withAlpha(60)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
          12.gapWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Change Due".text(
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              CurrenceConverter.getCurrenceFloatInStrings(
                change,
                _userController.user.value?.baseCurrence ?? '',
              ).text(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Modern dual-button action bar
  Widget _buildBottomActions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          // Pay on Credit Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.orange.shade600, width: 2),
              ),
              child: OutlinedButton.icon(
                onPressed: _payOnCredit,
                icon: Icon(Icons.assignment_ind_outlined, color: Colors.orange.shade700, size: 20),
                label: const Text(
                  "Credit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ).visibleIf(_invController.company.value?.enableCreditSale ?? true),
          const SizedBox(width: 16),
          // Pay Now Button (Primary)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: change >= 0.0 ? [
                    Get.theme.colorScheme.primary,
                    Get.theme.colorScheme.primary.withAlpha(200),
                  ] : [
                    Colors.grey.shade600,
                    Colors.grey.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  if (change >= 0.0)
                    BoxShadow(
                      color: Get.theme.colorScheme.primary.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _pay,
                icon: _savingReceit
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                label: const Text(
                  "CONFIRM PAYMENT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
        ],
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

    if (amount < total && !creditPayment) {
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
      _selectedPaymentMethod,
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
