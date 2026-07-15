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

  Widget _buildDashedDivider(Color color) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14161F) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: "Checkout Summary".text(
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 850) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildReceiptPreview(isDark)),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildPaymentSidebar(isDark)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildPaymentSidebar(isDark),
                      const SizedBox(height: 24),
                      _buildReceiptPreview(isDark),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptPreview(bool isDark) {
    final primary = Get.theme.colorScheme.primary;

    return Obx(() {
      final items = _itemsListController.checkOutItems;
      final currency = _userController.user.value?.baseCurrence ?? '';

      // Calculate Receipt Totals
      final subtotal = items.fold(0.0, (prev, item) => prev + _calculateLineTotal(item));
      final totalDiscounts = _itemsListController.selectedDiscounts.fold(0.0, (prev, data) {
        return prev + (!data.percentage ? data.value : subtotal * (data.value / 100));
      });
      final totalTax = _itemsListController.salesTaxes.fold(0.0, (prev, data) {
        if (data.activated == false) return prev;
        if (data.selectedIds.isNotEmpty) {
          final totalPriceAdded = items.fold(0.0, (prv, cv) {
            final model = cv['item'] as ItemModel;
            if (data.selectedIds.contains(model.hexId)) {
              return prv + (model.price * data.value) / 100;
            }
            return prv;
          });
          return prev + totalPriceAdded;
        }
        return prev + ((subtotal - totalDiscounts) * data.value) / 100;
      });
      final grandTotal = subtotal - totalDiscounts + totalTax;

      return Container(
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
          children: [
            // Top Section (Header)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "INVOICE DETAILS".text(
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      "${items.length} items to checkout".text(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildDashedDivider(isDark ? Colors.white.withAlpha(15) : Colors.grey.shade200),
            
            // Items List Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey.shade500),
                            const SizedBox(height: 12),
                            "No items in cart".text(
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          height: 1,
                          color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade100,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final model = item['item'] as ItemModel;
                        final count = item['count'] as num? ?? 0;
                        final lineTotal = _calculateLineTotal(item);
                        final itemColor = model.color != null
                            ? Color(model.color!)
                            : primary;

                        return Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: itemColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: itemColor.withAlpha(60),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  model.name.isNotEmpty
                                      ? model.name[0].toUpperCase()
                                      : 'P',
                                  style: TextStyle(
                                    color: itemColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  model.name.text(
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  (model.sku.isNotEmpty
                                          ? "SKU: ${model.sku}"
                                          : model.category)
                                      .text(
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CurrenceConverter.getCurrenceFloatInStrings(
                                  lineTotal,
                                  currency,
                                ).text(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                "Qty: $count".text(
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
            ),
            
            _buildDashedDivider(isDark ? Colors.white.withAlpha(15) : Colors.grey.shade200),
            
            // Totals Breakdowns
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSummaryRow(
                    "Subtotal",
                    CurrenceConverter.getCurrenceFloatInStrings(subtotal, currency),
                    isDark,
                  ),
                  if (totalDiscounts > 0) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      "Discounts",
                      "- ${CurrenceConverter.getCurrenceFloatInStrings(totalDiscounts, currency)}",
                      isDark,
                      valueColor: Colors.red.shade500,
                    ),
                  ],
                  if (totalTax > 0) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      "Tax Amount",
                      "+ ${CurrenceConverter.getCurrenceFloatInStrings(totalTax, currency)}",
                      isDark,
                      valueColor: Colors.amber.shade700,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade100,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Grand Total".text(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      CurrenceConverter.getCurrenceFloatInStrings(grandTotal, currency).text(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value, bool isDark, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        label.text(
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        value.text(
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSidebar(bool isDark) {
    final primary = Get.theme.colorScheme.primary;

    return Container(
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [primary.withAlpha(50), primary.withAlpha(20)]
                    : [primary.withAlpha(15), primary.withAlpha(5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary.withAlpha(isDark ? 40 : 25),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                "TOTAL AMOUNT DUE".text(
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => CurrenceConverter.getCurrenceFloatInStrings(
                    _itemsListController.totalPrice.value,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: primary,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          "SELECT PAYMENT MODE".text(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Cash Payment Card Button
          _buildPaymentMethodCard(
            title: "CASH PAYMENT",
            subtitle: "Pay with notes & calculate change",
            icon: Icons.payments_rounded,
            iconBgColor: Colors.green.shade50.withAlpha(isDark ? 25 : 255),
            iconColor: Colors.green.shade600,
            onTap: _cashPaymenthandler,
            isDark: isDark,
          ),
          
          const SizedBox(height: 16),
          
          // Card Payment Card Button
          _buildPaymentMethodCard(
            title: "CARD PAYMENT",
            subtitle: "Visa, Mastercard, or PayNow",
            icon: Icons.credit_card_rounded,
            iconBgColor: primary.withAlpha(isDark ? 25 : 25),
            iconColor: primary,
            onTap: _cardPaymentHandler,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade200,
            width: 1.5,
          ),
          color: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.text(
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  subtitle.text(
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
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
