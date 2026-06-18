import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:iconify_flutter/iconify_flutter.dart' show Iconify;
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/data/models/sales_by_employee_model.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_sales_by_employee.dart';

class NavSalesByEmployee extends StatefulWidget {
  const NavSalesByEmployee({super.key});

  @override
  State<NavSalesByEmployee> createState() => NavSalesByEmployeeState();
}

class NavSalesByEmployeeState extends State<NavSalesByEmployee> {
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  DateTime _startDate = DateTime(2020, 1, 1);
  DateTime _endDate = DateTime.now();
  bool _isAllTime = true;
  String _selectedPeriod = 'daily';
  DateTime _chartEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() {
    _adminController.getSalesByEmployee(_startDate, _endDate);
    _adminController.getWeeklyProfits(endDate: _chartEndDate, period: _selectedPeriod);
  }

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date.start;
        _endDate = date.end;
        _isAllTime = false;
      });
      _loadData();
    }
  }

  void _clearDateRange() {
    setState(() {
      _startDate = DateTime(2020, 1, 1);
      _endDate = DateTime.now();
      _isAllTime = true;
    });
    _loadData();
  }

  void _reloadChart() {
    _adminController.getWeeklyProfits(endDate: _chartEndDate, period: _selectedPeriod);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Colors.blue.shade600;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ──
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              const Text("Employee Sales & Performance", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _changeDateRange,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          Text(
                            _isAllTime 
                              ? "All Time"
                              : "From ${MistDateUtils.getInformalShortDate(_startDate)} to ${(DateUtils.isSameDay(_endDate, DateTime.now()) ? "Today" : MistDateUtils.getInformalShortDate(_endDate))}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
                        ],
                      ),
                    ),
                  ),
                  if (!_isAllTime) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: _clearDateRange,
                      tooltip: 'Clear Date Filter',
                    ),
                  ],
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: const Icon(Icons.print, color: Colors.white),
                      onPressed: printDocument,
                      tooltip: 'Print Report',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Obx(() {
            if (_adminController.loadingSalesByEmployee.value) {
              return const SizedBox(height: 300, child: Center(child: MistLoader1()));
            }
            if (_adminController.salesByEmployee.isEmpty) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: Text("No sales data available for this date range.", style: TextStyle(color: Colors.grey.shade500)),
                ),
              );
            }

            final totalGross = _adminController.salesByEmployee.fold(0.0, (prev, data) => prev + data.grossSales);
            final totalReceipts = _adminController.salesByEmployee.fold(0, (prev, data) => prev + data.numberOfReceipts);
            final totalExpenses = _adminController.salesByEmployee.fold(0.0, (prev, data) => prev + data.expenses);
            
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
                        _buildKpiCard("Active Employees", _adminController.salesByEmployee.length.toDouble(), Colors.purple.shade400, Icons.people, isCurrency: false),
                        _buildKpiCard("Gross Sales", totalGross, primary, Icons.monetization_on, isCurrency: true),
                        _buildKpiCard("Total Expenses", totalExpenses, Colors.red.shade400, Icons.money_off, isCurrency: true),
                        _buildKpiCard("Total Receipts", totalReceipts.toDouble(), Colors.orange.shade500, Icons.receipt, isCurrency: false),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // ── EMPLOYEE BREAKDOWN PIE CHARTS ──
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final isWide = constraints.maxWidth > 800;
                    return isWide
                        ? Row(
                            children: [
                              Expanded(child: _buildPieChartCard("Sales by Employee", true)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildPieChartCard("Expenses by Employee", false)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildPieChartCard("Sales by Employee", true),
                              const SizedBox(height: 16),
                              _buildPieChartCard("Expenses by Employee", false),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 32),

                // ── ANALYTICS TREND GRAPHS ──
                _buildChartHeader(context, primary),
                const SizedBox(height: 16),
                _buildChartCard(context, "Company Gross Sales", _buildSalesChart(context, primary)),
                const SizedBox(height: 32),

                // ── DATA TABLE ──
                Text("Employee Sales Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  child: _makeTable(_adminController.salesByEmployee),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, double amount, Color color, IconData icon, {bool isCurrency = true}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(isDark ? 200 : 255), color.withAlpha(isDark ? 150 : 200)],
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
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
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
              isCurrency ? CurrenceConverter.getCurrenceFloatInStrings(amount, baseCurrence) : amount.toInt().toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard(String title, bool isSales) {
    final list = _adminController.salesByEmployee;
    final validData = list.where((e) => isSales ? e.grossSales > 0 : e.expenses > 0).toList();
    validData.sort((a, b) => isSales ? b.grossSales.compareTo(a.grossSales) : b.expenses.compareTo(a.expenses));
    
    final topData = validData.take(5).toList();
    final otherTotal = validData.skip(5).fold(0.0, (prev, e) => prev + (isSales ? e.grossSales : e.expenses));
    
    if (topData.isEmpty) {
      return Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Expanded(child: Center(child: Text("No data available", style: TextStyle(color: Colors.grey)))),
          ],
        ),
      );
    }

    final colors = [
      const Color(0xFF00C896),
      const Color(0xFF00A2FF),
      const Color(0xFFFFA726),
      const Color(0xFFFF4D6A),
      const Color(0xFF8E44AD),
      Colors.grey.shade400,
    ];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: [
                        for (int i = 0; i < topData.length; i++)
                          PieChartSectionData(
                            color: colors[i],
                            value: isSales ? topData[i].grossSales : topData[i].expenses,
                            title: '',
                            radius: 40,
                          ),
                        if (otherTotal > 0)
                          PieChartSectionData(
                            color: colors[5],
                            value: otherTotal,
                            title: '',
                            radius: 40,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < topData.length; i++) ...[
                          _buildIndicator(colors[i], topData[i].sellerName),
                          const SizedBox(height: 4),
                        ],
                        if (otherTotal > 0)
                          _buildIndicator(colors[5], 'Others'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color), maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  // ── Chart Header & Tabs ──
  Widget _buildChartHeader(BuildContext context, Color primary) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        const Text("Overall Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(3),
          child: Wrap(
            spacing: 4,
            children: [
              _buildPill('Daily', 'daily', primary),
              _buildPill('Monthly', 'monthly', primary),
              _buildPill('Yearly', 'yearly', primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPill(String label, String value, Color primary) {
    final selected = _selectedPeriod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
          _chartEndDate = DateTime.now();
        });
        _reloadChart();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
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
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildSalesChart(BuildContext context, Color primary) {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return const SizedBox(
          height: 220,
          child: Center(child: MistLoader1()),
        );
      }
      if (list.isEmpty) {
        return const SizedBox(
          height: 220,
          child: Center(child: Text("No sales data yet", style: TextStyle(color: Colors.grey))),
        );
      }
      final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
      final currency = _userController.user.value?.baseCurrence ?? '';
      return SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            clipData: const FlClipData.all(),
            minY: 0,
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
                getTooltipItems: (spots) {
                  return spots
                      .map(
                        (spot) => LineTooltipItem(
                          '${_formatChartXAxis(list[spot.x.toInt()].date)}\n',
                          TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: CurrenceConverter.getCurrenceFloatk(spot.y, currency),
                              style: TextStyle(color: primary, fontSize: 11),
                            ),
                          ],
                        ),
                      )
                      .toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(bottom: BorderSide(color: textColor.withAlpha(80))),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 56,
                  getTitlesWidget: (v, _) => Text(
                    CurrenceConverter.getCurrenceFloatk(v, currency),
                    style: TextStyle(fontSize: 9, color: textColor.withAlpha(160)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (v, _) {
                    if (v % 1 != 0) return const SizedBox.shrink();
                    final i = v.toInt();
                    if (i < 0 || i >= list.length) return const SizedBox.shrink();
                    return Transform.rotate(
                      angle: -0.6,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _formatChartXAxis(list[i].date),
                          style: TextStyle(fontSize: 9, color: textColor.withAlpha(160)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: list.indexed
                    .map((e) => FlSpot(e.$1.toDouble(), e.$2.totalPaid))
                    .toList(),
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primary.withAlpha(100), primary.withAlpha(0)],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatChartXAxis(String raw) {
    if (_selectedPeriod == 'daily') return raw;
    if (_selectedPeriod == 'monthly') {
      try {
        final monthInt = int.parse(raw);
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        if (monthInt >= 1 && monthInt <= 12) return months[monthInt - 1];
      } catch (_) {}
    }
    return raw;
  }

  Widget _makeTable(RxList<SalesByEmployeeModel> salesByEmployee) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 20,
        minWidth: 1000,
        headingRowColor: WidgetStateProperty.resolveWith((states) => isDark ? Colors.black12 : Colors.grey.shade50),
        columns: [
          DataColumn2(label: Text('Seller Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.L),
          DataColumn2(label: Text('Gross Sales', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.M, numeric: true),
          DataColumn2(label: Text('Average Sales', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.M, numeric: true),
          DataColumn2(label: Text('Discounts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.M, numeric: true),
          DataColumn2(label: Text('Refunds', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.M, numeric: true),
          DataColumn2(label: Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.M, numeric: true),
          DataColumn2(label: Text('Receipts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.S, numeric: true),
          DataColumn2(label: Text('Customers', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)), size: ColumnSize.S, numeric: true),
        ],
        rows: salesByEmployee.map((e) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(e.sellerName, style: const TextStyle(fontWeight: FontWeight.w600))),
              DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.grossSales, baseCurrence))),
              DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.averageSales, baseCurrence))),
              DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.discounts, baseCurrence))),
              DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.refunds, baseCurrence), style: TextStyle(color: e.refunds > 0 ? Colors.red : null))),
              DataCell(Text(CurrenceConverter.getCurrenceFloatInStrings(e.expenses, baseCurrence), style: TextStyle(color: e.expenses > 0 ? Colors.orange : null))),
              DataCell(Text(e.numberOfReceipts.toString())),
              DataCell(Text(e.uniqueCustomerCount.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }


  void printDocument() async {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await PdfSalesByEmployee.generate(
        endDate: _endDate,
        startDate: _startDate,
        baseCurrence: baseCurrency,
        salesByEmployee: _adminController.salesByEmployee,
      );
      
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Sales_By_Employee_Report',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }
}
