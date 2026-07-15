import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/production_model.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_production.dart';

class ScreenViewProductions extends StatefulWidget {
  final ProductionModel model;
  const ScreenViewProductions({super.key, required this.model});

  @override
  State<ScreenViewProductions> createState() => _ScreenViewProductionsState();
}

class _ScreenViewProductionsState extends State<ScreenViewProductions> {
  final _userController = Get.find<UserController>();

  void _printDocument() async {
    Toaster.showSuccess("Preparing document, please wait...");
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await PdfProduction.generate(
        model: widget.model,
        baseCurrency: baseCurrency,
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Production_Report.pdf',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: "Productions Details".text(),
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: _printDocument,
            tooltip: "Print to PDF",
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          _buildHeaderCard(isDark),
          20.gapHeight,
          _buildMetricsGrid(isDark),
          20.gapHeight,
          _buildProductInformation(isDark),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green[700]!.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: Colors.green[700]!, size: 16),
                    6.gapWidth,
                    "Processed".text(
                      style: TextStyle(
                        color: Colors.green[700]!,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.precision_manufacturing_outlined,
                size: 20,
                color: Get.theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          16.gapHeight,
          widget.model.label.text(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          16.gapHeight,
          Divider(
            color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
            height: 1,
          ),
          16.gapHeight,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Created At".text(
                style: TextStyle(
                  fontSize: 11,
                  color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.gapHeight,
              if (widget.model.createdAt != null)
                MistDateUtils.getInformalDate(widget.model.createdAt!).text(
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                "N/A".text(
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(bool isDark) {
    final totalItems = widget.model.items.length;
    final totalCost = widget.model.items
        .map((e) => e.cost * e.quantity)
        .fold(0.0, (val, el) => val + el);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 16) / 2;
        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              height: 100,
              child: _buildMetricCard(
                title: "Total Cost",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  totalCost,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                icon: Bx.dollar,
                color: Get.theme.colorScheme.primary,
                bgColor: Get.theme.colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.06),
              ),
            ),
            16.gapWidth,
            SizedBox(
              width: cardWidth,
              height: 100,
              child: _buildMetricCard(
                title: "Composite Items",
                value: "$totalItems items",
                icon: Bx.layer,
                color: Colors.blue[700]!,
                bgColor: Colors.blue.withValues(alpha: isDark ? 0.12 : 0.06),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
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
                child: title.text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              8.gapWidth,
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Iconify(icon, color: color, size: 16),
              ),
            ],
          ),
          value.text(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInformation(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Composite Items".text(
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          16.gapHeight,
          _makeTable(),
        ],
      ),
    );
  }

  Widget _makeTable() {
    final isDark = Get.isDarkMode;
    final rowBgColor = WidgetStateProperty.resolveWith<Color?>((states) {
      return null;
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: ScreenSizes.maxWidth - 64),
          child: DataTable(
            columnSpacing: 16,
            horizontalMargin: 16,
            headingRowColor: WidgetStateProperty.all(
              Get.theme.colorScheme.primary.withValues(alpha: 0.06),
            ),
            dataRowColor: rowBgColor,
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
              fontSize: 13,
            ),
            columns: const [
              DataColumn(label: Text('Item Name')),
              DataColumn(label: Text('Cost'), numeric: true),
              DataColumn(label: Text('Quantity'), numeric: true),
              DataColumn(label: Text('Total Cost'), numeric: true),
              DataColumn(label: Text('Status')),
            ],
            rows: widget.model.items
                .map(
                  (e) {
                    final itemTotalCost = e.cost * e.quantity;
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          e.name.text(
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          CurrenceConverter.getCurrenceFloatInStrings(
                            e.cost,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(),
                        ),
                        DataCell(e.quantity.toString().text()),
                        DataCell(
                          CurrenceConverter.getCurrenceFloatInStrings(
                            itemTotalCost,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          e.updated
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: isDark ? 0.15 : 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green[700]!.withValues(alpha: 0.3)),
                                  ),
                                  child: "PROCESSED".text(
                                    style: TextStyle(
                                      color: Colors.green[700]!,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[700]!.withValues(alpha: 0.3)),
                                  ),
                                  child: "PENDING".text(
                                    style: TextStyle(
                                      color: Colors.red[700]!,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
