import 'dart:developer';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receitModel.label),
        actions: [
          "refund".text().textIconButton(
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
            icon: Iconify(Bx.recycle, color: Colors.red),
          ),
          IconButton(
            onPressed: _printReceit,
            icon: Iconify(Bx.printer, color: AppTheme.color(context)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: [
            ["Not synced ".text().padding(EdgeInsets.all(10))]
                .row(mainAxisAlignment: MainAxisAlignment.center)
                .decoratedBox(decoration: BoxDecoration(color: Colors.red))
                .visibleIfNot(widget.receitModel.synced),
            CurrenceConverter.getCurrenceFloatInStrings(
              widget.receitModel.total,
              _userController.user.value?.baseCurrence ?? '',
            ).text(style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            "Total".text(),
            18.gapHeight,
            Divider(color: Colors.grey.withAlpha(80), thickness: 1),
            [
                  18.gapHeight,
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: "Employee : ${widget.receitModel.cashier}".text(),
                    subtitle: "POS : pos 1".text(),
                  ),
                  18.gapHeight,
                  Divider(color: Colors.grey.withAlpha(80), thickness: 1),
                  18.gapHeight,
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
                      contentPadding: EdgeInsets.all(0),
                      leading: e.refunded
                          ? Iconify(Bx.refresh, color: Colors.red)
                          : null,
                      subtitle: [
                        "${e.count.toString()} x ${CurrenceConverter.getCurrenceFloatInStrings(e.price + e.addenum, _userController.user.value?.baseCurrence ?? '')}"
                                "${e.refunded ? "   ${e.originalCount} -> ${e.count} " : ''}"
                            .text(),
                        12.gapWidth,
                        (e.percentageDiscount
                                ? "${e.discount}% off"
                                : "\$${CurrenceConverter.getCurrenceFloatInStrings(e.discount, _userController.user.value?.baseCurrence ?? "")}")
                            .text(style: TextStyle(color: Colors.red))
                            .visibleIf(
                              e.discountId != null && e.discountId!.isNotEmpty,
                            ),
                      ].row(),
                      title: e.name.text(),
                      tileColor: e.refunded ? Colors.red.withAlpha(100) : null,
                      trailing: CurrenceConverter.getCurrenceFloatInStrings(
                        totalPrice,
                        _userController.user.value?.baseCurrence ?? '',
                      ).text(),
                    );
                  }),
                  18.gapHeight,
                  if (widget.receitModel.discounts.isNotEmpty) ...[
                    "Discounts".text(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.gapHeight,
                    ...widget.receitModel.discounts.map(
                      (e) => [
                        e.name?.text() ?? "".text(),
                        ((e.percentageDiscount == true)
                                ? " - ${e.discount}% off"
                                : CurrenceConverter.getCurrenceFloatInStrings(
                                    e.discount ?? 0,
                                    _userController.user.value?.baseCurrence ??
                                        '',
                                  ))
                            .text(
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ].row(),
                    ),
                    18.gapHeight,
                  ],
                  if (widget.receitModel.miniTax.isNotEmpty) ...[
                    Divider(color: Colors.grey.withAlpha(80), thickness: 1),
                    "Taxes".text(),
                    12.gapHeight,
                    ...widget.receitModel.miniTax.map(
                      (e) => [
                        e.label.text(),
                        14.gapWidth,
                        "${e.value}%".text(),
                      ].row(),
                    ),
                  ],
                  Divider(color: Colors.grey.withAlpha(80), thickness: 1),
                  18.gapHeight,
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: 'Total'.text(),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      widget.receitModel.total,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: widget.receitModel.payment.text(),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      widget.receitModel.amount,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(),
                  ),
                  Divider(color: Colors.grey.withAlpha(80), thickness: 1),
                  18.gapHeight,
                  widget.receitModel.createdAt.toString().text(),
                  18.gapHeight,
                  ListTile(
                    contentPadding: EdgeInsets.all(5),
                    title: 'Change'.text(),
                    tileColor: Colors.green,
                    textColor: Colors.white,
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      widget.receitModel.amount - widget.receitModel.total,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  18.gapHeight,
                ]
                .column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                )
                .sizedBox(width: double.infinity),
          ].column(crossAxisAlignment: CrossAxisAlignment.center),
        ),
      ).constrained(maxWidth: ScreenSizes.maxWidth).padding(EdgeInsets.all(20)),
    );
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
