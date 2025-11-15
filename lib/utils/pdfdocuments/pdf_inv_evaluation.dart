import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/product_stats_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';

class PdfInvEvaluation extends BlankPage {
  final DateTime startDate;
  final DateTime endDate;
  final StatsProductModel statsProductModel;
  final List<ItemModel> inventoryProducts;
  final String baseCurrence;
  const PdfInvEvaluation({
    super.key,
    required this.baseCurrence,
    required this.startDate,
    required this.endDate,
    required this.statsProductModel,
    required this.inventoryProducts,
  });

  @override
  Widget createPageContent(BuildContext context) {
    final user = User.fromStorage();
    return [
      "${user?.companyName}".text(
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      "Inventory Valuation Report".text(style: TextStyle(fontSize: 24)),
      14.gapHeight,
      [
        Iconify(Bx.calendar, color: AppTheme.color(context)),
        8.gapWidth,

        "From ${MistDateUtils.getInformalShortDate(startDate)} - ${(DateUtils.isSameDay(endDate, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(endDate))}"
            .text()
            .visibleIfNotNull(startDate),
      ].row(mainAxisAlignment: MainAxisAlignment.center),

      _makeSummary(statsProductModel),
      18.gapHeight,
      _makeTable(inventoryProducts),
    ].column();
  }

  Widget _makeSummary(StatsProductModel statsProductModel) {
    return MistMordernLayout(
      label: "Summary",
      children: [
        [
          "Total Inventory Value".text(),
          CurrenceConverter.getCurrenceFloatInStrings(
            statsProductModel.totalCost,
            baseCurrence,
          ).text(style: TextStyle(fontSize: 18)),
        ].row(),
        14.gapHeight,
        [
          "Total Retail Value".text(),
          CurrenceConverter.getCurrenceFloatInStrings(
            statsProductModel.totalRevenue,
            baseCurrence,
          ).text(style: TextStyle(fontSize: 18)),
        ].row(),
        14.gapHeight,
        [
          "Potential Profit".text(),
          CurrenceConverter.getCurrenceFloatInStrings(
            statsProductModel.totalRevenue - statsProductModel.totalCost,
            baseCurrence,
          ).text(style: TextStyle(fontSize: 18)),
        ].row(),
        [
          "Margin".text(),
          "${((statsProductModel.totalCost / statsProductModel.totalRevenue) * 100).toStringAsFixed(0)}%"
              .text(style: TextStyle(fontSize: 18)),
        ].row(),
      ],
    ).sizedBox(width: double.infinity);
  }

  Widget _makeTable(List<ItemModel> inventoryProducts) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(200.0), // Item
        1: FixedColumnWidth(100.0),
        2: FixedColumnWidth(100.0),
        3: FixedColumnWidth(100.0),
        4: FixedColumnWidth(100.0),
        5: FixedColumnWidth(100.0),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            Text('Item Name').padding(EdgeInsets.all(10)),
            Text('Quantity').padding(EdgeInsets.all(10)),
            Text('Cost').padding(EdgeInsets.all(10)),
            Text('Retail').padding(EdgeInsets.all(10)),
            Text('Profit').padding(EdgeInsets.all(10)),
            Text('Margin').padding(EdgeInsets.all(10)),
          ],
        ),
        ...inventoryProducts.map(
          (e) => TableRow(
            children: [
              e.name.text().padding(EdgeInsets.all(10)),
              e.stockQuantity.toString().text().padding(EdgeInsets.all(10)),
              CurrenceConverter.getCurrenceFloatInStrings(
                e.cost *
                    ((e.isCompositeItem && !e.useProduction && e.trackStock) ||
                            (!e.trackStock)
                        ? 1
                        : e.stockQuantity),
                baseCurrence,
              ).text().padding(EdgeInsets.all(10)),
              CurrenceConverter.getCurrenceFloatInStrings(
                e.price *
                    ((e.isCompositeItem && !e.useProduction && e.trackStock) ||
                            (!e.trackStock)
                        ? 1
                        : e.stockQuantity),
                baseCurrence,
              ).text().padding(EdgeInsets.all(10)),
              CurrenceConverter.getCurrenceFloatInStrings(
                (e.price - e.cost) *
                    ((e.isCompositeItem && !e.useProduction && e.trackStock) ||
                            (!e.trackStock)
                        ? 1
                        : e.stockQuantity),
                baseCurrence,
              ).text().padding(EdgeInsets.all(10)),
              "${((e.cost / e.price) * 100).toStringAsFixed(2)}%"
                  .text()
                  .padding(EdgeInsets.all(10)),
            ],
          ),
        ),
      ],
    );
  }
}
