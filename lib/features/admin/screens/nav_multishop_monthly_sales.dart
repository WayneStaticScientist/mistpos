import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/multishop_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_multishop_monthly_sales.dart';

class NavMultiShopMonthlySales extends StatefulWidget {
  final String title;
  const NavMultiShopMonthlySales({
    super.key,
    this.title = 'MultiShop Monthly Sales',
  });

  @override
  State<NavMultiShopMonthlySales> createState() =>
      _NavMultiShopMonthlySalesState();
}

class _NavMultiShopMonthlySalesState extends State<NavMultiShopMonthlySales> {
  final _userController = Get.find<UserController>();
  late final MultiShopController _multiShopController;

  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<MultiShopController>()) {
      _multiShopController = Get.put(MultiShopController());
    } else {
      _multiShopController = Get.find<MultiShopController>();
    }
    _reloadMonthlySales();
  }

  void _reloadMonthlySales() {
    _multiShopController.fetchMultiShopMonthlySales(date: _date);
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
      _reloadMonthlySales();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (_multiShopController.loadingMonthlySales.value) {
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
                    onTap: _showDatePicker,
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
                            '${['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][_date.month - 1]} ${_date.year}',
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
                    if (_multiShopController.multishopMonthlySales.isEmpty) {
                      Toaster.showError("No data to print");
                      return;
                    }
                    try {
                      final pdf = await MultiShopMonthlySalesPdf.generate(
                        date: _date,
                        baseCurrence:
                            _userController.user.value?.baseCurrence ?? '',
                        multishopData:
                            _multiShopController.multishopMonthlySales,
                      );
                      await Printing.layoutPdf(
                        onLayout: (format) async => pdf.save(),
                      );
                    } catch (e) {
                      Toaster.showError("Failed to generate PDF: $e");
                    }
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

            _buildSectionLabel('Comparative Overview'),
            const SizedBox(height: 12),
            _buildComparativeCards(context),

            const SizedBox(height: 24),

            _buildSectionLabel('Daily Analytics'),
            const SizedBox(height: 16),
            _buildChartCard(
              context,
              'Daily Revenue',
              _buildMultilineChart(context, 'revenue', true),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Daily Net Profit',
              _buildMultilineChart(context, 'profits', true),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Daily Expenses',
              _buildMultilineChart(context, 'expenses', true),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Daily Receipts',
              _buildMultilineChart(context, 'receipts', false),
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
        'getValue': (d) => (d.dailyData['totalSales'] ?? 0.0).toDouble(),
      },
      {
        'label': 'Gross Profit',
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFF42A5F5),
        'getValue': (d) => (d.dailyData['grossProfit'] ?? 0.0).toDouble(),
      },
      {
        'label': 'Net Profit',
        'icon': Icons.savings,
        'color': const Color(0xFF6C63FF),
        'getValue': (d) => (d.dailyData['netProfit'] ?? 0.0).toDouble(),
      },
      {
        'label': 'Expenses',
        'icon': Icons.money_off,
        'color': const Color(0xFFFF4D6A),
        'getValue': (d) => (d.dailyData['totalExpenses'] ?? 0.0).toDouble(),
      },
      {
        'label': 'Taxes',
        'icon': Icons.request_quote,
        'color': Colors.amber,
        'getValue': (d) => (d.dailyData['totalTaxs'] ?? 0.0).toDouble(),
      },
      {
        'label': 'Discounts',
        'icon': Icons.loyalty,
        'color': Colors.deepOrange,
        'getValue': (d) => (d.dailyData['totalDiscounts'] ?? 0.0).toDouble(),
      },
    ];

    final isWide = MediaQuery.of(context).size.width > 700;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((item) {
        return Container(
          width: isWide
              ? (MediaQuery.of(context).size.width / 2) - 26
              : double.infinity,
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
                children: _multiShopController.multishopMonthlySales.map((
                  shop,
                ) {
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
                          CurrenceConverter.getCurrenceFloatInStrings(
                            value,
                            currency,
                          ),
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
      children: _multiShopController.multishopMonthlySales.asMap().entries.map((
        entry,
      ) {
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

  String _formatdayLabel(int day) {
    return '$day';
  }

  Widget _buildMultilineChart(
    BuildContext context,
    String dataKey,
    bool isCurrency,
  ) {
    if (_multiShopController.multishopMonthlySales.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("No data available")),
      );
    }

    final currency = _userController.user.value?.baseCurrence ?? '';
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    // days from 1 to 31
    final daysInMonth = DateTime(_date.year, _date.month + 1, 0).day;
    List<int> alldays = List.generate(daysInMonth, (index) => index + 1);

    final lineBarsData = _multiShopController.multishopMonthlySales
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final shop = entry.value;
          final color = _chartColors[index % _chartColors.length];

          final List<dynamic> dailyDataList = shop.dailyData['dailyData'] ?? [];

          final spots = alldays.map((day) {
            final point = dailyDataList.firstWhere(
              (p) => p['day'] == day,
              orElse: () => <String, dynamic>{},
            );

            final value = point[dataKey] ?? 0.0;
            return FlSpot(day.toDouble(), value.toDouble());
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
        })
        .toList();

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
                      isCurrency
                          ? CurrenceConverter.getCurrenceFloatk(val, currency)
                          : val.toInt().toString(),
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
                interval: 5,
                getTitlesWidget: (val, meta) {
                  final i = val.toInt();
                  if (i >= 1 &&
                      i <= daysInMonth &&
                      (i % 5 == 0 || i == 1 || i == daysInMonth)) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _formatdayLabel(i),
                        style: TextStyle(
                          color: textColor.withAlpha(150),
                          fontSize: 10,
                        ),
                      ),
                    );
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
                  final formattedday = _formatdayLabel(i);
                  final valStr = isCurrency
                      ? CurrenceConverter.getCurrenceFloatk(spot.y, currency)
                      : spot.y.toInt().toString();

                  final shopIndex = spot.barIndex;
                  final shopName = _multiShopController
                      .multishopMonthlySales[shopIndex]
                      .companyName;

                  return LineTooltipItem(
                    '$shopName\n',
                    TextStyle(
                      color: _chartColors[shopIndex % _chartColors.length],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: '$formattedday: $valStr',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
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
