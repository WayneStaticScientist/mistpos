import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/admin_controller.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: InkWell(
                onTap: _showPrimaryDateRangePicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withAlpha(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Get.theme.colorScheme.primary,
                      ),
                      12.gapWidth,
                      Text(
                        _startDate == null
                            ? "All Time Data"
                            : "${MistDateUtils.getInformalShortDate(_startDate!)}  —  ${MistDateUtils.getInformalShortDate(_endDate ?? DateTime.now())}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: "Product Overview".text(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            16.gapHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 800
                      ? 4
                      : (constraints.maxWidth > 500 ? 2 : 1);
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.6,
                    children: [
                      _buildDashboardMetricCard(
                        "Total Products",
                        _adminController.totalProducts.value.toString(),
                        Icons.inventory_2_outlined,
                        Colors.indigo,
                      ),
                      _buildDashboardMetricCard(
                        "Items In Stock",
                        _adminController.statsPoducts.value?.totalStock
                                .toString() ??
                            "0",
                        Icons.warehouse_outlined,
                        Colors.blue,
                      ),
                      _buildDashboardMetricCard(
                        "Stock Value",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          _adminController.statsPoducts.value?.totalCost ?? 0,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.attach_money,
                        Colors.teal,
                      ),
                      _buildDashboardMetricCard(
                        "Projected Revenue",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          _adminController.statsPoducts.value?.totalRevenue ??
                              0,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ],
                  );
                },
              ),
            ),
            24.gapHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: "Sales Overview".text(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            16.gapHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 800
                      ? 4
                      : (constraints.maxWidth > 500 ? 2 : 1);
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.6,
                    children: [
                      _buildDashboardMetricCard(
                        "Total Sales",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          _adminController.statsSales.value?.totalSales ?? 0,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.point_of_sale_outlined,
                        Colors.green,
                      ),
                      _buildDashboardMetricCard(
                        "Gross Profit",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          (_adminController.statsSales.value?.totalSales ?? 0) -
                              (_adminController.statsSales.value?.totalCost ??
                                  0),
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.account_balance_wallet_outlined,
                        Colors.teal,
                      ),
                      _buildDashboardMetricCard(
                        "Net Profit",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          ((_adminController.statsSales.value?.totalSales ??
                                      0) -
                                  (_adminController
                                          .statsSales
                                          .value
                                          ?.totalCost ??
                                      0)) -
                              (_adminController
                                      .statsSales
                                      .value
                                      ?.totalExpenses ??
                                  0),
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.savings_outlined,
                        Colors.deepPurple,
                      ),
                      _buildDashboardMetricCard(
                        "Expenses",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          (_adminController.statsSales.value?.totalExpenses ??
                              0),
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.money_off_outlined,
                        Colors.red,
                      ),
                      _buildDashboardMetricCard(
                        "Taxes",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          _adminController.statsSales.value?.totalTaxs ?? 0,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.gavel_outlined,
                        Colors.blueGrey,
                      ),
                      _buildDashboardMetricCard(
                        "Active Cashiers",
                        _adminController.statsSales.value?.numberOfCashiers
                                .toString() ??
                            "0",
                        Icons.people_outline,
                        Colors.purple,
                      ),
                      _buildDashboardMetricCard(
                        "Total Receipts",
                        _adminController.statsSales.value?.totalReceipts
                                .toString() ??
                            "0",
                        Icons.receipt_long_outlined,
                        Colors.amber.shade800,
                      ),
                      _buildDashboardMetricCard(
                        "Discounts",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          _adminController.statsSales.value?.totalDiscounts ??
                              0,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        Icons.local_offer_outlined,
                        Colors.orange,
                      ),
                    ],
                  );
                },
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: _showSecondaryDatePicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withAlpha(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
                        color: Get.theme.colorScheme.primary,
                      ),
                      12.gapWidth,
                      Text(
                        "End Date: ${MistDateUtils.getInformalShortDate(_weeklyRange)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
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

  Obx _getWeeklyProfitsBarChart() {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return MistLoader1();
      }
      if (list.isEmpty) {
        return _buildEmptyChartDisplay(
          "No profit metrics recorded this week",
          Icons.bar_chart_rounded,
        );
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

  Obx _getWeeklySalesChart() {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return MistLoader1();
      }
      if (list.isEmpty) {
        return _buildEmptyChartDisplay(
          "No sales trends found for this period",
          Icons.show_chart_rounded,
        );
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

  Obx _getWeeklyVisitorsChart() {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return MistLoader1();
      }
      if (list.isEmpty) {
        return _buildEmptyChartDisplay(
          "No visitor analytics gathered yet",
          Icons.analytics_rounded,
        );
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

  Widget _buildDashboardMetricCard(
    String title,
    String value,
    IconData icon,
    Color baseColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: baseColor.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: baseColor, size: 28),
          ),
          16.gapWidth,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                8.gapHeight,
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPrimaryDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 7)),
              end: DateTime.now(),
            ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Get.theme.colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadWithUpdatedTimeFrame();
    }
  }

  Future<void> _showSecondaryDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _weeklyRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Get.theme.colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _weeklyRange = picked;
      });
      _loadWithWeekTimeFrame();
    }
  }

  Widget _buildEmptyChartDisplay(String message, IconData icon) {
    return Container(
      height: 200,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.surface(context).withAlpha(100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey.withAlpha(150)),
          12.gapHeight,
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
