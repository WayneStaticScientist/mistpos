import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/multishop_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/data/models/multishop_gigantic_model.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_gigantic_overview.dart';
import 'package:printing/printing.dart';

class NavMultiShopGigantic extends StatefulWidget {
  const NavMultiShopGigantic({super.key});

  @override
  State<NavMultiShopGigantic> createState() => _NavMultiShopGiganticState();
}

class _NavMultiShopGiganticState extends State<NavMultiShopGigantic> {
  final _userController = Get.find<UserController>();
  late final MultiShopController _multiShopController;

  DateTime? _startDate;
  DateTime _endDate = DateTime.now();
  String _period = 'daily'; // daily, monthly, yearly

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<MultiShopController>()) {
      _multiShopController = Get.put(MultiShopController());
    } else {
      _multiShopController = Get.find<MultiShopController>();
    }
    _reloadGigantic();
  }

  void _reloadGigantic() {
    _multiShopController.fetchGiganticOverview(startDate: _startDate, endDate: _endDate, period: _period);
  }

  Future<void> _showDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate)
          : DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 7)),
              end: DateTime.now(),
            ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _reloadGigantic();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (_multiShopController.loadingGigantic.value) {
        return MistLoader1().center();
      }

      final data = _multiShopController.giganticOverview.value;
      if (data == null) {
        return const Center(child: Text("No data available"));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showDateRangePicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 18, color: primary),
                          const SizedBox(width: 10),
                          Text(
                            _startDate == null
                                ? 'All Time'
                                : '${MistDateUtils.getInformalShortDate(_startDate!)}  —  ${MistDateUtils.getInformalShortDate(_endDate)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionLabel('Enterprise Totals'),
            const SizedBox(height: 12),
            _buildTotalsCards(context, data.totals),
            const SizedBox(height: 24),

            _buildSectionLabel('Company Rankings (Weighted)'),
            const SizedBox(height: 12),
            _buildCompanyRankings(context, data.companyRankings),
            const SizedBox(height: 24),

            _buildSectionLabel('Enterprise Metrics Composition'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildPieChartCard(context, 'Revenues', data.companyRankings.map((e) => PieChartSectionData(value: e.revenue, title: e.companyName, radius: 50, color: _getColorForString(e.companyName))).toList()),
                _buildPieChartCard(context, 'Profits', data.companyRankings.map((e) => PieChartSectionData(value: e.profit, title: e.companyName, radius: 50, color: _getColorForString(e.companyName))).toList()),
                _buildPieChartCard(context, 'Total Shifts', data.companyShifts.map((e) => PieChartSectionData(value: e.shifts.toDouble(), title: e.companyName, radius: 50, color: _getColorForString(e.companyName))).toList()),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildSectionLabel('Consolidated Enterprise Trends')),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withAlpha(40)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _period,
                      items: const [
                        DropdownMenuItem(value: 'daily', child: Text('Daily')),
                        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                        DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _period = val;
                          });
                          _multiShopController.fetchGiganticGraphs(endDate: _endDate, period: _period);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () async {
                    if (data == null) return;
                    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
                    final pdfDoc = await GiganticOverviewPdf.generate(
                      startDate: _startDate,
                      endDate: _endDate,
                      baseCurrence: baseCurrence,
                      data: data,
                    );
                    await Printing.layoutPdf(onLayout: (format) async => pdfDoc.save());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primary.withAlpha(50)),
                    ),
                    child: Icon(Icons.print_outlined, size: 20, color: primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_multiShopController.loadingGiganticGraphs.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: MistLoader1(),
              )
            else
              _buildChartCard(
                context,
                'Revenue, Profit, Expenses, and Receipts',
                _buildMultilineChart(context, data.graphData),
              ),
            const SizedBox(height: 24),

            _buildSectionLabel('All Employees Performance'),
            const SizedBox(height: 16),
            _buildEmployeesList(context, data.employees),
          ],
        ),
      );
    });
  }

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
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsCards(BuildContext context, GiganticTotals totals) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    final items = [
      {'label': 'Revenue', 'value': CurrenceConverter.getCurrenceFloatInStrings(totals.revenue, currency), 'icon': Icons.point_of_sale, 'color': const Color(0xFF00C896)},
      {'label': 'Gross Profit', 'value': CurrenceConverter.getCurrenceFloatInStrings(totals.grossProfit, currency), 'icon': Icons.account_balance_wallet, 'color': const Color(0xFF42A5F5)},
      {'label': 'Net Profit', 'value': CurrenceConverter.getCurrenceFloatInStrings(totals.netProfit, currency), 'icon': Icons.savings, 'color': const Color(0xFF6C63FF)},
      {'label': 'Expenses', 'value': CurrenceConverter.getCurrenceFloatInStrings(totals.expenses, currency), 'icon': Icons.money_off, 'color': const Color(0xFFFF4D6A)},
      {'label': 'Taxes', 'value': CurrenceConverter.getCurrenceFloatInStrings(totals.taxes, currency), 'icon': Icons.request_quote, 'color': Colors.amber},
      {'label': 'Discounts', 'value': CurrenceConverter.getCurrenceFloatInStrings(totals.discounts, currency), 'icon': Icons.loyalty, 'color': Colors.deepOrange},
      {'label': 'Receipts', 'value': totals.receipts.toString(), 'icon': Icons.receipt, 'color': Colors.teal},
      {'label': 'Employees', 'value': totals.cashiersCount.toString(), 'icon': Icons.people, 'color': Colors.indigo},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2; // 12 is the spacing
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return Container(
              width: itemWidth,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withAlpha(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                  const SizedBox(height: 12),
                  Text(item['label'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(item['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            );
          }).toList(),
        );
      }
    );
  }

  Widget _buildCompanyRankings(BuildContext context, List<CompanyRanking> rankings) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    return Column(
      children: rankings.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final company = entry.value;
        Color rankColor;
        if (rank == 1) rankColor = Colors.amber;
        else if (rank == 2) rankColor = Colors.grey.shade400;
        else if (rank == 3) rankColor = Colors.brown.shade300;
        else rankColor = Colors.blueGrey;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withAlpha(30)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: rankColor.withAlpha(40), child: Text('#$rank', style: TextStyle(color: rankColor, fontWeight: FontWeight.bold))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Score: ${CurrenceConverter.getCurrenceFloatk(company.score, currency)}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rev: ${CurrenceConverter.getCurrenceFloatk(company.revenue, currency)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.green)),
                  Text('Prof: ${CurrenceConverter.getCurrenceFloatk(company.profit, currency)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.blue)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForString(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final c = (hash & 0x00FFFFFF).toRadixString(16).padLeft(6, '0');
    return Color(int.parse('0xFF$c'));
  }

  Widget _buildPieChartCard(BuildContext context, String title, List<PieChartSectionData> sections) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: sections.isEmpty ? const Center(child: Text("No data")) : PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: sections.map((s) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, color: s.color),
                const SizedBox(width: 4),
                Text(s.title, style: const TextStyle(fontSize: 10)),
              ],
            )).toList(),
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
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          chart,
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              _legendItem('Revenue', Colors.green),
              _legendItem('Profit', Colors.blue),
              _legendItem('Expenses', Colors.red),
              _legendItem('Receipts', Colors.orange),
            ],
          )
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMultilineChart(BuildContext context, List<GiganticGraphPoint> data) {
    if (data.isEmpty) return const SizedBox(height: 220, child: Center(child: Text("No data available")));

    final currency = _userController.user.value?.baseCurrence ?? '';
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    final revSpots = data.map((d) => FlSpot(d.timeKey.toDouble(), d.revenue)).toList();
    final profSpots = data.map((d) => FlSpot(d.timeKey.toDouble(), d.profits)).toList();
    final expSpots = data.map((d) => FlSpot(d.timeKey.toDouble(), d.expenses)).toList();
    final recSpots = data.map((d) => FlSpot(d.timeKey.toDouble(), d.receipts.toDouble())).toList();

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          clipData: const FlClipData.all(),
          minY: 0,
          lineBarsData: [
            LineChartBarData(spots: revSpots, color: Colors.green, isCurved: true, dotData: FlDotData(show: false)),
            LineChartBarData(spots: profSpots, color: Colors.blue, isCurved: true, dotData: FlDotData(show: false)),
            LineChartBarData(spots: expSpots, color: Colors.red, isCurved: true, dotData: FlDotData(show: false)),
            LineChartBarData(spots: recSpots, color: Colors.orange, isCurved: true, dotData: FlDotData(show: false)),
          ],
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: textColor.withAlpha(25), strokeWidth: 1)),
          borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: textColor.withAlpha(80)))),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (val, meta) => Padding(padding: const EdgeInsets.only(right: 8), child: Text(CurrenceConverter.getCurrenceFloatk(val, currency), style: TextStyle(color: textColor.withAlpha(150), fontSize: 10), textAlign: TextAlign.right)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: _period == 'yearly' ? 1 : 5,
                getTitlesWidget: (val, meta) {
                  String label = '${val.toInt()}';
                  if (_period == 'yearly') {
                    final int i = val.toInt();
                    if (i >= 1 && i <= 12) {
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      label = months[i - 1];
                    } else {
                      return const SizedBox();
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(label, style: TextStyle(color: textColor.withAlpha(150), fontSize: 10)),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final valStr = CurrenceConverter.getCurrenceFloatk(spot.y, currency);
                  String lbl = '';
                  Color clr = Colors.black;
                  if (spot.barIndex == 0) { lbl = 'Revenue'; clr = Colors.green; }
                  if (spot.barIndex == 1) { lbl = 'Profit'; clr = Colors.blue; }
                  if (spot.barIndex == 2) { lbl = 'Expenses'; clr = Colors.red; }
                  if (spot.barIndex == 3) { lbl = 'Receipts'; clr = Colors.orange; }
                  return LineTooltipItem('$lbl: $valStr', TextStyle(color: clr, fontWeight: FontWeight.bold, fontSize: 11));
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeesList(BuildContext context, List<GiganticEmployee> employees) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    if (employees.isEmpty) return const Text("No employee data");

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(30)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employees.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final e = employees[index];
          return ListTile(
            leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(30), child: Text(e.name.substring(0, 1).toUpperCase())),
            title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${e.companyName} • Shifts: ${e.shifts} • Receipts: ${e.receipts}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Rev: ${CurrenceConverter.getCurrenceFloatk(e.revenue, currency)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                Text('Prof: ${CurrenceConverter.getCurrenceFloatk(e.profit, currency)}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
