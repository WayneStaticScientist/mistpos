import 'package:exui/exui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_expenses_analytics.dart';

class NavExpensesOverview extends StatefulWidget {
  const NavExpensesOverview({super.key});

  @override
  State<NavExpensesOverview> createState() => _NavExpensesOverviewState();
}

class _NavExpensesOverviewState extends State<NavExpensesOverview> {
  final AdminController _adminController = Get.find<AdminController>();
  final UserController _userController = Get.find<UserController>();

  String _trendPeriod = 'daily';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adminController.fetchExpensesOverview(period: _trendPeriod);
    });
  }

  void _loadTrend(String period) {
    setState(() {
      _trendPeriod = period;
    });
    _adminController.fetchExpensesOverview(period: period);
  }

  Future<void> _printReport() async {
    final data = _adminController.expensesOverview.value;
    if (data == null) {
      Get.snackbar('Error', 'No data available to print');
      return;
    }

    try {
      final pdf = await PdfExpensesAnalytics.generate(
        baseCurrence: _userController.user.value?.baseCurrence ?? 'USD',
        totals: data.totals,
        categories: data.categories,
        employees: data.employees,
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Expenses Analytics Report',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── SECTION 1: KPI CARDS ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader('Expense Highlights', Carbon.chart_line_smooth),
              ),
              IconButton(
                icon: const Icon(Icons.print, color: Colors.blue),
                tooltip: "Print Analytics Report",
                onPressed: _printReport,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildKpiSection(),

          const SizedBox(height: 40),

          // ── SECTION 2: TRENDS (LINE CHART) ──
          _buildSectionHeader('Expense Trends', Carbon.chart_line_data),
          const SizedBox(height: 16),
          _buildTrendSection(primary),

          const SizedBox(height: 40),

          // ── SECTION 3: CATEGORY & EMPLOYEE BREAKDOWN ──
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCategoryBreakdown(primary)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildEmployeeBreakdown(primary)),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryBreakdown(primary),
                  const SizedBox(height: 40),
                  _buildEmployeeBreakdown(primary),
                ],
              );
            },
          ),

          const SizedBox(height: 40),

          // ── SECTION 4: PENDING EXPENSES ──
          _buildSectionHeader('Pending Approvals', Carbon.time),
          const SizedBox(height: 16),
          _buildPendingExpenses(primary),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String icon) {
    return Row(
      children: [
        Iconify(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiSection() {
    return Obx(() {
      if (_adminController.loadingExpensesOverview.value && _adminController.expensesOverview.value == null) {
        return const Center(child: MistLoader1());
      }
      final data = _adminController.expensesOverview.value?.totals;
      if (data == null) return const SizedBox();

      final currency = _userController.user.value?.baseCurrence ?? 'USD';

      return LayoutBuilder(
        builder: (context, constraints) {
          int columns = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
          double aspect = constraints.maxWidth > 800 ? 1.5 : 2;

          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspect,
            children: [
              _buildKpiCard('Total All Time', data.totalAllTime, currency, Carbon.chart_evaluation, Colors.blue),
              _buildKpiCard('This Year', data.totalYear, currency, Carbon.calendar, Colors.purple),
              _buildKpiCard('This Month', data.totalMonth, currency, Carbon.event_schedule, Colors.orange),
              _buildKpiCard('Today', data.totalToday, currency, Carbon.time, Colors.green),
            ],
          );
        },
      );
    });
  }

  Widget _buildKpiCard(String title, double amount, String currency, String icon, Color color) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E2D)
        : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withAlpha(50), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Iconify(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: textColor.withAlpha(150),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            CurrenceConverter.getCurrenceFloatk(amount, currency),
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendSection(Color primary) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E2D)
        : Colors.white;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    _buildPill('Daily', 'daily', _trendPeriod, _loadTrend, primary),
                    _buildPill('Monthly', 'monthly', _trendPeriod, _loadTrend, primary),
                    _buildPill('Yearly', 'yearly', _trendPeriod, _loadTrend, primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (_adminController.loadingExpensesOverview.value) {
              return const SizedBox(
                height: 250,
                child: Center(child: MistLoader1()),
              );
            }
            final trend = _adminController.expensesOverview.value?.trend ?? [];
            if (trend.isEmpty) {
              return const SizedBox(
                height: 250,
                child: Center(child: Text("No trend data available.")),
              );
            }
            return _buildTrendChart(trend, primary);
          }),
        ],
      ),
    );
  }

  Widget _buildPill(String label, String value, String groupValue, Function(String) onSelect, Color primary) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withAlpha(150),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart(List<dynamic> list, Color primary) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final currency = _userController.user.value?.baseCurrence ?? 'USD';

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minX: _trendPeriod == 'daily' ? 1 : (_trendPeriod == 'monthly' ? 1 : null),
          maxX: _trendPeriod == 'daily' ? 31 : (_trendPeriod == 'monthly' ? 12 : null),
          clipData: const FlClipData.all(),
          minY: 0,
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final item = list.firstWhere(
                    (e) {
                      if (_trendPeriod == 'daily') {
                        final parts = e.date.split('/');
                        return (double.tryParse(parts.isNotEmpty ? parts[0] : '') ?? -1) == spot.x;
                      } else if (_trendPeriod == 'monthly') {
                        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                        return (months.indexOf(e.date) + 1).toDouble() == spot.x;
                      }
                      return double.tryParse(e.date) == spot.x;
                    },
                    orElse: () => list.first,
                  );
                  return LineTooltipItem(
                    '${item.date}\n',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: CurrenceConverter.getCurrenceFloatk(
                          item.amount,
                          currency,
                        ),
                        style: TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
                FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(bottom: BorderSide(color: textColor.withAlpha(80))),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: textColor.withAlpha(150), fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _trendPeriod == 'daily' ? 5 : 1,
                getTitlesWidget: (value, meta) {
                  String label = '';
                  if (_trendPeriod == 'daily') {
                    if (value == 1 || value.toInt() % 5 == 0) {
                      label = value.toInt().toString();
                    }
                  } else if (_trendPeriod == 'monthly') {
                    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                    int idx = value.toInt() - 1;
                    if (idx >= 0 && idx < 12) {
                      label = months[idx];
                    }
                  } else {
                    label = value.toInt().toString();
                  }

                  if (label.isEmpty) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      label,
                      style: TextStyle(color: textColor.withAlpha(150), fontSize: 10),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: list.map((e) {
                double x = 0;
                if (_trendPeriod == 'daily') {
                  final parts = e.date.split('/');
                  if (parts.isNotEmpty) x = double.tryParse(parts[0]) ?? 0;
                } else if (_trendPeriod == 'monthly') {
                  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                  x = (months.indexOf(e.date) + 1).toDouble();
                } else {
                  x = double.tryParse(e.date) ?? 0;
                }
                return FlSpot(x, e.amount);
              }).toList(),
              isCurved: true,
              color: primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: primary.withAlpha(25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Category Breakdown', Carbon.chart_pie),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E2D)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            if (_adminController.loadingExpensesOverview.value && _adminController.expensesOverview.value == null) {
              return const Center(child: MistLoader1());
            }
            final categories = _adminController.expensesOverview.value?.categories ?? [];
            if (categories.isEmpty) return const Center(child: Text("No category data."));

            final currency = _userController.user.value?.baseCurrence ?? 'USD';

            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: categories.asMap().entries.map((e) {
                        final cat = e.value;
                        final color = Colors.primaries[e.key % Colors.primaries.length];
                        return PieChartSectionData(
                          color: color,
                          value: cat.amount,
                          title: '${cat.percentage.toInt()}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final color = Colors.primaries[index % Colors.primaries.length];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cat.name,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Text(
                              CurrenceConverter.getCurrenceFloatk(cat.amount, currency),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: color.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: cat.percentage / 100,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmployeeBreakdown(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Employee Expense Tracking', Carbon.user_multiple),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E2D)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            if (_adminController.loadingExpensesOverview.value && _adminController.expensesOverview.value == null) {
              return const Center(child: MistLoader1());
            }
            final employees = _adminController.expensesOverview.value?.employees ?? [];
            if (employees.isEmpty) return const Center(child: Text("No employee data."));

            final currency = _userController.user.value?.baseCurrence ?? 'USD';

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employees.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final emp = employees[index];
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primary.withAlpha(30),
                      child: Text(
                        emp.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(color: primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: emp.percentage / 100,
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrenceConverter.getCurrenceFloatk(emp.amount, currency),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '${emp.percentage}%',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPendingExpenses(Color primary) {
    return Obx(() {
      if (_adminController.loadingExpensesOverview.value && _adminController.expensesOverview.value == null) {
        return const Center(child: MistLoader1());
      }
      final pending = _adminController.expensesOverview.value?.pendingExpenses ?? [];
      if (pending.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E2D)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withAlpha(50)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("All expenses approved!"),
            ],
          ),
        );
      }

      final currency = _userController.user.value?.baseCurrence ?? 'USD';

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E2D)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pending.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final exp = pending[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Iconify(Carbon.warning_alt, color: Colors.orange),
              ),
              title: Text(
                exp.expenseFor,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                'By ${exp.senderId is Map ? exp.senderId['fullName'] ?? 'Unknown' : 'Unknown'} • ${exp.paymentType}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  fontSize: 12,
                ),
              ),
              trailing: Text(
                CurrenceConverter.getCurrenceFloatk(exp.amount.toDouble(), currency),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.orange,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
