import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/sales_by_employee_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:pdf_maker/pdf_maker.dart';

class PdfSalesByEmployee extends BlankPage {
  final DateTime startDate;
  final DateTime endDate;
  final List<SalesByEmployeeModel> salesByEmployee;
  final String baseCurrence;
  const PdfSalesByEmployee({
    super.key,
    required this.salesByEmployee,
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
      "Employee Sales Reports".text(
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
      _makeTable(salesByEmployee),
    ].column();
  }

  Widget _makeTable(List<SalesByEmployeeModel> salesByEmployee) {
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
              Text('Seller Name').padding(EdgeInsets.all(10)),
              Text('Gross Sales').padding(EdgeInsets.all(10)),
              Text('Average Sales').padding(EdgeInsets.all(10)),
              Text('Discounts').padding(EdgeInsets.all(10)),
              Text('Refunds').padding(EdgeInsets.all(10)),
              Text('Receipts').padding(EdgeInsets.all(10)),
              Text('Customers').padding(EdgeInsets.all(10)),
            ],
          ),
          ...salesByEmployee.map((e) {
            return TableRow(
              children: [
                Text(
                  e.sellerName,
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.grossSales,
                    baseCurrence,
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.averageSales,
                    baseCurrence,
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.discounts,
                    baseCurrence,
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.refunds,
                    baseCurrence,
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.numberOfReceipts.toString(),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.uniqueCustomerCount.toString(),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
              ],
            );
          }),
        ],
      ),
    );
  }
}
