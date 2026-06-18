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
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_overview.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/admin/controllers/goals_tasks_controller.dart';
import 'package:mistpos/features/admin/screens/screen_goals_tasks.dart';

class NavAdminOverView extends StatefulWidget {
  const NavAdminOverView({super.key});
  @override
  State<NavAdminOverView> createState() => NavAdminOverViewState();
}

class NavAdminOverViewState extends State<NavAdminOverView> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _goalsTasksController = Get.find<GoalsTasksController>();

  DateTime? _startDate;
  DateTime? _endDate = DateTime.now();
  DateTime _chartEndDate = DateTime.now();
  String _selectedPeriod = 'daily'; // daily | monthly | yearly

  String _formatChartXAxis(String dateStr) {
    if (_selectedPeriod == 'monthly') {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final idx = int.tryParse(dateStr);
      if (idx != null && idx >= 1 && idx <= 12) return months[idx - 1];
    }
    return dateStr;
  }

  @override
  void initState() {
    super.initState();
    _adminController.getWeeklyProfits(
      endDate: _chartEndDate,
      period: _selectedPeriod,
    );
  }

  void _reload() {
    _adminController.getWeeklyProfits(
      endDate: _chartEndDate,
      period: _selectedPeriod,
    );
  }

  void printDocument() async {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await AdminOverviewPdf.generate(
        week: _chartEndDate,
        endDate: _endDate ?? DateTime.now(),
        startDate: _startDate ?? DateTime.now(),
        baseCurrence: baseCurrency,
        statsProductModel: _adminController.statsPoducts.value,
        totalProducts: _adminController.totalProducts.value,
        statsSalesModel: _adminController.statsSales.value,
        thisMonthSummary: _adminController.thisMonthSummary.value,
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Admin_Overview_Report',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (_adminController.loading.value) {
        return MistLoader1().center();
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date Range Picker & Print ──
            Row(
              children: [
                Expanded(child: _buildDateRangePicker(primary)),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.print, color: Colors.white),
                    onPressed: printDocument,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── KPI Grid Product ──
            _buildSectionLabel('Product Overview'),
            const SizedBox(height: 12),
            _buildKpiGrid(context, [
              _KpiData(
                'Total Products',
                _adminController.totalProducts.value.toString(),
                Icons.inventory_2_outlined,
                const Color(0xFF6C63FF),
              ),
              _KpiData(
                'Items In Stock',
                _adminController.statsPoducts.value?.totalStock.toString() ??
                    '0',
                Icons.warehouse_outlined,
                const Color(0xFF3ECFCF),
              ),
              _KpiData(
                'Stock Value',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsPoducts.value?.totalCost ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.attach_money,
                const Color(0xFF00C896),
              ),
              _KpiData(
                'Proj. Revenue',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsPoducts.value?.totalRevenue ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.trending_up,
                const Color(0xFFFF7043),
              ),
            ]),
            const SizedBox(height: 24),

            // ── KPI Grid Sales ──
            _buildSectionLabel('Sales & Revenue Overview'),
            const SizedBox(height: 12),
            _buildKpiGrid(context, [
              _KpiData(
                'Total Sales',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalSales ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.point_of_sale_outlined,
                const Color(0xFF00C896),
              ),
              _KpiData(
                'Gross Profit',
                CurrenceConverter.getCurrenceFloatInStrings(
                  (_adminController.statsSales.value?.totalSales ?? 0) -
                      (_adminController.statsSales.value?.totalCost ?? 0),
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.account_balance_wallet_outlined,
                const Color(0xFF42A5F5),
              ),
              _KpiData(
                'Net Profit',
                CurrenceConverter.getCurrenceFloatInStrings(
                  ((_adminController.statsSales.value?.totalSales ?? 0) -
                          (_adminController.statsSales.value?.totalCost ?? 0)) -
                      (_adminController.statsSales.value?.totalExpenses ?? 0),
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.savings_outlined,
                const Color(0xFF6C63FF),
              ),
              _KpiData(
                'Expenses',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalExpenses ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.money_off_outlined,
                const Color(0xFFFF4D6A),
              ),
              _KpiData(
                'Taxes',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalTaxs ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.gavel_outlined,
                const Color(0xFFFFA726),
              ),
              _KpiData(
                'Losses',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalLossValue ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.trending_down,
                const Color(0xFFE53935),
              ),
              _KpiData(
                'Refunds',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalRefunds ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.assignment_return_outlined,
                const Color(0xFFEC407A),
              ),
              _KpiData(
                'Discounts',
                CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalDiscounts ?? 0,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                Icons.local_offer_outlined,
                const Color(0xFFAB47BC),
              ),
              _KpiData(
                'Cashiers',
                (_adminController.statsSales.value?.numberOfCashiers ?? 0)
                    .toString(),
                Icons.people_outline,
                const Color(0xFF5C6BC0),
              ),
            ]),
            const SizedBox(height: 24),
            _buildOverviewPieChart(context, primary),
            const SizedBox(height: 24),
            Obx(() {
              if (_adminController.thisMonthSummary.value != null) {
                return Column(
                  children: [
                    _buildThisMonthSummaryCard(context),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // ── Goals & Tasks Section ──
            _buildSectionLabel('Goals & Tasks'),
            const SizedBox(height: 12),
            _buildGoalsTasksSummaryCard(context, primary),
            const SizedBox(height: 24),

            // ── Charts Section ──
            _buildChartHeader(context, primary),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Profit',
              _buildProfitChart(context, const Color(0xFF6C63FF)),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Expenses',
              _buildExpensesChart(context, const Color(0xFFFF4D6A)),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Revenue',
              _buildSalesChart(context, const Color(0xFF00C896)),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Visitors',
              _buildVisitorsChart(context, const Color(0xFF3ECFCF)),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Receipts',
              _buildReceiptsChart(context, const Color(0xFFFFA726)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  // ── Date Range Picker ──────────────────────────────────────
  Widget _buildDateRangePicker(Color primary) {
    return GestureDetector(
      onTap: _showPrimaryDateRangePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withAlpha(40)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(
              _startDate == null
                  ? 'All Time Data'
                  : '${MistDateUtils.getInformalShortDate(_startDate!)}  —  ${MistDateUtils.getInformalShortDate(_endDate ?? DateTime.now())}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ── KPI Grid ───────────────────────────────────────────────
  Widget _buildKpiGrid(BuildContext context, List<_KpiData> items) {
    return LayoutBuilder(
      builder: (ctx, c) {
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
      },
    );
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
          BoxShadow(
            color: d.color.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                d.label,
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Chart Header & Tabs ────────────────────────────────────
  Widget _buildChartHeader(BuildContext context, Color primary) {
    return Row(
      children: [
        _buildSectionLabel('Analytics'),
        const Spacer(),
        // Period selector pills
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
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
        _reload();
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

  // ── Charts ─────────────────────────────────────────────────
  Widget _buildProfitChart(BuildContext context, Color primary) {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }
      if (list.isEmpty) {
        return _emptyChart('No profit data yet', Icons.bar_chart_rounded);
      }
      final textColor =
          Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
      final currency = _userController.user.value?.baseCurrence ?? '';
      return SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            clipData: const FlClipData.all(),
            minY: list.fold<double>(
              0.0,
              (prev, e) => e.totalProfit < prev ? e.totalProfit : prev,
            ),
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
                              text: CurrenceConverter.getCurrenceFloatk(
                                spot.y,
                                currency,
                              ),
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
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: textColor.withAlpha(80)),
              ),
            ),
            titlesData: _buildTitles(
              textColor,
              list.map((e) => _formatChartXAxis(e.date)).toList(),
              currency,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: list.indexed
                    .map((e) => FlSpot(e.$1.toDouble(), e.$2.totalProfit))
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

  Widget _buildSalesChart(BuildContext context, Color primary) {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }

      if (list.isEmpty) {
        return _emptyChart('No revenue data yet', Icons.show_chart_rounded);
      }
      final textColor =
          Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
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
                              text: CurrenceConverter.getCurrenceFloatk(
                                spot.y,
                                currency,
                              ),
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
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: textColor.withAlpha(80)),
              ),
            ),
            titlesData: _buildTitles(
              textColor,
              list.map((e) => _formatChartXAxis(e.date)).toList(),
              currency,
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

  Widget _buildVisitorsChart(BuildContext context, Color primary) {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value)
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      if (list.isEmpty)
        return _emptyChart('No visitor data yet', Icons.analytics_rounded);
      final textColor =
          Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
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
                              text: '${spot.y.toInt()} visitors',
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
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: textColor.withAlpha(80)),
              ),
            ),
            titlesData: _buildTitlesCount(
              textColor,
              list.map((e) => _formatChartXAxis(e.date)).toList(),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: list.indexed
                    .map(
                      (e) => FlSpot(
                        e.$1.toDouble(),
                        e.$2.uniqueCustomersCount.toDouble(),
                      ),
                    )
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

  Widget _buildReceiptsChart(BuildContext context, Color primary) {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value)
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      if (list.isEmpty)
        return _emptyChart('No receipt data yet', Icons.receipt_long);
      final textColor =
          Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
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
                              text: '${spot.y.toInt()} receipts',
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
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: textColor.withAlpha(80)),
              ),
            ),
            titlesData: _buildTitlesCount(
              textColor,
              list.map((e) => _formatChartXAxis(e.date)).toList(),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: list.indexed
                    .map(
                      (e) => FlSpot(
                        e.$1.toDouble(),
                        e.$2.receiptsCount.toDouble(),
                      ),
                    )
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

  // ── Shared Helpers ─────────────────────────────────────────
  FlTitlesData _buildTitles(
    Color textColor,
    List<String> labels,
    String currency,
  ) {
    return FlTitlesData(
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
            if (i < 0 || i >= labels.length) return const SizedBox.shrink();
            return Transform.rotate(
              angle: -0.6,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 9,
                    color: textColor.withAlpha(160),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesCount(Color textColor, List<String> labels) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 36,
          getTitlesWidget: (v, _) {
            if (v % 1 != 0) return const SizedBox.shrink();
            return Text(
              v.toInt().toString(),
              style: TextStyle(fontSize: 9, color: textColor.withAlpha(160)),
            );
          },
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
            if (i < 0 || i >= labels.length) return const SizedBox.shrink();
            return Transform.rotate(
              angle: -0.6,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 9,
                    color: textColor.withAlpha(160),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _emptyChart(String msg, IconData icon) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.grey.withAlpha(120)),
            const SizedBox(height: 8),
            Text(
              msg,
              style: TextStyle(color: Colors.grey.withAlpha(160), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewPieChart(BuildContext context, Color primary) {
    return Obx(() {
      if (_adminController.loading.value) {
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }
      
      final sales = _adminController.statsSales.value;
      if (sales == null || sales.totalSales == 0) {
        return _emptyChart('No sales data for pie chart', Icons.pie_chart_outline);
      }
      
      final totalSales = sales.totalSales;
      final costs = sales.totalCost;
      final expenses = sales.totalExpenses;
      final taxes = sales.totalTaxs;
      final netProfit = totalSales - costs - expenses - taxes;

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
            const Text(
              'Financial Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
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
                            PieChartSectionData(color: const Color(0xFFFFA726), value: costs, title: '${(costs/totalSales*100).toStringAsFixed(1)}%', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          if (expenses > 0)
                            PieChartSectionData(color: const Color(0xFFFF4D6A), value: expenses, title: '${(expenses/totalSales*100).toStringAsFixed(1)}%', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          if (taxes > 0)
                            PieChartSectionData(color: const Color(0xFFAB47BC), value: taxes, title: '${(taxes/totalSales*100).toStringAsFixed(1)}%', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          if (netProfit > 0)
                            PieChartSectionData(color: const Color(0xFF00C896), value: netProfit, title: '${(netProfit/totalSales*100).toStringAsFixed(1)}%', radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
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
                      _buildIndicator(const Color(0xFFAB47BC), 'Taxes'),
                      const SizedBox(height: 4),
                      _buildIndicator(const Color(0xFF00C896), 'Net Profit'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color)),
      ],
    );
  }

  Widget _buildExpensesChart(BuildContext context, Color primary) {
    return Obx(() {
      final list = _adminController.weeklyProfits;
      if (_adminController.loadingWeeklyProfits.value) {
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }
      if (list.isEmpty) {
        return _emptyChart('No expense data yet', Icons.show_chart_rounded);
      }
      final textColor =
          Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
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
                              text: CurrenceConverter.getCurrenceFloatk(
                                spot.y,
                                currency,
                              ),
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
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: textColor.withAlpha(80)),
              ),
            ),
            titlesData: _buildTitles(
              textColor,
              list.map((e) => _formatChartXAxis(e.date)).toList(),
              currency,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: list.indexed
                    .map((e) => FlSpot(e.$1.toDouble(), e.$2.totalExpenses))
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

  Widget _buildThisMonthSummaryCard(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final summary = _adminController.thisMonthSummary.value;
    if (summary == null) return const SizedBox();

    return Card(
      elevation: 0,
      color: AppTheme.surface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.calendar_month_outlined, color: primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This Month Summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // KPI List
            Column(
              children: [
                _buildListKpi('Revenue', CurrenceConverter.getCurrenceFloatInStrings(summary.totalRevenue, _userController.user.value?.baseCurrence ?? ''), const Color(0xFF00C896), theme),
                _buildListKpi('Gross Profit', CurrenceConverter.getCurrenceFloatInStrings(summary.grossProfit, _userController.user.value?.baseCurrence ?? ''), const Color(0xFF42A5F5), theme),
                _buildListKpi('Net Profit', CurrenceConverter.getCurrenceFloatInStrings(summary.netProfit, _userController.user.value?.baseCurrence ?? ''), const Color(0xFF6C63FF), theme),
                _buildListKpi('Expenses', CurrenceConverter.getCurrenceFloatInStrings(summary.totalExpenses, _userController.user.value?.baseCurrence ?? ''), const Color(0xFFFF4D6A), theme),
                _buildListKpi('Receipts', summary.totalReceipts.toString(), const Color(0xFFFFA726), theme),
                _buildListKpi('Items Sold', summary.totalItemsSold.toStringAsFixed(0), const Color(0xFF3ECFCF), theme),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peak Sales Time',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              summary.peakSalesRange,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top 5 Days (Revenue)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...summary.bestDays.map((day) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  day.date,
                                  style: theme.textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${day.receitsCount} receipts',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    CurrenceConverter.getCurrenceFloatInStrings(day.salesAmount, _userController.user.value?.baseCurrence ?? ''),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00C896),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListKpi(String title, String value, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Date Pickers ───────────────────────────────────────────
  Future<void> _showPrimaryDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate ?? DateTime.now())
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _adminController.getAdminStats(
        startDate: picked.start,
        endDate: picked.end,
      );
    }
  }

  Widget _buildGoalsTasksSummaryCard(BuildContext context, Color primary) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final tasks = _goalsTasksController.goalsTasks;
      final total = tasks.length;
      final completed = tasks.where((t) => t.isCompleted).length;
      final remaining = total - completed;

      return InkWell(
        onTap: () => Get.to(() => const ScreenGoalsTasks()),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2E2E3E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withAlpha(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.track_changes, color: primary, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Company Goals & Tasks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniStat('All Tasks', total.toString(), Colors.blue),
                        _buildMiniStat('Completed', completed.toString(), Colors.green),
                        _buildMiniStat('Remaining', remaining.toString(), Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios, color: primary, size: 16),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _KpiData {
  final String label, value;
  final IconData icon;
  final Color color;
  const _KpiData(this.label, this.value, this.icon, this.color);
}
