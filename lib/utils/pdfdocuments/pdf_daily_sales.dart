import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/models/dialy_sale_model.dart';
import 'package:mistpos/utils/currence_converter.dart';

class PdfDailySales extends BlankPage {
  final DateTime endDate;
  final DateTime? startDate;
  final String baseCurrence;
  final List<DialySaleModel> dailySales;

  const PdfDailySales({
    super.key,
    this.startDate,
    required this.endDate,
    required this.baseCurrence,
    required this.dailySales,
  });

  @override
  Widget createPageContent(BuildContext context) {
    final totalSales = dailySales.fold(
      0.0,
      (prev, data) => prev + data.totalSales,
    );
    final totalCosts = dailySales.fold(
      0.0,
      (prev, data) => prev + data.totalCosts,
    );
    final user = User.fromStorage();
    return [
      "${user?.companyName}".text(
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      "Daily Sales".text(
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      14.gapHeight,
      [
        8.gapWidth,
        "Sales for ${(DateUtils.isSameDay(startDate, DateTime.now()) ? "Today only" : MistDateUtils.formatNormalDate(endDate))}"
            .text()
            .visibleIf(startDate == null),
        if (startDate != null)
          "From ${MistDateUtils.getInformalShortDate(startDate!)} - ${(DateUtils.isSameDay(endDate, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(endDate))}"
              .text()
              .visibleIfNotNull(startDate),
      ].row(mainAxisAlignment: MainAxisAlignment.center),

      14.gapHeight,
      [
        "Total Sales: ".text(),
        CurrenceConverter.getCurrenceFloatInStrings(
          totalSales,
          baseCurrence,
        ).text(style: TextStyle(color: Colors.green)),
      ].row(),
      [
        "Total Costs : ".text(),
        CurrenceConverter.getCurrenceFloatInStrings(
          totalCosts,
          baseCurrence,
        ).text(style: TextStyle(color: Colors.green)),
      ].row(),
      _makeTable(dailySales),
    ].column();
  }

  Widget _makeTable(List<DialySaleModel> dailySales) {
    return Table(
      columnWidths: {
        0: FixedColumnWidth(120.0), // Item
        1: FixedColumnWidth(100.0),
        2: FixedColumnWidth(100.0),
        3: FixedColumnWidth(100.0),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(150),
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            "Item Name".text(),
            "Sold Amount".text(),
            "Total Sales".text(),
            "Total Costs".text(),
          ],
        ),
        ...dailySales.map(
          (e) => TableRow(
            children: [
              e.productName.text(),
              e.totalCount.toString().text(),
              CurrenceConverter.getCurrenceFloatInStrings(
                e.totalSales,
                baseCurrence,
              ).text(),
              CurrenceConverter.getCurrenceFloatInStrings(
                e.totalCosts,
                baseCurrence,
              ).text(),
            ],
          ),
        ),
      ],
    );
  }
}
