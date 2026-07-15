import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/shifts_stats_model.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_sales_by_shifts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/data/models/shifts_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/features/settings/screens/screen_shift_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class NavShiftsView extends StatefulWidget {
  const NavShiftsView({super.key});

  @override
  State<NavShiftsView> createState() => NavShiftsViewState();
}

class NavShiftsViewState extends State<NavShiftsView> {
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  final _refreshController = RefreshController();
  DateTime _startDate = DateTime(2020, 1, 1);
  DateTime _endDate = DateTime.now();
  bool _isAllTime = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    _adminController.getShifts(_startDate, _endDate);
    if (_isAllTime) {
      _adminController.loadAllShifts(page: 1);
    } else {
      _adminController.allShifts.clear();
      // Optionally filter raw shifts if backend supports date, or leave empty if date filter doesn't apply to raw shifts API
    }
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

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Colors.blue.shade600;

    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        _adminController.getShifts(_startDate, _endDate);
        await _adminController.loadAllShifts(page: 1);
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
      },
      onLoading: () async {
        if (_adminController.allShiftsPage.value <
            _adminController.allShiftsTotalPages.value) {
          await _adminController.loadAllShifts(
            page: _adminController.allShiftsPage.value + 1,
          );
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── HEADER ──
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              const Text(
                "Shift Analytics & Logs",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
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
                          Text(
                            _isAllTime
                                ? "All Time"
                                : "From ${MistDateUtils.getInformalShortDate(_startDate)} to ${(DateUtils.isSameDay(_endDate, DateTime.now()) ? "Today" : MistDateUtils.getInformalShortDate(_endDate))}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade500,
                          ),
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
            ],
          ),
          const SizedBox(height: 24),

          // ── ANALYTICS SECTION ──
          Obx(() {
            if (_adminController.loadingShifts.value) {
              return const SizedBox(
                height: 300,
                child: Center(child: MistLoader1()),
              );
            }
            if (_adminController.shiftsStats.isEmpty) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: Text(
                    "No shift data available.",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              );
            }

            final totalSales = _adminController.shiftsStats.fold(
              0.0,
              (prev, data) => prev + data.totalSales,
            );
            final totalHours = _adminController.shiftsStats.fold(
              0.0,
              (prev, data) => prev + data.totalShiftHours,
            );
            final longestShift = _adminController.shiftsStats.isEmpty
                ? 0.0
                : _adminController.shiftsStats
                      .map((e) => e.totalShiftHours)
                      .reduce(max);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI METRICS
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
                          "Total Shift Sales",
                          totalSales,
                          Colors.teal.shade500,
                          Icons.monetization_on,
                          isCurrency: true,
                        ),
                        _buildKpiCard(
                          "Total Shifts",
                          _adminController.allShiftsTotalItems.value.toDouble(),
                          Colors.orange.shade500,
                          Icons.access_time_filled,
                          isCurrency: false,
                        ),
                        _buildKpiCard(
                          "Longest Shift (Hrs)",
                          longestShift,
                          Colors.purple.shade400,
                          Icons.timer,
                          isCurrency: false,
                        ),
                        _buildKpiCard(
                          "Total Logged Hrs",
                          totalHours,
                          Colors.indigo.shade400,
                          Icons.access_time,
                          isCurrency: false,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // PIE CHARTS
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    if (constraints.maxWidth > 800) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildPieChartCard(
                              "Shift Hours by Employee",
                              false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPieChartCard(
                              "Sales by Employee",
                              true,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildPieChartCard("Shift Hours by Employee", false),
                        const SizedBox(height: 16),
                        _buildPieChartCard("Sales by Employee", true),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // DATA TABLE
                Text(
                  "Employee Shift Data",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  child: _makeTable(_adminController.shiftsStats),
                ),
              ],
            );
          }),

          const SizedBox(height: 40),

          // ── RAW SHIFT LOGS ──
          Text(
            "Raw Shift Logs",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (_adminController.allShifts.isEmpty &&
                _adminController.loadingAllShifts.value) {
              return const SizedBox(
                height: 100,
                child: Center(child: MistLoader1()),
              );
            }
            if (_adminController.allShifts.isEmpty &&
                !_adminController.loadingAllShifts.value) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    "No raw shift records found.",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _adminController.allShifts.length,
              itemBuilder: (context, index) {
                return _buildShiftCard(_adminController.allShifts[index]);
              },
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
    IconData icon, {
    bool isCurrency = true,
  }) {
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
              isCurrency
                  ? CurrenceConverter.getCurrenceFloatInStrings(
                      amount,
                      baseCurrence,
                    )
                  : (amount % 1 == 0
                        ? amount.toInt().toString()
                        : amount.toStringAsFixed(1)),
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

  Widget _buildPieChartCard(String title, bool isSales) {
    final list = _adminController.shiftsStats
        .where((e) => (isSales ? e.totalSales : e.totalShiftHours) > 0)
        .toList();
    list.sort(
      (a, b) => (isSales ? b.totalSales : b.totalShiftHours).compareTo(
        isSales ? a.totalSales : a.totalShiftHours,
      ),
    );

    final topData = list.take(5).toList();
    final otherTotal = list
        .skip(5)
        .fold(
          0.0,
          (prev, e) => prev + (isSales ? e.totalSales : e.totalShiftHours),
        );

    if (topData.isEmpty) {
      return const SizedBox.shrink();
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
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        for (int i = 0; i < topData.length; i++)
                          PieChartSectionData(
                            color: colors[i],
                            value: isSales
                                ? topData[i].totalSales
                                : topData[i].totalShiftHours,
                            title: '',
                            radius: 50,
                          ),
                        if (otherTotal > 0)
                          PieChartSectionData(
                            color: colors[5],
                            value: otherTotal,
                            title: '',
                            radius: 50,
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
                          _buildIndicator(colors[i], topData[i].userName),
                          const SizedBox(height: 8),
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _makeTable(RxList<ShiftsStatsModel> shifts) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    return Container(
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
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 20,
        minWidth: 700,
        headingRowColor: WidgetStateProperty.resolveWith(
          (states) => isDark ? Colors.black12 : Colors.grey.shade50,
        ),
        columns: [
          DataColumn2(
            label: Text(
              'Employee',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text(
              'Shift Hours',
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
          DataColumn2(
            label: Text(
              'Items Sold',
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
              'Avg Sales/Shift',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            size: ColumnSize.M,
            numeric: true,
          ),
        ],
        rows: shifts.map((e) {
          return DataRow(
            cells: <DataCell>[
              DataCell(
                Text(
                  e.userName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(Text(e.totalShiftHours.toStringAsFixed(1))),
              DataCell(
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.totalSales,
                    baseCurrence,
                  ),
                ),
              ),
              DataCell(Text(e.totalSalesQuantity.toString())),
              DataCell(
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.averageSalePerShift,
                    baseCurrence,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShiftCard(ShiftsModel model) {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    final bool isClosed = model.shiftIsClosed;

    return InkWell(
      onTap: () => Get.to(() => ScreenShiftView(shift: model)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Iconify(
                        isClosed ? Bx.lock : Bx.lock_open,
                        color: isClosed ? Colors.grey : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          model.shiftLabel.isNotEmpty
                              ? model.shiftLabel
                              : "Standard Shift",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isClosed
                        ? Colors.grey.withAlpha(30)
                        : Colors.green.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isClosed ? "CLOSED" : "ACTIVE",
                    style: TextStyle(
                      color: isClosed ? Colors.grey : Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.withAlpha(40), thickness: 1),
            const SizedBox(height: 12),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildShiftStat(
                  "Total Sales",
                  CurrenceConverter.getCurrenceFloatInStrings(
                    model.totalSales,
                    baseCurrency,
                  ),
                ),
                _buildShiftStat(
                  "Drawer Start",
                  CurrenceConverter.getCurrenceFloatInStrings(
                    model.cashDrawerStart,
                    baseCurrency,
                  ),
                ),
                if (isClosed)
                  _buildShiftStat(
                    "Drawer End",
                    CurrenceConverter.getCurrenceFloatInStrings(
                      model.cashDrawerEnd,
                      baseCurrency,
                    ),
                  ),
                _buildShiftStat("Items Sold", "${model.salesQuantity}"),
                _buildShiftStat("Customers", "${model.totalCustomers}"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "Opened: ${MistDateUtils.getInformalShortDate(model.openShiftTime)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (isClosed) ...[
                  const Spacer(),
                  const Icon(
                    Icons.access_time_filled,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Closed: ${MistDateUtils.getInformalShortDate(model.closeShiftTime)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void printDocument() async {
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await PdfSalesByShifts.generate(
        endDate: _endDate,
        startDate: _startDate,
        baseCurrence: baseCurrency,
        salesByShifts: _adminController.shiftsStats,
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Shift_Logs_Report',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }
}
