import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/data/models/monthly_report_model.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class NavMonthlyReports extends StatefulWidget {
  const NavMonthlyReports({super.key});
  @override
  State<NavMonthlyReports> createState() => _NavMonthlyReportsState();
}

class _NavMonthlyReportsState extends State<NavMonthlyReports> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _inventoryController = Get.find<InventoryController>();

  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  bool _isProUser() {
    if (_inventoryController.company.value == null) return false;
    return MistDateUtils.getDaysDifference(
            _inventoryController.company.value!.subscriptionType.validUntil!) >=
        0 &&
        MistSubscriptionUtils.proList.contains(
          _inventoryController.company.value!.subscriptionType.type,
        );
  }

  void _fetchReport() {
    // start is 1st of month
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    // end is last day of month
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);

    _adminController.fetchMonthlyReport(startDate: start, endDate: end);
  }

  Future<void> _pickMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      // Make it easy to pick months by setting initialDatePickerMode to year
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
      _fetchReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_isProUser()) {
        return const SubscriptionAlert();
      }

      final primary = Theme.of(context).colorScheme.primary;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Picker Header
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickMonth(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_outlined, size: 18, color: primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year} Report",
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_adminController.monthlyReport.value != null && !_adminController.loadingMonthlyReport.value)
                  InkWell(
                    onTap: () => _printPdf(context, _adminController.monthlyReport.value!),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.print_outlined, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text("Export PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            if (_adminController.loadingMonthlyReport.value)
              MistLoader1().center()
            else if (_adminController.monthlyReportError.value.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "Error: ${_adminController.monthlyReportError.value}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (_adminController.monthlyReport.value == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text("Report data is unavailable.", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchReport,
                        child: const Text("Reload Report"),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              _buildSectionLabel('Financial Overview', primary),
              const SizedBox(height: 16),
              _buildKpiGrid(context, _adminController.monthlyReport.value!),
              const SizedBox(height: 24),

              _buildRecommendationCard(context, _adminController.monthlyReport.value!, primary),
              const SizedBox(height: 24),

              _buildSectionLabel('Charts & Analytics', primary),
              const SizedBox(height: 16),
              _buildChartCard(
                context,
                'Monthly Revenue Trend',
                _buildRevenueChart(context, primary, _adminController.monthlyReport.value!),
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                context,
                'Monthly Expenses Trend',
                _buildExpensesChart(context, const Color(0xFFFF4D6A), _adminController.monthlyReport.value!),
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                context,
                'Profit vs Expenses Breakdown',
                _buildPieChart(context, _adminController.monthlyReport.value!),
              ),
              const SizedBox(height: 24),

              _buildSectionLabel('Top 5 Performing Days', primary),
              const SizedBox(height: 16),
              _buildTopDaysTable(context, _adminController.monthlyReport.value!),
              
              const SizedBox(height: 24),
              _buildSectionLabel('Top 5 Largest Expenses', primary),
              const SizedBox(height: 16),
              _buildTopExpensesTable(context, _adminController.monthlyReport.value!),
            ],
            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildSectionLabel(String label, Color primary) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
        ),
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context, MonthlyReportModel report) {
    final currency = _userController.user.value?.baseCurrence ?? '';

    final items = [
      _KpiData('Total Revenue', CurrenceConverter.getCurrenceFloatInStrings(report.totalRevenue, currency), Icons.point_of_sale_outlined, const Color(0xFF00C896)),
      _KpiData('Gross Profit', CurrenceConverter.getCurrenceFloatInStrings(report.totalProfit + report.totalExpenses, currency), Icons.account_balance_wallet_outlined, const Color(0xFF3ECFCF)),
      _KpiData('Net Profit', CurrenceConverter.getCurrenceFloatInStrings(report.totalProfit, currency), Icons.trending_up, const Color(0xFF6C63FF)),
      _KpiData('Total Expenses', CurrenceConverter.getCurrenceFloatInStrings(report.totalExpenses, currency), Icons.money_off_outlined, const Color(0xFFFF4D6A)),
      _KpiData('Total Losses', CurrenceConverter.getCurrenceFloatInStrings(report.totalLosses, currency), Icons.trending_down, const Color(0xFFE53935)),
      _KpiData('Refunds', CurrenceConverter.getCurrenceFloatInStrings(report.totalMoneyRefunded, currency), Icons.assignment_return_outlined, const Color(0xFFEC407A)),
      _KpiData('Items Sold', '${report.numberOfItemsSold}', Icons.inventory_2_outlined, const Color(0xFFFFA726)),
      _KpiData('Total Receipts', '${report.numberOfReceipts}', Icons.receipt_long_outlined, const Color(0xFFAB47BC)),
      _KpiData('Peak Sales Time', report.peakSalesTime, Icons.access_time_outlined, const Color(0xFF42A5F5)),
    ];

    return LayoutBuilder(builder: (ctx, c) {
      final cols = c.maxWidth > 700 ? 4 : 2;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
        children: items.map((d) => _buildKpiCard(d)).toList(),
      );
    });
  }

  Widget _buildKpiCard(_KpiData d) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [d.color.withAlpha(230), d.color.withAlpha(180)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: d.color.withAlpha(80), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(d.icon, color: Colors.white.withAlpha(220), size: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  d.value,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                d.label,
                style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, MonthlyReportModel report, Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sales Insight & Recommendation",
                  style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  report.salesRecommendation,
                  style: const TextStyle(height: 1.5, fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context, Color primary, MonthlyReportModel report) {
    final list = report.monthlyRevenueGraph;
    if (list.isEmpty) return const SizedBox(height: 220, child: Center(child: Text("No Data")));

    final currency = _userController.user.value?.baseCurrence ?? '';
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: textColor.withAlpha(25), strokeWidth: 1)),
          borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: textColor.withAlpha(80)))),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (val, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      CurrenceConverter.getCurrenceFloatk(val, currency),
                      style: TextStyle(color: textColor.withAlpha(150), fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  if (val.toInt() >= 0 && val.toInt() < list.length) {
                    final d = DateTime.tryParse(list[val.toInt()].date);
                    if (d != null && (d.day % 5 == 0 || d.day == 1)) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${d.day}', style: TextStyle(color: textColor, fontSize: 10)),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              getTooltipItems: (spots) => spots.map((spot) => LineTooltipItem(
                '${list[spot.x.toInt()].date}\n',
                TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 12),
                children: [
                  TextSpan(text: CurrenceConverter.getCurrenceFloatk(spot.y, currency), style: TextStyle(color: primary, fontSize: 11)),
                ]
              )).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: list.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.amount)).toList(),
              isCurved: true,
              color: primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: primary,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [primary.withAlpha(100), primary.withAlpha(0)]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesChart(BuildContext context, Color color, MonthlyReportModel report) {
    final list = report.expensesGraph;
    if (list.isEmpty) return const SizedBox(height: 220, child: Center(child: Text("No Data")));

    final currency = _userController.user.value?.baseCurrence ?? '';
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: textColor.withAlpha(25), strokeWidth: 1)),
          borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: textColor.withAlpha(80)))),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (val, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      CurrenceConverter.getCurrenceFloatk(val, currency),
                      style: TextStyle(color: textColor.withAlpha(150), fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  if (val.toInt() >= 0 && val.toInt() < list.length) {
                    final d = DateTime.tryParse(list[val.toInt()].date);
                    if (d != null && (d.day % 5 == 0 || d.day == 1)) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${d.day}', style: TextStyle(color: textColor, fontSize: 10)),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              getTooltipItems: (spots) => spots.map((spot) => LineTooltipItem(
                '${list[spot.x.toInt()].date}\n',
                TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 12),
                children: [
                  TextSpan(text: CurrenceConverter.getCurrenceFloatk(spot.y, currency), style: TextStyle(color: color, fontSize: 11)),
                ]
              )).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: list.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.amount)).toList(),
              isCurved: true,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withAlpha(100), color.withAlpha(0)]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, MonthlyReportModel report) {
    if (report.totalProfit == 0 && report.totalExpenses == 0 && report.totalLosses == 0) {
        return const SizedBox(height: 220, child: Center(child: Text("No Financial Data")));
    }
    
    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  if (report.totalProfit > 0)
                    PieChartSectionData(
                      color: const Color(0xFF6C63FF),
                      value: report.totalProfit,
                      title: '${((report.totalProfit / (report.totalProfit + report.totalExpenses + report.totalLosses)) * 100).toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  if (report.totalExpenses > 0)
                    PieChartSectionData(
                      color: const Color(0xFFFF4D6A),
                      value: report.totalExpenses,
                      title: '${((report.totalExpenses / (report.totalProfit + report.totalExpenses + report.totalLosses)) * 100).toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  if (report.totalLosses > 0)
                    PieChartSectionData(
                      color: const Color(0xFFE53935),
                      value: report.totalLosses,
                      title: '${((report.totalLosses / (report.totalProfit + report.totalExpenses + report.totalLosses)) * 100).toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIndicator(const Color(0xFF6C63FF), "Profit"),
              const SizedBox(height: 8),
              _buildIndicator(const Color(0xFFFF4D6A), "Expenses"),
              const SizedBox(height: 8),
              _buildIndicator(const Color(0xFFE53935), "Losses"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTopDaysTable(BuildContext context, MonthlyReportModel report) {
    if (report.top5SellingDays.isEmpty) return const Text("No sales recorded this month");
    final currency = _userController.user.value?.baseCurrence ?? '';

    return Container(
        height: (report.top5SellingDays.length * 56) + 56, // row height + header height
        decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withAlpha(20))
        ),
        child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 400,
            columns: const [
                DataColumn2(label: Text('Date'), size: ColumnSize.L),
                DataColumn2(label: Text('Total Sales'), size: ColumnSize.M, numeric: true),
            ],
            rows: report.top5SellingDays.map((e) {
                final d = DateTime.tryParse(e.date);
                final dStr = d != null ? MistDateUtils.getInformalDate(d) : e.date;
                return DataRow(cells: [
                    DataCell(Text(dStr)),
                    DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.sales, currency), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))),
                ]);
            }).toList()
        )
    );
  }

  Widget _buildTopExpensesTable(BuildContext context, MonthlyReportModel report) {
    if (report.top5ExpensiveExpenses.isEmpty) return const Text("No expenses recorded this month");
    final currency = _userController.user.value?.baseCurrence ?? '';

    return Container(
        height: (report.top5ExpensiveExpenses.length * 56) + 56,
        decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withAlpha(20))
        ),
        child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 400,
            columns: const [
                DataColumn2(label: Text('Date'), size: ColumnSize.S),
                DataColumn2(label: Text('Expense'), size: ColumnSize.L),
                DataColumn2(label: Text('Amount'), size: ColumnSize.S, numeric: true),
            ],
            rows: report.top5ExpensiveExpenses.map((e) {
                final d = DateTime.tryParse(e.date);
                final dStr = d != null ? MistDateUtils.getInformalShortDate(d) : e.date;
                return DataRow(cells: [
                    DataCell(Text(dStr)),
                    DataCell(Text(e.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
                    DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.amount, currency), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
                ]);
            }).toList()
        )
    );
  }

  Future<void> _printPdf(BuildContext context, MonthlyReportModel report) async {
    final currency = _userController.user.value?.baseCurrence ?? '';
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    final logoImage = await rootBundle.load('assets/launcher.png');
    final logoBytes = logoImage.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('MISTPOS', style: pw.TextStyle(color: PdfColors.blue, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text('Monthly Report - ${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                  ]
                ),
                pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50),
              ]
            ),
            pw.SizedBox(height: 30),
            
            // Overview Section
            pw.Text('Financial Overview', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                _buildPdfRow('Total Revenue', CurrenceConverter.getCurrenceFloatInStrings(report.totalRevenue, currency)),
                _buildPdfRow('Gross Profit', CurrenceConverter.getCurrenceFloatInStrings(report.totalProfit + report.totalExpenses, currency)),
                _buildPdfRow('Net Profit', CurrenceConverter.getCurrenceFloatInStrings(report.totalProfit, currency)),
                _buildPdfRow('Total Expenses', CurrenceConverter.getCurrenceFloatInStrings(report.totalExpenses, currency)),
                _buildPdfRow('Total Losses', CurrenceConverter.getCurrenceFloatInStrings(report.totalLosses, currency)),
                _buildPdfRow('Total Refunds', CurrenceConverter.getCurrenceFloatInStrings(report.totalMoneyRefunded, currency)),
                _buildPdfRow('Items Sold', '${report.numberOfItemsSold}'),
                _buildPdfRow('Total Receipts', '${report.numberOfReceipts}'),
                _buildPdfRow('Peak Sales Time', report.peakSalesTime),
              ]
            ),
            pw.SizedBox(height: 30),

            // Top 5 Days Table
            pw.Text('Top 5 Performing Days', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Date', 'Total Sales'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey600),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
              cellAlignment: pw.Alignment.centerLeft,
              data: report.top5SellingDays.map((e) {
                final d = DateTime.tryParse(e.date);
                final dStr = d != null ? MistDateUtils.getInformalDate(d) : e.date;
                return [dStr, CurrenceConverter.getCurrenceFloatInStrings(e.sales, currency)];
              }).toList(),
            ),

            pw.SizedBox(height: 30),

            // Top 5 Expenses Table
            pw.Text('Top 5 Largest Expenses', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Date', 'Expense', 'Amount'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey600),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
              cellAlignment: pw.Alignment.centerLeft,
              data: report.top5ExpensiveExpenses.map((e) {
                final d = DateTime.tryParse(e.date);
                final dStr = d != null ? MistDateUtils.getInformalShortDate(d) : e.date;
                return [dStr, e.name, CurrenceConverter.getCurrenceFloatInStrings(e.amount, currency)];
              }).toList(),
            ),
            pw.SizedBox(height: 30),

            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: PdfColors.blue200)
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Sales Insight & Recommendation", style: pw.TextStyle(color: PdfColors.blue800, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(report.salesRecommendation, style: const pw.TextStyle(color: PdfColors.blueGrey800))
                ]
              )
            )
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.TableRow _buildPdfRow(String label, String value) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Text(label, style: const pw.TextStyle(color: PdfColors.blueGrey800)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
      ]
    );
  }
}

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _KpiData(this.label, this.value, this.icon, this.color);
}
