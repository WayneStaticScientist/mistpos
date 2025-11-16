import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/utils/currence_converter.dart';

class PdfReceit extends BlankPage {
  final ItemReceitModel receitModel;
  final String baseCurrence;
  const PdfReceit({
    super.key,
    required this.baseCurrence,
    required this.receitModel,
  });

  @override
  Widget createPageContent(BuildContext context) {
    final user = User.fromStorage();
    return [
      "${user?.companyName}".text(
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      "Receit".text(
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      CurrenceConverter.getCurrenceFloatInStrings(
        receitModel.total,
        baseCurrence,
      ).text(style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      "Total".text(),
      18.gapHeight,
      Divider(color: Colors.grey.withAlpha(80), thickness: 1),
      [
            18.gapHeight,
            buildTitle(
              title: "Employee : ${receitModel.cashier}".text(),
              subtitle: "POS : pos 1".text(),
            ),
            12.gapHeight,
            buildTitle(
              title: "Receit".text(),
              subtitle: receitModel.label.text(),
            ),
            18.gapHeight,
            Divider(color: Colors.grey.withAlpha(80), thickness: 1),
            18.gapHeight,
            ...receitModel.items.map((e) {
              double totalPrice = (e.price + e.addenum) * e.count;
              if (e.discountId != null && e.discountId!.isNotEmpty) {
                if (e.percentageDiscount) {
                  totalPrice = totalPrice * (1 - e.discount / 100);
                } else {
                  totalPrice = totalPrice - e.discount;
                }
              }
              return buildTitle(
                subtitle: [
                  "${e.count.toString()} x ${CurrenceConverter.getCurrenceFloatInStrings(e.price + e.addenum, baseCurrence)}"
                      .text(),
                  12.gapWidth,
                  (e.percentageDiscount
                          ? "${e.discount}% off"
                          : "\$${CurrenceConverter.getCurrenceFloatInStrings(e.discount, baseCurrence)}")
                      .text(style: TextStyle(color: Colors.red))
                      .visibleIf(
                        e.discountId != null && e.discountId!.isNotEmpty,
                      ),
                ].row(),
                title: e.name.text(),
                tileColor: e.refunded ? Colors.red.withAlpha(100) : null,
                trailing: CurrenceConverter.getCurrenceFloatInStrings(
                  totalPrice,
                  baseCurrence,
                ).text(),
              );
            }),
            18.gapHeight,
            if (receitModel.discounts.isNotEmpty) ...[
              "Discounts".text(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              12.gapHeight,
              ...receitModel.discounts.map(
                (e) => [
                  e.name?.text() ?? "".text(),
                  ((e.percentageDiscount == true)
                          ? " - ${e.discount}% off"
                          : CurrenceConverter.getCurrenceFloatInStrings(
                              e.discount ?? 0,
                              baseCurrence,
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
            Divider(color: Colors.grey.withAlpha(80), thickness: 1),
            18.gapHeight,
            buildTitle(
              title: 'Total'.text(),
              trailing: CurrenceConverter.getCurrenceFloatInStrings(
                receitModel.total,
                baseCurrence,
              ).text(),
            ),
            buildTitle(
              title: receitModel.payment.text(),
              trailing: CurrenceConverter.getCurrenceFloatInStrings(
                receitModel.amount,
                baseCurrence,
              ).text(),
            ),
            Divider(color: Colors.grey.withAlpha(80), thickness: 1),
            18.gapHeight,
            receitModel.createdAt.toString().text(),
            18.gapHeight,
            buildTitle(
              title: 'Change'.text(style: TextStyle(color: Colors.white)),
              tileColor: Colors.green,
              trailing:
                  CurrenceConverter.getCurrenceFloatInStrings(
                    receitModel.amount - receitModel.total,
                    baseCurrence,
                  ).text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
            ),
            18.gapHeight,
          ]
          .column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .sizedBox(width: double.infinity),
    ].column(crossAxisAlignment: CrossAxisAlignment.center);
  }

  Widget buildTitle({
    Widget? title,
    Widget? subtitle,
    Color? tileColor,
    Widget? trailing,
  }) {
    return [
          [title ?? SizedBox(), subtitle ?? SizedBox()]
              .column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              .expanded1,
          trailing ?? SizedBox(),
        ]
        .row()
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
        );
  }
}
