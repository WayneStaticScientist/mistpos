import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/inventory_history_model.dart';

class PdfInventoryHistory extends BlankPage {
  final DateTime startDate;
  final DateTime endDate;
  final List<InventoryHistoryModel> invHistory;
  final String baseCurrence;
  const PdfInventoryHistory({
    super.key,
    required this.invHistory,
    required this.baseCurrence,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget createPageContent(BuildContext context) {
    final user = User.fromStorage();
    return [
      "${user?.companyName}".text(
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      "Inventory History".text(
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      14.gapHeight,
      [
        Iconify(Bx.calendar, color: AppTheme.color(context)),
        8.gapWidth,

        "From ${MistDateUtils.getInformalShortDate(startDate)} - ${(DateUtils.isSameDay(endDate, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(endDate))}"
            .text()
            .visibleIfNotNull(startDate),
      ].row(mainAxisAlignment: MainAxisAlignment.center),
      _makeTable(invHistory),
    ].column();
  }

  Widget _makeTable(List<InventoryHistoryModel> historyModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(200.0), // Item
          1: FixedColumnWidth(100.0),
          2: FixedColumnWidth(100.0),
          3: FixedColumnWidth(100.0),
          4: FixedColumnWidth(80.0),
          5: FixedColumnWidth(80.0),
          6: FixedColumnWidth(80.0),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Text('Item Name').padding(EdgeInsets.all(10)),
              Text('Document Type').padding(EdgeInsets.all(10)),
              Text('Quantity Change').padding(EdgeInsets.all(10)),
              Text('Date').padding(EdgeInsets.all(10)),
            ],
          ),
          ...historyModel.map((e) {
            return TableRow(
              children: [
                Text(
                  e.itemName ?? '-',
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.documentType ?? "-",
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.quantityChange?.toString() ?? "-",
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.createdAt != null
                      ? MistDateUtils.getInformalShortDate(e.createdAt!)
                      : "",
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
              ],
            );
          }),
        ],
      ),
    );
  }
}
