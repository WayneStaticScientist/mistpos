import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_multishop_overview.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/multishop_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';

class NavMultiShopOverview extends StatefulWidget {
  final String title;
  const NavMultiShopOverview({super.key, this.title = 'MultiShop Overview'});

  @override
  State<NavMultiShopOverview> createState() => _NavMultiShopOverviewState();
}

class _NavMultiShopOverviewState extends State<NavMultiShopOverview> {
  final _userController = Get.find<UserController>();
  late final MultiShopController _multiShopController;

  DateTime? _startDate;
  DateTime _endDate = DateTime.now();
  String _selectedPeriod = 'daily';

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<MultiShopController>()) {
      _multiShopController = Get.put(MultiShopController());
    } else {
      _multiShopController = Get.find<MultiShopController>();
    }
    _reloadAll();
  }

  void _reloadStats() {
    _multiShopController.fetchMultiShopData(
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void _reloadGraphs() {
    _multiShopController.fetchMultiShopGraphs(
      endDate: _endDate,
      period: _selectedPeriod,
    );
  }

  void _reloadAll() {
    _reloadStats();
    _reloadGraphs();
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
      _reloadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (_multiShopController.loadingStats.value && _multiShopController.loadingGraphs.value) {
        return MistLoader1().center();
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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
                            color: primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _startDate == null
                                ? 'All Time'
                                : '${MistDateUtils.getInformalShortDate(_startDate!)}  —  ${MistDateUtils.getInformalShortDate(_endDate)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    final pdf = await MultiShopOverviewPdf.generate(
                      startDate: _startDate,
                      endDate: _endDate,
                      baseCurrence: _userController.user.value?.baseCurrence ?? '',
                      multishopData: _multiShopController.multishopData.toList(),
                      multishopGraphs: _multiShopController.multishopGraphs.toList(),
                      period: _selectedPeriod,
                    );
                    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primary.withAlpha(50)),
                    ),
                    child: Icon(Icons.print_outlined, color: primary, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Compare Cards
            _buildSectionLabel('Comparative Overview'),
            const SizedBox(height: 12),
            _buildComparativeCards(context),

            const SizedBox(height: 24),
            _buildChartHeader(context, primary),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Comparative Revenue',
              _buildMultilineChart(context, 'totalPaid', true),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Comparative Net Profit',
              _buildMultilineChart(context, 'totalProfit', true),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Comparative Expenses',
              _buildMultilineChart(context, 'totalExpenses', true),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Comparative Number of Receipts',
              _buildMultilineChart(context, 'receiptsCount', false),
            ),
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

  Widget _buildComparativeCards(BuildContext context) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    final items = [
      {
        'label': 'Total Revenue',
        'icon': Icons.point_of_sale,
        'color': const Color(0xFF00C896),
        'getValue': (s) => s.stats.totalSales,
      },
      {
        'label': 'Gross Profit',
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFF42A5F5),
        'getValue': (s) => s.stats.totalSales - s.stats.totalCost,
      },
      {
        'label': 'Net Profit',
        'icon': Icons.savings,
        'color': const Color(0xFF6C63FF),
        'getValue': (s) =>
            (s.stats.totalSales - s.stats.totalCost) - s.stats.totalExpenses,
      },
      {
        'label': 'Expenses',
        'icon': Icons.money_off,
        'color': const Color(0xFFFF4D6A),
        'getValue': (s) => s.stats.totalExpenses,
      },
      {
        'label': 'Stock Quantity',
        'icon': Icons.inventory_2_outlined,
        'color': Colors.blueGrey,
        'getValue': (s) => s.stats.totalStock,
        'isCurrency': false,
      },
      {
        'label': 'Stock Value (Cost)',
        'icon': Icons.inventory,
        'color': Colors.teal,
        'getValue': (s) => s.stats.totalStockValue,
      },
      {
        'label': 'Stock Revenue',
        'icon': Icons.storefront,
        'color': Colors.indigo,
        'getValue': (s) => s.stats.totalStockRevenue,
      },
    ];

    final isWide = MediaQuery.of(context).size.width > 700;
    
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((item) {
        return Container(
          width: isWide ? (MediaQuery.of(context).size.width / 2) - 26 : double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Column(
                children: _multiShopController.multishopData.map((shop) {
                  final value = (item['getValue'] as Function)(shop);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shop.companyName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          (item['isCurrency'] ?? true) == true
                              ? CurrenceConverter.getCurrenceFloatInStrings(
                                  value,
                                  currency,
                                )
                              : value.toInt().toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChartHeader(BuildContext context, Color primary) {
    return Row(
      children: [
        _buildSectionLabel('Analytics'),
        const Spacer(),
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
          _endDate = DateTime.now();
        });
        _reloadGraphs();
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
          const SizedBox(height: 16),
          _buildChartLegend(),
        ],
      ),
    );
  }

  final List<Color> _chartColors = [
    Colors.blueAccent,
    Colors.orange,
    Colors.purpleAccent,
    Colors.green,
    Colors.redAccent,
    Colors.cyan,
  ];

  Widget _buildChartLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: _multiShopController.multishopGraphs.asMap().entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _chartColors[entry.key % _chartColors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(entry.value.companyName, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  String _formatDateLabel(String dateStr) {
    if (_selectedPeriod == 'daily') {
      return int.tryParse(dateStr)?.toString() ?? dateStr;
    } else if (_selectedPeriod == 'monthly') {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final mIndex = int.tryParse(dateStr);
      if (mIndex != null && mIndex >= 1 && mIndex <= 12) {
        return months[mIndex - 1];
      }
    }
    return dateStr;
  }

  Widget _buildMultilineChart(BuildContext context, String dataKey, bool isCurrency) {
    if (_multiShopController.multishopGraphs.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("No data available")),
      );
    }

    final currency = _userController.user.value?.baseCurrence ?? '';
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    // Collect all unique dates across all shops
    Set<String> uniqueDates = {};
    for (var shop in _multiShopController.multishopGraphs) {
      for (var point in shop.graphData) {
        if (point['date'] != null) {
          uniqueDates.add(point['date']);
        }
      }
    }
    List<String> allDates = uniqueDates.toList()..sort();

    final lineBarsData = _multiShopController.multishopGraphs.asMap().entries.map(
      (entry) {
        final index = entry.key;
        final shop = entry.value;
        final color = _chartColors[index % _chartColors.length];

        final spots = allDates.asMap().entries.map((dateEntry) {
          final i = dateEntry.key.toDouble();
          final dateStr = dateEntry.value;
          
          final point = shop.graphData.firstWhere(
            (p) => p['date'] == dateStr,
            orElse: () => <String, dynamic>{},
          );
          
          final value = point[dataKey] ?? 0.0;
          return FlSpot(i, value.toDouble());
        }).toList();

        return LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        );
      },
    ).toList();

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          clipData: const FlClipData.all(),
          minY: 0,
          lineBarsData: lineBarsData,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(bottom: BorderSide(color: textColor.withAlpha(80))),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (val, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      isCurrency ? CurrenceConverter.getCurrenceFloatk(val, currency) : val.toInt().toString(),
                      style: TextStyle(
                        color: textColor.withAlpha(150),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: _selectedPeriod == 'daily' ? 5 : 1,
                getTitlesWidget: (val, meta) {
                  final i = val.toInt();
                  if (allDates.isNotEmpty) {
                    if (i >= 0 && i < allDates.length) {
                      String dateStr = allDates[i];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _formatDateLabel(dateStr),
                          style: TextStyle(
                            color: textColor.withAlpha(150),
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchSpotThreshold: 40,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final i = spot.x.toInt();
                  String dateStr = "";
                  if (i >= 0 && i < allDates.length) {
                    dateStr = allDates[i];
                  }
                  final formattedDate = _formatDateLabel(dateStr);
                  final valStr = isCurrency 
                      ? CurrenceConverter.getCurrenceFloatk(spot.y, currency) 
                      : spot.y.toInt().toString();

                  final shopIndex = spot.barIndex;
                  final shopName = _multiShopController.multishopGraphs[shopIndex].companyName;
                  
                  return LineTooltipItem(
                    '$shopName\n',
                    TextStyle(color: _chartColors[shopIndex % _chartColors.length], fontWeight: FontWeight.bold, fontSize: 12),
                    children: [
                      TextSpan(
                        text: '$formattedDate: $valStr',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 11),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
