import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens/screen_cash_payment.dart';
import 'package:mistpos/features/settings/screens_gateways/paynow/screen_paynow_payment.dart';
import 'package:mistpos/data/models/item_model.dart';

class ScreenCheckout extends StatefulWidget {
  const ScreenCheckout({super.key});

  @override
  State<ScreenCheckout> createState() => _ScreenCheckoutState();
}

class _ScreenCheckoutState extends State<ScreenCheckout> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();

  double _calculateLineTotal(Map<String, dynamic> item) {
    final count = item['count'] as num? ?? 0;
    final addenum = item['addenum'] as double? ?? 0.0;
    final qouted = item['qouted'] as double? ?? 0.0;
    final model = item['item'] as ItemModel;
    double price =
        count *
        (((model.wholesaleActivated && count >= model.miniItems)
                ? model.wholesalePrice
                : (model.price + qouted)) +
            addenum);
    if (item['discountId'] != null) {
      double discount = (item['discount'] as num?)?.toDouble() ?? 0.0;
      bool percentageDiscount = item['percentageDiscount'] as bool? ?? true;
      price = percentageDiscount
          ? price * (1 - discount / 100)
          : price - discount;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: "Checkout Summary".text(
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 768) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildReceiptPreview(isDark)),
                  24.gapWidth,
                  Expanded(flex: 2, child: _buildPaymentSidebar(isDark)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildPaymentSidebar(isDark),
                  24.gapHeight,
                  _buildReceiptPreview(isDark),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildReceiptPreview(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "ORDER ITEMS".text(
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              Obx(
                () => "${_itemsListController.checkOutItems.length} items".text(
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          16.gapHeight,
          Divider(height: 1, color: Colors.grey.withAlpha(30)),
          16.gapHeight,
          Obx(() {
            final items = _itemsListController.checkOutItems;
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: "No items in cart".text(
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 8,
                endIndent: 8,
                color: Colors.grey.withAlpha(30),
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final model = item['item'] as ItemModel;
                final count = item['count'] as num? ?? 0;
                final lineTotal = _calculateLineTotal(item);
                final currency = _userController.user.value?.baseCurrence ?? '';
                final itemColor = model.color != null
                    ? Color(model.color!)
                    : Get.theme.colorScheme.primary;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      // Avatar placeholder with color
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: itemColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: itemColor.withAlpha(80),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            model.name.isNotEmpty
                                ? model.name[0].toUpperCase()
                                : 'P',
                            style: TextStyle(
                              color: itemColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      16.gapWidth,
                      // Item Name & Category
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.name.text(
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            4.gapHeight,
                            (model.sku.isNotEmpty
                                    ? "SKU: ${model.sku}"
                                    : model.category)
                                .text(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ],
                        ),
                      ),
                      12.gapWidth,
                      // Quantity & Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CurrenceConverter.getCurrenceFloatInStrings(
                            lineTotal,
                            currency,
                          ).text(
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          4.gapHeight,
                          "Qty: $count".text(
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentSidebar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          "TOTAL AMOUNT DUE".text(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          12.gapHeight,
          Obx(
            () =>
                CurrenceConverter.getCurrenceFloatInStrings(
                  _itemsListController.totalPrice.value,
                  _userController.user.value?.baseCurrence ?? '',
                ).text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Get.theme.colorScheme.primary,
                    letterSpacing: -1,
                  ),
                ),
          ),
          24.gapHeight,
          Divider(height: 1, color: Colors.grey.withAlpha(30)),
          24.gapHeight,
          "SELECT PAYMENT MODE".text(
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          16.gapHeight,
          // Cash Payment Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _cashPaymenthandler,
              icon: const Icon(
                Icons.payments_outlined,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                "CASH PAYMENT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.2,
                  color: Colors.white,
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
          18.gapHeight,
          // Card Payment Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Get.theme.colorScheme.primary,
                  Get.theme.colorScheme.primary.withAlpha(200),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.primary.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _cardPaymentHandler,
              icon: const Icon(
                Icons.credit_card_outlined,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                "CARD PAYMENT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.2,
                  color: Colors.white,
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
        ],
      ),
    );
  }

  void _cashPaymenthandler() {
    Get.off(() => ScreenCashPayment());
  }

  void _cardPaymentHandler() {
    if (_userController.user.value?.paynowActivated == true) {
      Get.off(() => ScreenPaynowPayment());
      return;
    }
    Toaster.showError(
      "card payment not activated , Please activate from payment gateways sections",
    );
  }
}
