import 'package:exui/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class NavAdminOverView extends StatefulWidget {
  const NavAdminOverView({super.key});

  @override
  State<NavAdminOverView> createState() => _NavAdminOverViewState();
}

class _NavAdminOverViewState extends State<NavAdminOverView> {
  final _adminController = Get.find<AdminController>();
  DateTime? _startDate;
  DateTime? _endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _adminController.getWeeklyProfits(endDate: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        18.gapHeight,
        SingleChildScrollView(
          child:
              [
                    "Pick Range".text().textButton(onPressed: _pickdateRange),
                    18.gapWidth,
                    _startDate == null
                        ? "First Day".text()
                        : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                              .text(),
                    18.gapWidth,
                    "-".text(),
                    18.gapWidth,
                    _endDate == null
                        ? "To day".text()
                        : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                              .text(),
                  ]
                  .row()
                  .onTap(_pickdateRange)
                  .decoratedBox(
                    decoration: BoxDecoration(color: AppTheme.surface),
                  ),
        ),
        18.gapHeight,
        "Product Overview".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        18.gapHeight,
        Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            children: [
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
                label: "Total Expense",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsPoducts.value?.totalCost ?? 0,
                ),
              ),
            ],
          ).sizedBox(height: 110, width: double.infinity),
        ),
        18.gapHeight,
        "Sales Overview".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        18.gapHeight,
        Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CardOverview(
                label: "Profit ",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  (_adminController.statsSales.value?.totalSales ?? 0) -
                      (_adminController.statsSales.value?.totalCost ?? 0),
                ),
              ),
              18.gapWidth,
              CardOverview(
                label: "Total Sales",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalSales ?? 0,
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
            ],
          ).sizedBox(height: 110, width: double.infinity),
        ),

        Obx(
          () =>
              _adminController.statsSales.value?.cashiers != null &&
                  _adminController.statsSales.value!.cashiers.isNotEmpty
              ? [
                  18.gapHeight,
                  "Active Cashiers".text(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  18.gapHeight,
                  ..._adminController.statsSales.value!.cashiers.map(
                    (e) => Card(child: ListTile(title: e.name.text())),
                  ),
                ].column(crossAxisAlignment: CrossAxisAlignment.start)
              : SizedBox(),
        ),
        "Weekly Profits".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        _getWeeklyProfitsBarChart(),
        32.gapHeight,
        "Weekly Sales".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        _getWeeklySalesChart(),
        32.gapHeight,
        "Weekly Visitors".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        _getWeeklyVisitorsChart(),
      ],
    ).sizedBox(width: double.infinity);
  }

  void _pickdateRange() async {
    final date = await showRangePickerDialog(
      context: context,
      minDate: DateTime(2021, 1, 1),
      maxDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      _startDate = date.start;
      _endDate = date.end;
    });
    _adminController.getAdminStats(startDate: _startDate, endDate: _endDate);
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
      return BarChart(
        BarChartData(
          // 1. Define the actual bars (data points)
          barGroups: [
            ...list.indexed.map(
              (e) => BarChartGroupData(
                x: e.$1,
                barRods: [
                  BarChartRodData(
                    toY: e.$2.totalProfit, // Bar height
                    color: Get.theme.colorScheme.primary,
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(list[value.toInt()].date);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80,
                getTitlesWidget: (value, meta) {
                  return Text(CurrenceConverter.getCurrenceFloatk(value));
                },
              ), // Y-axis labels
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false), // Hide the chart border
        ),
      ).sizedBox(height: 200, width: double.infinity);
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
      return LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: list.indexed.map((e) {
                return FlSpot(
                  e.$1.toDouble(), // X-value (index)
                  e.$2.totalPaid.toDouble(), // Y-value (totalPaid)
                );
              }).toList(),
              isCurved:
                  true, // Set to true for a smooth curve, false for straight lines
              color: Get
                  .theme
                  .colorScheme
                  .primary, // Use the same color as the bar
              barWidth: 3,
              dotData: FlDotData(show: true), // Show dots at each data point
              belowBarData: BarAreaData(
                show: false,
              ), // Optional: set to true to fill the area below the line
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  // Check bounds to prevent errors
                  final int index = value.toInt();
                  if (index >= 0 && index < list.length) {
                    return Text(list[index].date);
                  }
                  return Container();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80,
                getTitlesWidget: (value, meta) {
                  return Text(CurrenceConverter.getCurrenceFloatk(value));
                }, // Y-axis labels
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false), // Hide the chart border
        ),
      ).sizedBox(height: 200, width: double.infinity);
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
      return BarChart(
        BarChartData(
          // 1. Define the actual bars (data points)
          barGroups: [
            ...list.indexed.map(
              (e) => BarChartGroupData(
                x: e.$1,
                barRods: [
                  BarChartRodData(
                    toY: e.$2.uniqueCustomersCount.toDouble(), // Bar height
                    color: Get.theme.colorScheme.primary,
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(list[value.toInt()].date);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80,
                getTitlesWidget: (value, meta) {
                  return Text(CurrenceConverter.getCurrenceFloatk(value));
                },
              ), // Y-axis labels
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false), // Hide the chart border
        ),
      ).sizedBox(height: 200, width: double.infinity);
    });
  }
}
