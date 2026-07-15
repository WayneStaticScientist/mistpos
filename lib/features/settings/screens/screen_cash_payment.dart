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
    {
      "name": "Cash",
      "color": Colors.green.shade600,
      "icon": Icons.payments_rounded,
    },
    {
      "name": "EcoCash",
      "color": const Color(0xFF0078C1),
      "icon": Icons.phone_android_rounded,
    },
    {
      "name": "InBucks",
      "color": Colors.teal.shade600,
      "icon": Icons.phone_iphone_rounded,
    },
    {
      "name": "OneMoney",
      "color": Colors.orange.shade800,
      "icon": Icons.mobile_friendly_rounded,
    },
    {
      "name": "Telecash",
      "color": Colors.red.shade600,
      "icon": Icons.send_to_mobile_rounded,
    },
    {
      "name": "ZimSwitch",
      "color": const Color(0xFF1B3A68),
      "icon": Icons.credit_card_rounded,
    },
    {
      "name": "Visa",
      "color": const Color(0xFF1A1F71),
      "icon": Icons.credit_card_rounded,
    },
    {
      "name": "MasterCard",
      "color": const Color(0xFFEB001B),
      "icon": Icons.credit_card_rounded,
    },
    {
      "name": "Bank Transfer",
      "color": Colors.deepPurple,
      "icon": Icons.account_balance_rounded,
    },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 850;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF14161F)
          : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: _cancelPayment,
        ),
        title: Text(
          "Complete Transaction",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Save Draft",
            onPressed: _savePayment,
            icon: _loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  )
                : Icon(
                    Icons.bookmark_add_outlined,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Payment method and summary
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildPaymentMethodsCard(isDark, isDesktop: true),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right Column: Summary, Tendered input, presets, and balance
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTotalSummaryCard(isDark),
                            const SizedBox(height: 20),
                            _buildTenderedCard(isDark, isDesktop: true),
                            const SizedBox(height: 20),
                            _buildBalanceDisplay(),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTotalSummaryCard(isDark),
                      const SizedBox(height: 24),
                      _buildPaymentMethodsCard(isDark, isDesktop: false),
                      const SizedBox(height: 24),
                      _buildTenderedCard(isDark, isDesktop: false),
                      const SizedBox(height: 24),
                      _buildBalanceDisplay(),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildTotalSummaryCard(bool isDark) {
    final primary = Get.theme.colorScheme.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "TOTAL AMOUNT TO PAY",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            CurrenceConverter.getCurrenceFloatInStrings(
              _itemsListController.totalPrice.value,
              _userController.user.value?.baseCurrence ?? '',
            ),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard(bool isDark, {required bool isDesktop}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E202C) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment_rounded,
                color: Get.theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "SELECT PAYMENT METHOD",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _paymentMethods.map((method) {
              final name = method['name'] as String;
              final color = method['color'] as Color;
              final icon = method['icon'] as IconData;
              final isSelected = _selectedPaymentMethod == name;

              // Grid-like item width responsive to desktop vs mobile
              final double itemWidth = isDesktop ? 122.0 : 92.0;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = name;
                    if (name != "Cash") {
                      _amountController.text =
                          CurrenceConverter.prevailingAmount(
                            _itemsListController.totalPrice.value,
                            _userController.user.value?.baseCurrence ?? '',
                          ).toString();
                      _debounceCache = "";
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: itemWidth,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withAlpha(20)
                        : (isDark
                              ? Colors.white.withAlpha(5)
                              : Colors.black.withAlpha(3)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? color
                          : (isDark
                                ? Colors.white.withAlpha(10)
                                : Colors.grey.shade200),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withAlpha(30),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isSelected
                            ? color
                            : (isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600),
                        size: 26,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? color
                              : (isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700),
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTenderedCard(bool isDark, {required bool isDesktop}) {
    final primary = Get.theme.colorScheme.primary;
    final total = CurrenceConverter.prevailingAmount(
      _itemsListController.totalPrice.value,
      _userController.user.value?.baseCurrence ?? '',
    );

    // Secure NaN/Infinity checks
    final double safeTotal = (total.isNaN || total.isInfinite) ? 0.0 : total;
    final int baseAmount = safeTotal.ceil();
    final List<double> presets = [];
    presets.add(safeTotal); // exact

    // Add rounded presets safely
    try {
      if (baseAmount < 10) {
        presets.addAll([10.0, 20.0, 50.0]);
      } else if (baseAmount < 20) {
        presets.addAll([20.0, 50.0, 100.0]);
      } else if (baseAmount < 50) {
        presets.addAll([50.0, 100.0]);
      } else if (baseAmount < 100) {
        presets.addAll([100.0, 200.0]);
      } else {
        presets.add(((baseAmount / 50).ceil() * 50).toDouble());
        presets.add(((baseAmount / 100).ceil() * 100).toDouble());
      }
    } catch (_) {}

    final uniquePresets =
        presets.where((val) => !val.isNaN && !val.isInfinite).toSet().toList()
          ..sort();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E202C) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note_rounded, color: primary, size: 20),
              const SizedBox(width: 12),
              Text(
                "AMOUNT TENDERED",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Tendered Value Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(5)
                  : Colors.black.withAlpha(3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Text(
                  _userController.user.value?.baseCurrence ?? '\$',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
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

          if (_selectedPaymentMethod == "Cash" && uniquePresets.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              "QUICK CASH PRESETS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: uniquePresets.map((val) {
                final isExact = val == safeTotal;
                return InkWell(
                  onTap: () {
                    _amountController.text = val.toStringAsFixed(2);
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isExact
                          ? primary.withAlpha(15)
                          : (isDark
                                ? Colors.white.withAlpha(5)
                                : Colors.black.withAlpha(3)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isExact
                            ? primary
                            : (isDark
                                  ? Colors.white.withAlpha(10)
                                  : Colors.grey.shade200),
                      ),
                    ),
                    child: Text(
                      isExact
                          ? "Exact Amount"
                          : "${_userController.user.value?.baseCurrence ?? '\$'}${val.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isExact
                            ? primary
                            : (isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceDisplay() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (change < 0.0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.red.withAlpha(40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              "Insufficient Funds",
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.withAlpha(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 28,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Change Due",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                CurrenceConverter.getCurrenceFloatInStrings(
                  change,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                style: const TextStyle(
                  fontSize: 22,
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

  Widget _buildBottomActions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF1E202C) : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 16,
          ),
          child: Row(
            children: [
              // Pay on Credit Button
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.orange.shade600,
                      width: 1.5,
                    ),
                  ),
                  child: OutlinedButton.icon(
                    onPressed: _payOnCredit,
                    icon: Icon(
                      Icons.assignment_ind_outlined,
                      color: Colors.orange.shade700,
                      size: 18,
                    ),
                    label: const Text(
                      "On Credit",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.orange,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ).visibleIf(
                _invController.company.value?.enableCreditSale ?? true,
              ),

              if (_invController.company.value?.enableCreditSale ?? true)
                const SizedBox(width: 16),

              // Pay Now Button (Primary)
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: change >= 0.0
                          ? [
                              Get.theme.colorScheme.primary,
                              Get.theme.colorScheme.primary.withAlpha(200),
                            ]
                          : [Colors.grey.shade600, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (change >= 0.0)
                        BoxShadow(
                          color: Get.theme.colorScheme.primary.withAlpha(55),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                    ],
                  ),
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
                        : const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                    label: const Text(
                      "CONFIRM PAYMENT",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        title: const Text("Cancel Transaction?"),
        content: const Text(
          "This will remove all items and close the payment screen.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Go Back")),
          TextButton(
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
            child: const Text(
              "Cancel All",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _savePayment() {
    final savedName = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Save for Later"),
        content: MistFormInput(
          label: "Reference Name (e.g. Table 5)",
          controller: savedName,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () => _saveItem(savedName.text),
            child: const Text(
              "Save Draft",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
      content: const Text(
        "This will mark this payment as credit sale , continue",
      ),
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
