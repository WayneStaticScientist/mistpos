import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/data/models/yearly_report_model.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class NavYearlyReports extends StatefulWidget {
  const NavYearlyReports({super.key});
  @override
  State<NavYearlyReports> createState() => _NavYearlyReportsState();
}

class _NavYearlyReportsState extends State<NavYearlyReports> with SingleTickerProviderStateMixin {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _inventoryController = Get.find<InventoryController>();

  int _selectedYear = DateTime.now().year;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchReport() {
    _adminController.fetchYearlyReport(_selectedYear);
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

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (!_isProUser()) {
        return const SubscriptionAlert();
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildYearPicker(),
                if (_adminController.yearlyReport.value != null && !_adminController.loadingYearlyReport.value)
                  InkWell(
                    onTap: () => _printPdf(context, _adminController.yearlyReport.value!),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.print_outlined, color: primary, size: 18),
                          const SizedBox(width: 8),
                          const Text("Export PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            if (_adminController.loadingYearlyReport.value)
              MistLoader1().center()
            else if (_adminController.yearlyReportError.value.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "Error: ${_adminController.yearlyReportError.value}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (_adminController.yearlyReport.value == null)
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
              _buildSectionLabel('Yearly Financial Overview', primary),
              const SizedBox(height: 16),
              _buildKpiGrid(context, _adminController.yearlyReport.value!),
              
              const SizedBox(height: 32),
              _buildSectionLabel('Weighted Monthly Analysis', primary),
              const SizedBox(height: 16),
              _buildWeightedAnalysis(_adminController.yearlyReport.value!),

              const SizedBox(height: 32),
              _buildSectionLabel('Monthly Breakdown', primary),
              const SizedBox(height: 16),
              _buildMonthlyTable(_adminController.yearlyReport.value!),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildYearPicker() {
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 2019, (index) => currentYear - index);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedYear,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
          items: years.map((int year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Text("$year Report", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null && newValue != _selectedYear) {
              setState(() {
                _selectedYear = newValue;
              });
              _fetchReport();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color)),
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context, YearlyReportModel report) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    final s = report.summary;

    final items = [
      _KpiData('Total Revenue', CurrenceConverter.getCurrenceFloatInStrings(s.totalRevenue, currency), Icons.point_of_sale_outlined, const Color(0xFF00C896)),
      _KpiData('Gross Profit', CurrenceConverter.getCurrenceFloatInStrings(s.totalProfit + s.totalExpenses, currency), Icons.account_balance_wallet_outlined, const Color(0xFF3ECFCF)),
      _KpiData('Net Profit', CurrenceConverter.getCurrenceFloatInStrings(s.totalProfit, currency), Icons.trending_up, const Color(0xFF6C63FF)),
      _KpiData('Total Expenses', CurrenceConverter.getCurrenceFloatInStrings(s.totalExpenses, currency), Icons.receipt_long_outlined, const Color(0xFFFF4D6A)),
      _KpiData('Total Losses', CurrenceConverter.getCurrenceFloatInStrings(s.totalLosses, currency), Icons.warning_amber_rounded, const Color(0xFFE53935)),
      _KpiData('Items Sold', '${s.numberOfItemsSold}', Icons.inventory_2_outlined, const Color(0xFFFFA726)),
      _KpiData('Total Receipts', '${s.numberOfReceipts}', Icons.receipt_outlined, const Color(0xFFFFA726)),
      _KpiData('Total Refunds', CurrenceConverter.getCurrenceFloatInStrings(s.totalMoneyRefunded, currency), Icons.assignment_return_outlined, const Color(0xFFEC407A)),
      _KpiData('Refund Count', '${s.totalRefundsCount}', Icons.numbers, const Color(0xFFAB47BC)),
    ];

    return LayoutBuilder(
      builder: (ctx, c) {
        final cols = c.maxWidth > 700 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: items.map((d) => _buildKpiCard(d)).toList(),
        );
      },
    );
  }

  Widget _buildKpiCard(_KpiData d) {
    return Container(
      padding: const EdgeInsets.all(12),
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

  Widget _buildWeightedAnalysis(YearlyReportModel report) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Revenue"),
              Tab(text: "Profit"),
              Tab(text: "Expenses"),
            ],
            onTap: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 650,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildProgressBars(report, (m) => m.revenue, Colors.blue),
                _buildProgressBars(report, (m) => m.profit, Colors.green),
                _buildProgressBars(report, (m) => m.expenses, Colors.orange),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressBars(YearlyReportModel report, double Function(MonthlyData) selector, Color color) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    double maxVal = 0;
    for (var m in report.monthlyData) {
      final val = selector(m);
      if (val > maxVal) maxVal = val;
    }

    if (maxVal == 0) {
      return const Center(child: Text("No Data for this year."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (context, index) {
        final m = report.monthlyData[index];
        final val = selector(m);
        final percentage = (val / maxVal).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_getMonthName(m.month), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(CurrenceConverter.getCurrenceFloatk(val, currency), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(height: 6, decoration: BoxDecoration(color: Colors.grey.withAlpha(30), borderRadius: BorderRadius.circular(3))),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthlyTable(YearlyReportModel report) {
    final currency = _userController.user.value?.baseCurrence ?? '';

    return Container(
      height: 450,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 800,
        headingRowColor: WidgetStateProperty.all(Colors.grey.withAlpha(20)),
        columns: const [
          DataColumn2(label: Text('Month', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.L),
          DataColumn2(label: Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn2(label: Text('Gross Profit', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn2(label: Text('Net Profit', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn2(label: Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn2(label: Text('Losses', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn2(label: Text('Receipts', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn2(label: Text('Items Sold', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        ],
        rows: report.monthlyData.map((m) {
          return DataRow(cells: [
            DataCell(Text(_getMonthName(m.month), style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(CurrenceConverter.getCurrenceFloatk(m.revenue, currency), style: const TextStyle(color: Colors.blue))),
            DataCell(Text(CurrenceConverter.getCurrenceFloatk(m.profit + m.expenses, currency), style: const TextStyle(color: Colors.teal))),
            DataCell(Text(CurrenceConverter.getCurrenceFloatk(m.profit, currency), style: const TextStyle(color: Colors.green))),
            DataCell(Text(CurrenceConverter.getCurrenceFloatk(m.expenses, currency), style: const TextStyle(color: Colors.orange))),
            DataCell(Text(CurrenceConverter.getCurrenceFloatk(m.losses, currency), style: const TextStyle(color: Colors.red))),
            DataCell(Text('${m.receiptsCount}')),
            DataCell(Text('${m.itemsSold}')),
          ]);
        }).toList(),
      ),
    );
  }

  Future<void> _printPdf(BuildContext context, YearlyReportModel report) async {
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
                    pw.Text('Yearly Report - ${report.year}', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                  ]
                ),
                pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50),
              ]
            ),
            pw.SizedBox(height: 30),
            
            // Overview Section
            pw.Text('Yearly Financial Overview', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                _buildPdfRow('Total Revenue', CurrenceConverter.getCurrenceFloatInStrings(report.summary.totalRevenue, currency)),
                _buildPdfRow('Gross Profit', CurrenceConverter.getCurrenceFloatInStrings(report.summary.totalProfit + report.summary.totalExpenses, currency)),
                _buildPdfRow('Net Profit', CurrenceConverter.getCurrenceFloatInStrings(report.summary.totalProfit, currency)),
                _buildPdfRow('Total Expenses', CurrenceConverter.getCurrenceFloatInStrings(report.summary.totalExpenses, currency)),
                _buildPdfRow('Total Losses', CurrenceConverter.getCurrenceFloatInStrings(report.summary.totalLosses, currency)),
                _buildPdfRow('Total Refunds', CurrenceConverter.getCurrenceFloatInStrings(report.summary.totalMoneyRefunded, currency)),
                _buildPdfRow('Items Sold', '${report.summary.numberOfItemsSold}'),
                _buildPdfRow('Total Receipts', '${report.summary.numberOfReceipts}'),
              ]
            ),
            pw.SizedBox(height: 30),

            // Monthly Breakdown Table
            pw.Text('Monthly Breakdown', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Month', 'Revenue', 'Gross Profit', 'Net Profit', 'Expenses', 'Losses', 'Items'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey600),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
              cellAlignment: pw.Alignment.centerLeft,
              data: report.monthlyData.map((m) {
                return [
                  _getMonthName(m.month),
                  CurrenceConverter.getCurrenceFloatk(m.revenue, currency),
                  CurrenceConverter.getCurrenceFloatk(m.profit + m.expenses, currency),
                  CurrenceConverter.getCurrenceFloatk(m.profit, currency),
                  CurrenceConverter.getCurrenceFloatk(m.expenses, currency),
                  CurrenceConverter.getCurrenceFloatk(m.losses, currency),
                  '${m.itemsSold}',
                ];
              }).toList(),
            ),
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
  final String label, value;
  final IconData icon;
  final Color color;
  const _KpiData(this.label, this.value, this.icon, this.color);
}
