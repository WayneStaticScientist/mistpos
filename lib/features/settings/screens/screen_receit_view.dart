import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/settings/screens/screen_credit_payment.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:printing/printing.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/tax_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_receit.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:mistpos/features/settings/screens/screen_refund_cart.dart';
import 'package:mistpos/core/utils/date_utils.dart';

class ScreenReceitView extends StatefulWidget {
  final ItemReceitModel receitModel;
  const ScreenReceitView({super.key, required this.receitModel});
  @override
  State<ScreenReceitView> createState() => _ScreenReceitViewState();
}

class _ScreenReceitViewState extends State<ScreenReceitView> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt #${widget.receitModel.label}", style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _printReceit,
            icon: Iconify(Bx.printer, color: AppTheme.color(context)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Receipt Card
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 80 : 15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: primary.withAlpha(15),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Column(
                          children: [
                            if (!widget.receitModel.synced)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.cloud_off, color: Colors.red, size: 14),
                                    SizedBox(width: 6),
                                    Text("Not Synced", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: primary.withAlpha(30), shape: BoxShape.circle),
                              child: Iconify(Bx.receipt, color: primary, size: 36),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              CurrenceConverter.getCurrenceFloatInStrings(
                                widget.receitModel.total,
                                _userController.user.value?.baseCurrence ?? '',
                              ),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: widget.receitModel.creditSale ? Colors.red.shade400 : AppTheme.color(context),
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.receitModel.creditSale ? "CREDIT INVOICE" : "PAID IN FULL",
                              style: TextStyle(
                                color: widget.receitModel.creditSale ? Colors.red.shade400 : Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Metadata Section
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoBlock("Cashier", widget.receitModel.cashier, Icons.person_outline),
                                _buildInfoBlock("Date", MistDateUtils.getInformalShortDate(widget.receitModel.createdAt), Icons.calendar_today, crossAxisAlignment: CrossAxisAlignment.end),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildDashedDivider(isDark),
                            const SizedBox(height: 24),

                            // Items List
                            ...widget.receitModel.items.map((e) {
                              double totalPrice = (e.price + e.addenum) * e.count;
                              if (e.discountId != null && e.discountId!.isNotEmpty) {
                                if (e.percentageDiscount) {
                                  totalPrice = totalPrice * (1 - e.discount / 100);
                                } else {
                                  totalPrice = totalPrice - e.discount;
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (e.refunded)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 12, top: 2),
                                        child: Iconify(Bx.refresh, color: Colors.red, size: 18),
                                      ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              decoration: e.refunded ? TextDecoration.lineThrough : null,
                                              color: e.refunded ? Colors.red.shade400 : AppTheme.color(context),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                "${e.count} x ${CurrenceConverter.getCurrenceFloatInStrings(e.price + e.addenum, _userController.user.value?.baseCurrence ?? '')}",
                                                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                                              ),
                                              if (e.refunded)
                                                Text(
                                                  "  (Ref: ${e.originalCount} -> ${e.count})",
                                                  style: TextStyle(color: Colors.red.shade300, fontSize: 13),
                                                ),
                                            ],
                                          ),
                                          if (e.discountId != null && e.discountId!.isNotEmpty)
                                            Container(
                                              margin: const EdgeInsets.only(top: 4),
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(color: Colors.orange.withAlpha(30), borderRadius: BorderRadius.circular(4)),
                                              child: Text(
                                                e.percentageDiscount ? "Discount: ${e.discount}% off" : "Discount: \$${CurrenceConverter.getCurrenceFloatInStrings(e.discount, _userController.user.value?.baseCurrence ?? '')}",
                                                style: TextStyle(color: Colors.orange.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      CurrenceConverter.getCurrenceFloatInStrings(totalPrice, _userController.user.value?.baseCurrence ?? ''),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.color(context)),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 8),
                            _buildDashedDivider(isDark),
                            const SizedBox(height: 24),

                            // Financial Summary
                            if (widget.receitModel.discounts.isNotEmpty) ...[
                              ...widget.receitModel.discounts.map(
                                (e) => _buildSummaryRow(
                                  e.name ?? "Discount",
                                  (e.percentageDiscount == true) ? "-${e.discount}%" : "-\$${CurrenceConverter.getCurrenceFloatInStrings(e.discount ?? 0, _userController.user.value?.baseCurrence ?? '')}",
                                  accentColor: Colors.orange.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (widget.receitModel.miniTax.isNotEmpty) ...[
                              ...widget.receitModel.miniTax.map((e) => _buildSummaryRow(e.label, "${e.value}%")),
                              const SizedBox(height: 8),
                            ],

                            _buildSummaryRow(
                              "Total",
                              CurrenceConverter.getCurrenceFloatInStrings(widget.receitModel.total, _userController.user.value?.baseCurrence ?? ''),
                              isBold: true,
                              isLarge: true,
                            ),
                            const SizedBox(height: 16),

                            // Payment Status Block
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: widget.receitModel.creditSale ? Colors.red.withAlpha(15) : Colors.green.withAlpha(15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: widget.receitModel.creditSale ? Colors.red.withAlpha(30) : Colors.green.withAlpha(30)),
                              ),
                              child: Column(
                                children: [
                                  if (widget.receitModel.creditSale) ...[
                                    _buildSummaryRow(
                                      "Paid via Deposits",
                                      CurrenceConverter.getCurrenceFloatInStrings(widget.receitModel.currentAmountPayed, _userController.user.value?.baseCurrence ?? ''),
                                    ),
                                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1)),
                                    _buildSummaryRow(
                                      "Remaining Balance",
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        (widget.receitModel.total - widget.receitModel.currentAmountPayed).clamp(0.0, double.infinity),
                                        _userController.user.value?.baseCurrence ?? '',
                                      ),
                                      isBold: true,
                                      isLarge: true,
                                      accentColor: Colors.red.shade600,
                                    ),
                                  ] else ...[
                                    _buildSummaryRow(
                                      "Amount Tendered",
                                      CurrenceConverter.getCurrenceFloatInStrings(widget.receitModel.amount, _userController.user.value?.baseCurrence ?? ''),
                                    ),
                                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1)),
                                    _buildSummaryRow(
                                      "Change Given",
                                      CurrenceConverter.getCurrenceFloatInStrings(
                                        (widget.receitModel.amount - widget.receitModel.total).clamp(0.0, double.infinity),
                                        _userController.user.value?.baseCurrence ?? '',
                                      ),
                                      isBold: true,
                                      isLarge: true,
                                      accentColor: Colors.green.shade600,
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Bottom Action Buttons
                            if (!widget.receitModel.creditSale)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final result = await Get.to(
                                      () => ScreenRefundCart(receitModel: widget.receitModel),
                                      arguments: widget.receitModel,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        widget.receitModel.items = result.items;
                                        widget.receitModel.total = result.total;
                                        widget.receitModel.amount = result.amount;
                                      });
                                    }
                                  },
                                  icon: const Iconify(Bx.recycle, color: Colors.red, size: 18),
                                  label: const Text("Process Refund"),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    foregroundColor: Colors.red,
                                    side: BorderSide(color: Colors.red.withAlpha(50)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                              ),
                            if (widget.receitModel.creditSale)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Get.to(
                                      () => ScreenCreditPayment(receitModel: widget.receitModel),
                                      arguments: widget.receitModel,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        widget.receitModel.creditSale = result.creditSale;
                                        widget.receitModel.total = result.total;
                                        widget.receitModel.currentAmountPayed = result.currentAmountPayed;
                                      });
                                    }
                                  },
                                  icon: const Iconify(Bx.coin, color: Colors.white, size: 20),
                                  label: const Text("Make Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(String label, String value, IconData icon, {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (crossAxisAlignment == CrossAxisAlignment.start) ...[
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 8),
        ],
        Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.color(context))),
          ],
        ),
        if (crossAxisAlignment == CrossAxisAlignment.end) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 16, color: Colors.grey.shade400),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isLarge = false, Color? accentColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: accentColor ?? Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 18 : 15,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              color: accentColor ?? AppTheme.color(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider(bool isDark) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashHeight = 1.5;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void _printReceit() async {
    DevicesController.printReceitToBackround(
      widget.receitModel,
      _userController.user.value!,
      null,
      widget.receitModel.miniTax
          .map(
            (e) => TaxModel(
              label: e.label,
              value: e.value,
              activated: true,
              selectedIds: [],
            ),
          )
          .toList(),
    );
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await PdfReceit.generate(
        widget.receitModel,
        baseCurrency,
        _userController.user.value,
      );
      
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Receipt_${widget.receitModel.label}',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }
}
