import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:printing/printing.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/data/models/dialy_sale_model.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_daily_sales.dart';

class DailySales extends StatefulWidget {
  const DailySales({super.key});

  @override
  State<DailySales> createState() => DailySalesState();
}

class DailySalesState extends State<DailySales> {
  final _controller = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  DateTime _selectedDate = DateTime.now();
  DateTime _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getDailySales(DateTime.now(), DateTime.now());
    });
  }

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      _selectedDate = date.end;
      _startDate = date.start;
    });
    _controller.getDailySales(_selectedDate, _startDate);
  }

  void printDocument() async {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    final summary = _controller.dailySalesSummary.value;
    if (summary == null) {
      Toaster.showError("No data to print.");
      return;
    }
    try {
      final pdf = await PdfDailySales.generate(
        endDate: _selectedDate,
        startDate: _startDate,
        baseCurrence: baseCurrency,
        dailySales: summary.itemsSold, // Keep this for PDF compatibility
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Daily_Sales_Report',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Colors.blue.shade600;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER & DATE PICKER ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: _changeDateRange,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withAlpha(50)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Iconify(Bx.calendar, color: primary, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "From ${MistDateUtils.getInformalShortDate(_startDate)} to ${(DateUtils.isSameDay(_selectedDate, DateTime.now()) ? "Today" : MistDateUtils.getInformalShortDate(_selectedDate))}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.print, color: Colors.white),
                  onPressed: printDocument,
                  tooltip: 'Print Report',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Obx(() {
            if (_controller.loadingDailySales.value) {
              return const SizedBox(
                height: 300,
                child: Center(child: MistLoader1()),
              );
            }
            final summary = _controller.dailySalesSummary.value;
            if (summary == null) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: Text(
                    "No sales data available.",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── KPI METRICS ──
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final cols = constraints.maxWidth > 800 ? 4 : 2;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: cols,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: constraints.maxWidth > 800 ? 2 : 1.5,
                      children: [
                        _buildKpiCard(
                          "Total Sales",
                          summary.totalSales,
                          primary,
                          Icons.point_of_sale,
                        ),
                        _buildKpiCard(
                          "Gross Profit",
                          summary.grossProfit,
                          Colors.indigo.shade500,
                          Icons.monetization_on,
                        ),
                        _buildKpiCard(
                          "Net Profit",
                          summary.netProfit,
                          Colors.green.shade500,
                          Icons.account_balance_wallet,
                        ),
                        _buildKpiCard(
                          "Total Expenses",
                          summary.totalExpenses,
                          Colors.red.shade400,
                          Icons.money_off,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // ── FINANCIAL BREAKDOWN ──
                Text(
                  "Financial Breakdown",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOverviewPieChart(summary, primary),
                const SizedBox(height: 32),

                // ── CASHIER PERFORMANCE ──
                Text(
                  "Cashier Performance",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCashierPerformance(summary, primary),
                const SizedBox(height: 32),

                // ── REVENUE VS EXPENSES HOURLY CHART ──
                Text(
                  "Hourly Revenue & Expenses",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHourlyChart(summary.hourlyData, primary),
                const SizedBox(height: 32),

                // ── DATA TABLE ──
                Text(
                  "Items Sold",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _makeTable(summary.itemsSold),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withAlpha(isDark ? 200 : 255),
            color.withAlpha(isDark ? 150 : 200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(isDark ? 50 : 80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: Colors.white.withAlpha(150), size: 20),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrenceConverter.getCurrenceFloatInStrings(amount, baseCurrence),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyChart(List<HourlyData> hourlyData, Color primary) {
    if (hourlyData.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No hourly data available.")),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final currency = _userController.user.value?.baseCurrence ?? '';
    final expenseColor = Colors.red.shade400;

    double maxY = 0;
    for (var d in hourlyData) {
      if (d.revenue > maxY) maxY = d.revenue;
      if (d.expenses > maxY) maxY = d.expenses;
    }
    if (maxY == 0) maxY = 100; // default bound
    maxY *= 1.2;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E202C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          clipData: const FlClipData.all(),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final isRevenue = spot.barIndex == 0;
                  return LineTooltipItem(
                    "${spot.x.toInt()}:00\n",
                    TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "${isRevenue ? 'Rev: ' : 'Exp: '}${CurrenceConverter.getCurrenceFloatk(spot.y, currency)}",
                        style: TextStyle(
                          color: isRevenue ? primary : expenseColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: textColor.withAlpha(20), strokeWidth: 1),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: textColor.withAlpha(80)),
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value % 4 != 0 && value != 23) {
                    return const SizedBox.shrink();
                  } // discrete labels
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "${value.toInt()}:00",
                      style: TextStyle(
                        color: textColor.withAlpha(150),
                        fontSize: 10,
                      ),
                    ),
                  );
                },
                reservedSize: 22,
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    CurrenceConverter.getCurrenceFloatk(value, currency),
                    style: TextStyle(
                      color: textColor.withAlpha(150),
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: hourlyData
                  .map((e) => FlSpot(e.hour.toDouble(), e.revenue))
                  .toList(),
              isCurved: true,
              color: primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [primary.withAlpha(80), primary.withAlpha(0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            LineChartBarData(
              spots: hourlyData
                  .map((e) => FlSpot(e.hour.toDouble(), e.expenses))
                  .toList(),
              isCurved: true,
              color: expenseColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeTable(List<DialySaleModel> itemsSold) {
    if (itemsSold.isEmpty) {
      return Center(
        child: Text(
          "No items sold.",
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = _userController.user.value?.baseCurrence ?? '';

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E202C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 20,
        minWidth: ScreenSizes.maxWidth,
        headingRowColor: WidgetStateProperty.resolveWith(
          (states) => isDark ? Colors.black12 : Colors.grey.shade50,
        ),
        columns: [
          DataColumn2(
            label: Text(
              'Item Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text(
              'Qty Sold',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text(
              'Sell Price',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text(
              'Unit Cost',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text(
              'Total Sales',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.M,
            numeric: true,
          ),
        ],
        rows: itemsSold.map((e) {
          final unitSellPrice = e.totalCount > 0
              ? e.totalSales / e.totalCount
              : 0.0;
          final unitCost = e.totalCount > 0 ? e.totalCosts / e.totalCount : 0.0;
          return DataRow(
            cells: <DataCell>[
              DataCell(
                Text(
                  e.productName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(Text(e.totalCount.toString())),
              DataCell(
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    unitSellPrice,
                    currency,
                  ),
                ),
              ),
              DataCell(
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    unitCost,
                    currency,
                  ),
                ),
              ),
              DataCell(
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.totalSales,
                    currency,
                  ),
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewPieChart(DailySalesSummary summary, Color primary) {
    if (summary.totalSales <= 0) {
      return const SizedBox(
        height: 220,
        width: double.infinity,
        child: Center(
          child: Text(
            "No sales data for pie chart",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final totalSales = summary.totalSales;
    final costs = summary.totalSales - summary.grossProfit;
    final expenses = summary.totalExpenses;
    final netProfit = summary.netProfit;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 220,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    if (costs > 0)
                      PieChartSectionData(
                        color: const Color(0xFFFFA726),
                        value: costs,
                        title:
                            '${(costs / totalSales * 100).toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (expenses > 0)
                      PieChartSectionData(
                        color: const Color(0xFFFF4D6A),
                        value: expenses,
                        title:
                            '${(expenses / totalSales * 100).toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (netProfit > 0)
                      PieChartSectionData(
                        color: const Color(0xFF00C896),
                        value: netProfit,
                        title:
                            '${(netProfit / totalSales * 100).toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIndicator(const Color(0xFFFFA726), 'Costs'),
                const SizedBox(height: 4),
                _buildIndicator(const Color(0xFFFF4D6A), 'Expenses'),
                const SizedBox(height: 4),
                _buildIndicator(const Color(0xFF00C896), 'Net Profit'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCashierPerformance(DailySalesSummary summary, Color primary) {
    if (summary.cashiers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "No cashier data available.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final currency = _userController.user.value?.baseCurrence ?? '';

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: summary.cashiers.length,
      itemBuilder: (context, index) {
        final cashier = summary.cashiers[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withAlpha(40)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primary.withAlpha(30),
                radius: 20,
                child: Icon(Icons.person, color: primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashier.cashierName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrenceConverter.getCurrenceFloatInStrings(
                        cashier.totalProcessed,
                        currency,
                      ),
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
