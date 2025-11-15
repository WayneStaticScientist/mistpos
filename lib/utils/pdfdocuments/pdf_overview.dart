import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/sales_stats_model.dart';
import 'package:mistpos/models/product_stats_model.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';

class AdminOverviewPdf extends BlankPage {
  final DateTime week;
  final DateTime startDate;
  final DateTime endDate;
  final String baseCurrence;
  final int totalProducts;
  final StatsSalesModel? statsSalesModel;
  final StatsProductModel? statsProductModel;

  const AdminOverviewPdf({
    super.key,
    required this.week,
    required this.endDate,
    required this.startDate,
    required this.baseCurrence,
    required this.statsProductModel,
    required this.totalProducts,
    required this.statsSalesModel,
  });

  @override
  Widget createPageContent(BuildContext context) {
    final user = User.fromStorage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "${user?.companyName}".text(
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        "Sales Reports".text(
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // 1. Date Range Header
        SizedBox(height: 18),
        Container(
          padding: EdgeInsets.all(8.0), // Added padding for better look
          decoration: BoxDecoration(color: AppTheme.surface(context)),
          child: Row(
            children: [
              SizedBox(width: 18),
              Text(
                "${startDate.day}/${startDate.month}/${startDate.year}",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium, // Using standard theme
              ),
              SizedBox(width: 18),
              Text("-", style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(width: 18),
              Text(
                "${endDate.day}/${endDate.month}/${endDate.year}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        [
          'From : '.text(
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          MistDateUtils.formatNormalDate(
            startDate,
          ).text(style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ].row(),
        [
          'To : '.text(
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          MistDateUtils.formatNormalDate(
            endDate,
          ).text(style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ].row(),
        // 2. Product Overview Section
        SizedBox(height: 18),
        Text(
          "Product Overview",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardOverview(
              label: "Total Products",
              value: totalProducts.toString(),
            ),
            SizedBox(width: 18),
            CardOverview(
              label: "Total Items In Stock",
              value: statsProductModel?.totalStock.toString() ?? "0",
            ),
          ],
        ).sizedBox(
          height: 110, // Retained the fixed height for consistency
          width: double.infinity,
        ),

        SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardOverview(
              label: "Stock Value",
              value: CurrenceConverter.getCurrenceFloatInStrings(
                statsProductModel?.totalCost ?? 0,
                baseCurrence,
              ),
            ),
            SizedBox(width: 18),
            CardOverview(
              label: "Total Revenue",
              value: CurrenceConverter.getCurrenceFloatInStrings(
                statsProductModel?.totalRevenue ?? 0,
                baseCurrence,
              ),
            ),
          ],
        ).sizedBox(
          height: 110, // Retained the fixed height for consistency
          width: double.infinity,
        ),

        // 3. Sales Overview Section
        SizedBox(height: 18),
        Text(
          "Sales Overview",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 18),
        // CRITICAL FIX: Replaced ListView(scrollDirection: Axis.horizontal) with a Row
        SizedBox(
          height: 110, // Retained the fixed height
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align to start
            children: [
              CardOverview(
                label: "Profit ",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  (statsSalesModel?.totalSales ?? 0) -
                      (statsSalesModel?.totalCost ?? 0),
                  baseCurrence,
                ),
              ),
              SizedBox(width: 18),
              CardOverview(
                label: "Total Sales",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  statsSalesModel?.totalSales ?? 0,
                  baseCurrence,
                ),
              ),
              SizedBox(width: 18),
              CardOverview(
                label: "Active Cashiers",
                value: statsSalesModel?.numberOfCashiers.toString() ?? "0",
              ),
            ],
          ),
        ),

        // 5. Weekly Summary Footer
        SizedBox(height: 44),
        SizedBox(height: 18), // Added another height for padding
        // FIX: Removed SingleChildScrollView.
        // Replaced .row().decoratedBox with standard Row and Container.
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: AppTheme.surface(context)),
          child: Row(
            children: [
              SizedBox(width: 18),
              Text(
                "${week.subtract(Duration(days: 6)).day}/${week.subtract(Duration(days: 6)).month}/${week.subtract(Duration(days: 6)).year}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(width: 18),
              Text("-", style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(width: 18),
              Text(
                "${week.day}/${week.month}/${week.year}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
