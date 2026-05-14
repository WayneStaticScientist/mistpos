import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/screens/basic/screen_credit_payment.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/utils/pdfdocuments/pdf_receit.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/screens/basic/screen_refund_cart.dart';

class ScreenReceitView extends StatelessWidget {
  final ItemReceitModel receitModel;
  const ScreenReceitView({super.key, required this.receitModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receitModel.label)),
      body: ReceitDetailsWidget(receitModel: receitModel),
    );
  }
}

class ReceitDetailsWidget extends StatefulWidget {
  final ItemReceitModel receitModel;
  const ReceitDetailsWidget({super.key, required this.receitModel});

  @override
  State<ReceitDetailsWidget> createState() => _ReceitDetailsWidgetState();
}

class _ReceitDetailsWidgetState extends State<ReceitDetailsWidget> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.surface(context),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.receitModel.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        if (!widget.receitModel.creditSale)
                          TextButton.icon(
                            onPressed: _refund,
                            icon: const Iconify(Bx.recycle, color: Colors.red),
                            label: const Text(
                              "Refund",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        if (widget.receitModel.creditSale)
                          ElevatedButton.icon(
                            onPressed: _payCredit,
                            icon: const Iconify(Bx.coin, color: Colors.white),
                            label: const Text(
                              "Pay",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _printReceit,
                          icon: Iconify(
                            Bx.printer,
                            color: AppTheme.color(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sync Status
                if (!widget.receitModel.synced)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withAlpha(50)),
                    ),
                    child: const Text(
                      "Not Synced",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Total
                CurrenceConverter.getCurrenceFloatInStrings(
                  widget.receitModel.total,
                  _userController.user.value?.baseCurrence ?? '',
                ).text(
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: widget.receitModel.creditSale
                        ? Colors.red
                        : Get.theme.colorScheme.primary,
                  ),
                ),
                "Total${widget.receitModel.creditSale ? ' (Credit)' : ''}".text(
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),
                Divider(color: Colors.grey.withAlpha(50), thickness: 1),
                const SizedBox(height: 16),

                // Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: "Employee: ${widget.receitModel.cashier}".text(),
                      subtitle: "POS: pos 1".text(),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.withAlpha(50), thickness: 1),
                    const SizedBox(height: 16),

                    // Items
                    ...widget.receitModel.items.map((e) {
                      double totalPrice = (e.price + e.addenum) * e.count;
                      if (e.discountId != null && e.discountId!.isNotEmpty) {
                        if (e.percentageDiscount) {
                          totalPrice = totalPrice * (1 - e.discount / 100);
                        } else {
                          totalPrice = totalPrice - e.discount;
                        }
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: e.refunded
                            ? const Iconify(Bx.refresh, color: Colors.red)
                            : null,
                        subtitle: Row(
                          children: [
                            "${e.count} x ${CurrenceConverter.getCurrenceFloatInStrings(e.price + e.addenum, _userController.user.value?.baseCurrence ?? '')}"
                                    "${e.refunded ? "   ${e.originalCount} -> ${e.count} " : ''}"
                                .text(),
                            const SizedBox(width: 12),
                            if (e.discountId != null &&
                                e.discountId!.isNotEmpty)
                              (e.percentageDiscount
                                      ? "${e.discount}% off"
                                      : "\$${CurrenceConverter.getCurrenceFloatInStrings(e.discount, _userController.user.value?.baseCurrence ?? "")}")
                                  .text(
                                    style: const TextStyle(color: Colors.red),
                                  ),
                          ],
                        ),
                        title: e.name.text(
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        tileColor: e.refunded ? Colors.red.withAlpha(10) : null,
                        trailing:
                            CurrenceConverter.getCurrenceFloatInStrings(
                              totalPrice,
                              _userController.user.value?.baseCurrence ?? '',
                            ).text(
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Discounts
                    if (widget.receitModel.discounts.isNotEmpty) ...[
                      "Discounts".text(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.receitModel.discounts.map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            e.name?.text() ?? "".text(),
                            ((e.percentageDiscount == true)
                                    ? " - ${e.discount}% off"
                                    : CurrenceConverter.getCurrenceFloatInStrings(
                                        e.discount ?? 0,
                                        _userController
                                                .user
                                                .value
                                                ?.baseCurrence ??
                                            '',
                                      ))
                                .text(
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ],
                        ).padding(const EdgeInsets.only(bottom: 8)),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Taxes
                    if (widget.receitModel.miniTax.isNotEmpty) ...[
                      Divider(color: Colors.grey.withAlpha(50), thickness: 1),
                      const SizedBox(height: 8),
                      "Taxes".text(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...widget.receitModel.miniTax.map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [e.label.text(), "${e.value}%".text()],
                        ).padding(const EdgeInsets.only(bottom: 8)),
                      ),
                    ],

                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.withAlpha(50), thickness: 1),
                    const SizedBox(height: 16),

                    // Summary
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: 'Total'.text(
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing:
                          CurrenceConverter.getCurrenceFloatInStrings(
                            widget.receitModel.total,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: widget.receitModel.payment.text(),
                      trailing: CurrenceConverter.getCurrenceFloatInStrings(
                        widget.receitModel.amount,
                        _userController.user.value?.baseCurrence ?? '',
                      ).text(),
                    ),

                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.withAlpha(50), thickness: 1),
                    const SizedBox(height: 16),

                    widget.receitModel.createdAt.toString().text(
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    if (!widget.receitModel.creditSale)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withAlpha(50)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            'Change'.text(
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CurrenceConverter.getCurrenceFloatInStrings(
                              widget.receitModel.amount -
                                  widget.receitModel.total,
                              _userController.user.value?.baseCurrence ?? '',
                            ).text(
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _refund() async {
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
  }

  void _payCredit() async {
    final result = await Get.to(
      () => ScreenCreditPayment(receitModel: widget.receitModel),
      arguments: widget.receitModel,
    );
    if (result != null) {
      setState(() {
        widget.receitModel.creditSale = result.creditSale;
        widget.receitModel.total = result.total;
        widget.receitModel.amount = result.amount;
      });
    }
  }

  void _printReceit() async {
    PDFMaker maker = PDFMaker();
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
    maker
        .createPDF(
          PdfReceit(
            baseCurrence: baseCurrency,
            receitModel: widget.receitModel,
          ),
          setup: PageSetup(
            context: context,
            quality: 4.0,
            scale: 1.0,
            pageFormat: PageFormat.a4,
            margins: 40,
          ),
        )
        .then((file) {
          _adminController.openFile(file);
        })
        .catchError((e) {
          Toaster.showError("Failed to generate PDF: $e");
        });
  }
}
