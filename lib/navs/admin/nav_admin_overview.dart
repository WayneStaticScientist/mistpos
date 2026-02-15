import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/range_view.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';
import 'package:mistpos/utils/pdfdocuments/pdf_overview.dart';

class NavAdminOverView extends StatefulWidget {
  const NavAdminOverView({super.key});

  @override
  State<NavAdminOverView> createState() => NavAdminOverViewState();
}

class NavAdminOverViewState extends State<NavAdminOverView> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  DateTime? _startDate;
  DateTime? _endDate = DateTime.now();
  DateTime _weeklyRange = DateTime.now();
  @override
  void initState() {
    super.initState();
    _adminController.getWeeklyProfits(endDate: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_adminController.loading.value) {
        return MistLoader1().center();
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            18.gapHeight,
            Wrap(
              children: [
                MistRangeView(
                  label: "From Date",
                  date: _startDate,
                  onDatePicked: (time) {
                    setState(() {
                      _startDate = time;
                    });
                    _loadWithUpdatedTimeFrame();
                  },
                ),
                MistRangeView(
                  label: "To Date",
                  date: _endDate,
                  onDatePicked: (time) {
                    setState(() {
                      _endDate = time;
                    });
                    _loadWithUpdatedTimeFrame();
                  },
                ),
              ],
            ),
            18.gapHeight,
            [
              "Product Overview".text(
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ].row(),
            18.gapHeight,
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: [
                  CardOverview(
                    label: "Total Products",
                    value: _adminController.totalProducts.value.toString(),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Total Items In Stock",
                    value:
                        _adminController.statsPoducts.value?.totalStock
                            .toString() ??
                        "0",
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Stock Value",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsPoducts.value?.totalCost ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Total Revenue",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsPoducts.value?.totalRevenue ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                ].row(),
              ).sizedBox(height: 150, width: double.infinity),
            ),
            18.gapHeight,
            [
              "Sales Overview".text(
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ].row(),
            18.gapHeight,
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: [
                  CardOverview(
                    label: "Gross Profit ",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      (_adminController.statsSales.value?.totalSales ?? 0) -
                          (_adminController.statsSales.value?.totalCost ?? 0),
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Expenses ",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      (_adminController.statsSales.value?.totalExpenses ?? 0),
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Net Profit ",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      ((_adminController.statsSales.value?.totalSales ?? 0) -
                              (_adminController.statsSales.value?.totalCost ??
                                  0)) -
                          (_adminController.statsSales.value?.totalExpenses ??
                              0),
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Total Sales",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsSales.value?.totalSales ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Taxes",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsSales.value?.totalTaxs ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Active Cashiers",
                    value:
                        _adminController.statsSales.value?.numberOfCashiers
                            .toString() ??
                        "0",
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Receipts",
                    value:
                        _adminController.statsSales.value?.totalReceipts
                            .toString() ??
                        "0",
                  ),
                  18.gapWidth,

                  CardOverview(
                    color: Colors.green.withAlpha(150),
                    label: "Discounts",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsSales.value?.totalDiscounts ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    label: "Credits",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsSales.value?.totalCredits ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    color: Colors.blue.withAlpha(50),
                    label: "Total Refunds",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsSales.value?.totalRefunds ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                  18.gapWidth,
                  CardOverview(
                    color: Colors.red.withAlpha(120),
                    label: "Total Loss",
                    value: CurrenceConverter.getCurrenceFloatInStrings(
                      _adminController.statsSales.value?.totalLossValue ?? 0,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                  ),
                ].row(),
              ).sizedBox(height: 150, width: double.infinity),
            ),

            Obx(
              () =>
                  _adminController.statsSales.value?.cashiers != null &&
                      _adminController.statsSales.value!.cashiers.isNotEmpty
                  ? [
                      18.gapHeight,
                      "Active Cashiers".text(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      18.gapHeight,
                      ..._adminController.statsSales.value!.cashiers.map(
                        (e) => ListTile(
                          title: e.name.text(),
                          leading: Iconify(
                            Bx.user,
                            color: AppTheme.color(context),
                          ),
                        ),
                      ),
                    ].column(crossAxisAlignment: CrossAxisAlignment.start)
                  : SizedBox(),
            ),
            32.gapHeight,
            Wrap(
              children: [
                MistRangeView(
                  label: "Choose End Day",
                  date: _weeklyRange,
                  onDatePicked: (time) {
                    setState(() {
                      _weeklyRange = time;
                    });
                    _loadWithWeekTimeFrame();
                  },
                ),
              ],
            ),
            18.gapHeight,
            MistMordernLayout(
              label: "Weekly Profit",
              children: [14.gapHeight, _getWeeklyProfitsBarChart()],
            ),
            32.gapHeight,
            MistMordernLayout(
              label: "Weekly Sales",
              children: [14.gapHeight, _getWeeklySalesChart()],
            ),

            32.gapHeight,
            MistMordernLayout(
              label: "Weekly Visits",
              children: [14.gapHeight, _getWeeklyVisitorsChart()],
            ),
          ],
        ).sizedBox(width: double.infinity),
      );
    });
  }

  _getWeeklyProfitsBarChart() {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return MistLoader1();
      }
      if (list.isEmpty) {
        return "Weekly profit chart is empty".text();
      }

      // --- MODERN STYLING VARIABLES ---
      final primaryColor = Get.theme.colorScheme.primary;
      final textColor = Get.theme.textTheme.bodyMedium?.color ?? Colors.black;

      return BarChart(
        BarChartData(
          // Add padding around the chart area for better aesthetics
          minY: 0,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) =>
                  Get.theme.colorScheme.surface, // Background color
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  // Access your list data using the group.x (index)
                  '${list[group.x].date}\n',
                  TextStyle(
                    color: Get.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: CurrenceConverter.getCurrenceFloatk(
                        rod.toY,
                        _userController.user.value?.baseCurrence ?? '',
                      ),
                      style: TextStyle(
                        color: primaryColor, // Your primary color
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // --- GRID AND BORDER ---
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // Cleaner look without vertical grid lines
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Get.theme.colorScheme.onSurface.withAlpha(100),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: textColor.withAlpha(150), width: 1),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),

          // --- AXIS TITLES ---
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // Y-Axis Labels (Left Titles)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    CurrenceConverter.getCurrenceFloatk(
                      value,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withAlpha(200),
                    ),
                  );
                },
              ),
            ),

            // X-Axis Labels (Bottom Titles)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize:
                    45, // Increased reserved space to fit rotated labels
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();
                  if (index >= 0 && index < list.length) {
                    // 🚀 FIX: Apply rotation to the Text widget
                    return Transform.rotate(
                      angle:
                          -45 * (3.1415926535 / 180), // Rotate by -45 degrees
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          list[index].date,
                          style: TextStyle(
                            fontSize: 10,
                            color: textColor.withAlpha(200),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),

          // 1. Define the actual bars (data points)
          barGroups: [
            ...list.indexed.map(
              (e) => BarChartGroupData(
                x: e.$1,
                barRods: [
                  BarChartRodData(
                    toY: e.$2.totalProfit, // Bar height
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ), // Rounded tops for modern look
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ).sizedBox(
        height: 250,
        width: double.infinity,
      ); // Increased height for better view
    });
  }

  _getWeeklySalesChart() {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return MistLoader1();
      }
      if (list.isEmpty) {
        return "Weekly sales chart is empty".text();
      }

      // --- MODERN STYLING ENHANCEMENTS ---
      final primaryColor = Get.theme.colorScheme.primary;
      final textColor = Get.theme.textTheme.bodyMedium?.color ?? Colors.black;

      return LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Get.theme.colorScheme.surface,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final textStyle = TextStyle(
                    color: Get.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );

                  return LineTooltipItem(
                    // Using the x value as index to get the date from your list
                    '${list[touchedSpot.x.toInt()].date}\n',
                    textStyle,
                    children: [
                      TextSpan(
                        text: CurrenceConverter.getCurrenceFloatk(
                          touchedSpot.y,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          // Add padding around the chart area for better aesthetics
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // Cleaner look without vertical grid lines
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Get.theme.colorScheme.onSurface.withAlpha(70),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: textColor.withAlpha(120), width: 1),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),

          // --- AXIS TITLES ---
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // Y-Axis Labels (Left Titles)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60, // Reduced reserved space for a tighter look
                getTitlesWidget: (value, meta) {
                  return Text(
                    CurrenceConverter.getCurrenceFloatk(
                      value,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withAlpha(200),
                    ),
                  );
                },
              ),
            ),

            // X-Axis Labels (Bottom Titles)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize:
                    45, // Increased reserved space to fit rotated labels
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();
                  if (index >= 0 && index < list.length) {
                    // 🚀 FIX: Apply rotation to the Text widget
                    return Transform.rotate(
                      angle:
                          -45 *
                          (3.1415926535 /
                              180), // Rotate by -45 degrees (in radians)
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          list[index].date,
                          style: TextStyle(
                            fontSize: 10,
                            color: textColor.withAlpha(200),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),

          // --- LINE DATA (The Curve) ---
          lineBarsData: [
            LineChartBarData(
              spots: list.indexed.map((e) {
                return FlSpot(e.$1.toDouble(), e.$2.totalPaid.toDouble());
              }).toList(),
              isCurved: true,
              color: primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: primaryColor.withAlpha(
                        100,
                      ), // Darker dot for emphasis
                      strokeColor: primaryColor.withAlpha(120),
                      strokeWidth: 2,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true, // Show area fill for a more modern look
                color: primaryColor.withAlpha(120),
              ),
            ),
          ],
        ),
      ).sizedBox(
        height: 250,
        width: double.infinity,
      ); // Increased height for aesthetics
    });
  }

  _getWeeklyVisitorsChart() {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return MistLoader1();
      }
      if (list.isEmpty) {
        return "Weekly visitors chart is empty".text();
      }

      // --- MODERN STYLING VARIABLES ---
      final primaryColor = Get.theme.colorScheme.primary;
      final textColor = Get.theme.textTheme.bodyMedium?.color ?? Colors.black;

      return BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Get.theme.colorScheme.surface,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${list[group.x].date}\n',
                  TextStyle(
                    color: Get.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      // Show as a whole number since you can't have half a visitor
                      text: '${rod.toY.toInt()} Visitors',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Add padding around the chart area for better aesthetics
          minY: 0,
          alignment: BarChartAlignment.spaceAround,

          // --- GRID AND BORDER ---
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // Cleaner look without vertical grid lines
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Get.theme.colorScheme.onSurface.withAlpha(50),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: textColor.withAlpha(150), width: 1),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),

          // --- AXIS TITLES ---
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // Y-Axis Labels (Left Titles) - Showing Visitor Count
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1.0,
                getTitlesWidget: (value, meta) {
                  // Show visitor count as integers
                  if (value.toInt() > 0 || value == meta.min) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withAlpha(200),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),

            // X-Axis Labels (Bottom Titles) - Rotated Dates
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize:
                    45, // Increased reserved space to fit rotated labels
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();
                  if (index >= 0 && index < list.length) {
                    // 🚀 FIX: Apply rotation to the Text widget
                    return Transform.rotate(
                      angle:
                          -45 * (3.1415926535 / 180), // Rotate by -45 degrees
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          list[index].date,
                          style: TextStyle(
                            fontSize: 10,
                            color: textColor.withAlpha(200),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),

          // 1. Define the actual bars (data points)
          barGroups: [
            ...list.indexed.map(
              (e) => BarChartGroupData(
                x: e.$1,
                barRods: [
                  BarChartRodData(
                    toY: e.$2.uniqueCustomersCount.toDouble(), // Bar height
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ), // Rounded tops
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ).sizedBox(
        height: 250,
        width: double.infinity,
      ); // Increased height for better view
    });
  }

  void _loadWithUpdatedTimeFrame() async {
    _adminController.getAdminStats(startDate: _startDate, endDate: _endDate);
  }

  void _loadWithWeekTimeFrame() async {
    _adminController.getWeeklyProfits(endDate: _weeklyRange);
  }

  void printDocument() {
    PDFMaker maker = PDFMaker();
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    maker
        .createPDF(
          AdminOverviewPdf(
            week: _weeklyRange,
            endDate: _endDate ?? DateTime.now(),
            startDate: _startDate ?? DateTime.now(),
            baseCurrence: baseCurrency, // Now guaranteed to be non-null
            statsProductModel: _adminController.statsPoducts.value,
            totalProducts: _adminController.totalProducts.value,
            statsSalesModel: _adminController.statsSales.value,
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
