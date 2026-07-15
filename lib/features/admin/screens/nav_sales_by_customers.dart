import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/sales_by_customer_model.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_sales_by_customers.dart';
import 'package:mistpos/core/utils/toast.dart';

class NavSalesByCustomers extends StatefulWidget {
  const NavSalesByCustomers({super.key});

  @override
  State<NavSalesByCustomers> createState() => _NavSalesByCustomersState();
}

class _NavSalesByCustomersState extends State<NavSalesByCustomers> {
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();
  int _currentPage = 1;
  int _touchedPieIndex = -1;
  String _searchQuery = "";
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    _adminController.fetchSalesByCustomers(
      timeStart: _startDate,
      date: _endDate,
      page: _currentPage,
    );
  }

  void _printDocument() async {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    final data = _adminController.salesByCustomerData.value;
    if (data == null) {
      Toaster.showError("No data available to print");
      return;
    }
    try {
      final pdf = await SalesByCustomersPdf.generate(
        startDate: _startDate,
        endDate: _endDate,
        baseCurrency: baseCurrency,
        data: data,
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Sales_By_Customers_Report',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.indigo.shade600,
                  onPrimary: Colors.white,
                  surface: AppTheme.surface(context),
                ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _startDate = date.start;
        _endDate = date.end;
        _currentPage = 1;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.indigo.shade600;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER WITH GLASS PILL DATE PICKER ──
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Customer Sales",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.indigo.shade500, Colors.purple.shade500],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          "PRO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Monitor customer spend and identification metrics",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Elegant Date Range Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _changeDateRange,
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? Colors.white.withOpacity(0.04) 
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark 
                                ? Colors.white.withOpacity(0.08) 
                                : Colors.black.withOpacity(0.05),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Iconify(Bx.calendar, color: primaryColor, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              "From ${MistDateUtils.getInformalShortDate(_startDate)} to ${(DateUtils.isSameDay(_endDate, DateTime.now()) ? "Today" : MistDateUtils.getInformalShortDate(_endDate))}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.keyboard_arrow_down_rounded, 
                              color: isDark ? Colors.white38 : Colors.black38,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Print PDF Button
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.print, color: Colors.white, size: 20),
                      onPressed: _printDocument,
                      tooltip: "Print PDF Report",
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          Obx(() {
            if (_adminController.loadingSalesByCustomers.value && _adminController.salesByCustomerData.value == null) {
              return const SizedBox(
                height: 350,
                child: Center(child: MistLoader1()),
              );
            }
            final data = _adminController.salesByCustomerData.value;
            if (data == null) {
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.query_stats_rounded, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        "No customer sales data available for this range.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final totalSalesVal = data.totalCustomersSales + data.totalUncategorizedSales;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── KPI METRICS GRID ──
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Column(
                        children: [
                          _buildKpiCard(
                            "Registered Customers Sales",
                            data.totalCustomersSales,
                            Colors.indigo.shade500,
                            Icons.supervised_user_circle_sharp,
                            totalSalesVal,
                          ),
                          const SizedBox(height: 20),
                          _buildKpiCard(
                            "Uncategorized Sales",
                            data.totalUncategorizedSales,
                            Colors.amber.shade700,
                            Icons.no_accounts_rounded,
                            totalSalesVal,
                          ),
                        ],
                      );
                    }
                    final cols = constraints.maxWidth > 800 ? 2 : 1;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: cols,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: constraints.maxWidth > 800 ? 3.2 : 2.6,
                      children: [
                        _buildKpiCard(
                          "Registered Customers Sales",
                          data.totalCustomersSales,
                          Colors.indigo.shade500,
                          Icons.supervised_user_circle_sharp,
                          totalSalesVal,
                        ),
                        _buildKpiCard(
                          "Uncategorized Sales",
                          data.totalUncategorizedSales,
                          Colors.amber.shade700,
                          Icons.no_accounts_rounded,
                          totalSalesVal,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // ── SHARE RATIO INDICATOR BAR ──
                _buildShareRatioBar(data.totalCustomersSales, data.totalUncategorizedSales),
                const SizedBox(height: 36),

                // ── VISUAL ANALYTICS: DONUT & LEADERBOARD ──
                if (data.topCustomers.isNotEmpty) ...[
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      if (constraints.maxWidth > 900) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: _buildDonutChartCard(
                                "Customer Share Distribution", 
                                data.topCustomers, 
                                data.totalCustomersSales,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 5,
                              child: _buildLeaderboardCard("Top 10 Spenders", data.topCustomers, data.totalCustomersSales),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildDonutChartCard(
                              "Customer Share Distribution", 
                              data.topCustomers, 
                              data.totalCustomersSales,
                            ),
                            const SizedBox(height: 24),
                            _buildLeaderboardCard("Top 10 Spenders", data.topCustomers, data.totalCustomersSales),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 36),
                ],

                // ── DETAILED TABLE SECTION WITH LOCAL FILTERING ──
                _buildTableSection(data),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, double amount, Color themeColor, IconData icon, double grandTotal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    final sharePercent = grandTotal > 0 ? (amount / grandTotal) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: themeColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            CurrenceConverter.getCurrenceFloatInStrings(amount, baseCurrence),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 13,
                color: themeColor.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Text(
                "${sharePercent.toStringAsFixed(1)}% of total period revenue",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white30 : Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareRatioBar(double registered, double uncategorized) {
    final total = registered + uncategorized;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (total == 0) return const SizedBox.shrink();
    
    final regPercent = (registered / total) * 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Identification Penetration Ratio",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${regPercent.toStringAsFixed(0)}% Identified",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.indigo.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: (registered * 1000).toInt() + 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo.shade500, Colors.indigo.shade300],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (uncategorized * 1000).toInt() + 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade500, Colors.amber.shade700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard(String title, List<CustomerSalesData> topData, double totalCustomersSales) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    
    final colors = [
      Colors.indigo.shade500,
      Colors.purple.shade500,
      Colors.cyan.shade500,
      Colors.green.shade500,
      Colors.teal.shade500,
      Colors.pink.shade500,
      Colors.orange.shade500,
      Colors.amber.shade500,
      Colors.blue.shade500,
      Colors.purple.shade400,
    ];

    return Container(
      height: 360,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedPieIndex = -1;
                            return;
                          }
                          _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 4,
                    centerSpaceRadius: 75,
                    sections: List.generate(topData.length, (i) {
                      final isTouched = i == _touchedPieIndex;
                      final double radius = isTouched ? 45.0 : 35.0;
                      return PieChartSectionData(
                        color: colors[i % colors.length],
                        value: topData[i].totalPaid,
                        title: '',
                        radius: radius,
                        badgeWidget: isTouched 
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${((topData[i].totalPaid / totalCustomersSales) * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                        badgePositionPercentageOffset: 0.9,
                      );
                    }),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Top 10 Spent",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white30 : Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrenceConverter.getCurrenceFloatInStrings(
                        topData.fold(0.0, (prev, curr) => prev + curr.totalPaid), 
                        baseCurrence
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "of ${topData.length} customers",
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white30 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(String title, List<CustomerSalesData> topData, double totalCustomersSales) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    
    final colors = [
      Colors.indigo.shade500,
      Colors.purple.shade500,
      Colors.cyan.shade500,
      Colors.green.shade500,
      Colors.teal.shade500,
      Colors.pink.shade500,
      Colors.orange.shade500,
      Colors.amber.shade500,
      Colors.blue.shade500,
      Colors.purple.shade400,
    ];

    return Container(
      height: 360,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: topData.length,
              itemBuilder: (context, index) {
                final customer = topData[index];
                final shareVal = totalCustomersSales > 0 ? (customer.totalPaid / totalCustomersSales) : 0.0;
                final initials = customer.customerName.isNotEmpty 
                    ? customer.customerName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
                    : "?";
                
                Widget rankWidget;
                if (index == 0) {
                  rankWidget = _buildRankIndicator(Colors.amber.shade600, "1");
                } else if (index == 1) {
                  rankWidget = _buildRankIndicator(Colors.grey.shade400, "2");
                } else if (index == 2) {
                  rankWidget = _buildRankIndicator(Colors.brown.shade400, "3");
                } else {
                  rankWidget = Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white30 : Colors.black38,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Center(child: rankWidget),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colors[index % colors.length].withOpacity(0.12),
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: colors[index % colors.length],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.customerName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: shareVal.clamp(0.0, 1.0),
                                minHeight: 4,
                                backgroundColor: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
                                valueColor: AlwaysStoppedAnimation(colors[index % colors.length]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrenceConverter.getCurrenceFloatInStrings(customer.totalPaid, baseCurrence),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${customer.receiptCount} receipts",
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? Colors.white30 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankIndicator(Color color, String text) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTableSection(SalesByCustomerModel data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final listFiltered = data.list.where((element) {
      return element.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer Transactions Registry",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (_adminController.loadingSalesByCustomers.value)
              const SizedBox(
                width: 18, 
                height: 18, 
                child: CircularProgressIndicator(strokeWidth: 2)
              ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.06),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: isDark ? Colors.white30 : Colors.black38, size: 20),
                    hintText: "Search customer name...",
                    hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black38, fontSize: 13.5),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 480,
          child: _makeTable(listFiltered),
        ),
        const SizedBox(height: 16),

        if (data.totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Page $_currentPage of ${data.totalPages}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white30 : Colors.black45,
                ),
              ),
              const SizedBox(width: 12),
              _buildPaginationButton(
                icon: Icons.chevron_left_rounded,
                onPressed: _currentPage > 1
                    ? () {
                        setState(() => _currentPage--);
                        _loadData();
                      }
                    : null,
              ),
              const SizedBox(width: 8),
              _buildPaginationButton(
                icon: Icons.chevron_right_rounded,
                onPressed: _currentPage < data.totalPages
                    ? () {
                        setState(() => _currentPage++);
                        _loadData();
                      }
                    : null,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPaginationButton({required IconData icon, VoidCallback? onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: disabled
                ? Colors.transparent
                : (isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: disabled
                  ? Colors.transparent
                  : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: disabled
                ? (isDark ? Colors.white12 : Colors.black12)
                : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _makeTable(List<CustomerSalesData> list) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 44, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              "No customer records found matching search query.", 
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final colors = [
      Colors.indigo.shade500,
      Colors.purple.shade500,
      Colors.cyan.shade500,
      Colors.green.shade500,
      Colors.teal.shade500,
      Colors.pink.shade500,
      Colors.orange.shade500,
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final initials = item.customerName.isNotEmpty 
            ? item.customerName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
            : "?";
        final color = colors[index % colors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.15 : 0.02),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.12),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_rounded, size: 12, color: isDark ? Colors.white38 : Colors.black38),
                              const SizedBox(width: 4),
                              Text(
                                "${item.receiptCount} receipts",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 12, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                "Paid: ${CurrenceConverter.getCurrenceFloatInStrings(item.totalPaid, baseCurrence)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.currentCredit > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade500.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade400.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 13, color: Colors.red.shade600),
                          const SizedBox(width: 4),
                          Text(
                            "Credit: ${CurrenceConverter.getCurrenceFloatInStrings(item.currentCredit, baseCurrence)}",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.red.shade600,
								),
							  ),
							],
						  ),
						),
					  ] else ...[
						Container(
						  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
						  decoration: BoxDecoration(
							color: isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade50,
							borderRadius: BorderRadius.circular(10),
							border: Border.all(
							  color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade200,
							),
						  ),
						  child: Row(
							mainAxisSize: MainAxisSize.min,
							children: [
							  Icon(Icons.shield_outlined, size: 13, color: isDark ? Colors.white30 : Colors.black38),
							  const SizedBox(width: 4),
							  Text(
								"No Debt",
								style: TextStyle(
								  fontSize: 11.5,
								  fontWeight: FontWeight.w700,
								  color: isDark ? Colors.white30 : Colors.black45,
								),
							  ),
							],
						  ),
						),
					  ],
					],
				  ),
				],
			  ),
			);
		  },
		);
	  }
}
