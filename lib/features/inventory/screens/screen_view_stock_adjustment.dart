import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/data/models/inv_item.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/constants/constants.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/data/models/stock_adjustment_model.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_stock_adjustment.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class ScreenViewStockAdjustment extends StatefulWidget {
  final StockAdjustmentModel model;
  const ScreenViewStockAdjustment({super.key, required this.model});

  @override
  State<ScreenViewStockAdjustment> createState() =>
      _ScreenViewStockAdjustmentState();
}

class _ScreenViewStockAdjustmentState extends State<ScreenViewStockAdjustment> {
  final _userController = Get.find<UserController>();

  void _printDocument() async {
    Toaster.showSuccess("Preparing document, please wait...");
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    try {
      final pdf = await PdfStockAdjustment.generate(
        model: widget.model,
        baseCurrency: baseCurrency,
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Stock_Adjustment_Report.pdf',
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
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Stock Adjustment Details".text(),
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
    final reasonMap = Inventory.adjustStockReasons.firstWhere(
      (element) => element['value'] == widget.model.reason,
      orElse: () => {'label': widget.model.reason.toUpperCase()},
    );
    final reasonLabel = reasonMap['label'] ?? widget.model.reason.toUpperCase();

    Color statusColor;
    IconData statusIcon;
    if (widget.model.reason == "add") {
      statusColor = Colors.green;
      statusIcon = Icons.add_circle_outline_rounded;
    } else if (widget.model.reason == "count") {
      statusColor = Colors.amber;
      statusIcon = Icons.rule_rounded;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.remove_circle_outline_rounded;
    }

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
                  color: statusColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    6.gapWidth,
                    reasonLabel.toString().text(
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.adjust_rounded,
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
              "Date of Adjustment".text(
                style: TextStyle(
                  fontSize: 11,
                  color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.gapHeight,
              MistDateUtils.getInformalDate(widget.model.createdAt).text(
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
    final totalItemsAdjusted = widget.model.inventoryItems.length;

    Color badgeColor;
    String reasonText = "";
    String typeIcon = Bx.adjust;
    if (widget.model.reason == "add") {
      badgeColor = Colors.green;
      reasonText = "ADD STOCK";
      typeIcon = Bx.arrow_to_top;
    } else if (widget.model.reason == "count") {
      badgeColor = Colors.amber;
      reasonText = "RE-COUNT";
      typeIcon = Bx.timer;
    } else {
      badgeColor = Colors.red;
      reasonText = "REMOVE STOCK";
      typeIcon = Bx.x;
    }

    final showCostCard = widget.model.reason == "add";
    final totalCostAdded = widget.model.inventoryItems
        .map((e) => e.cost * e.quantity)
        .fold(0.0, (val, el) => val + el);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (showCostCard) {
          final double cardWidth = (constraints.maxWidth - 32) / 3;
          return Row(
            children: [
              SizedBox(
                width: cardWidth,
                height: 100,
                child: _buildMetricCard(
                  title: "Adjustment",
                  value: reasonText,
                  icon: typeIcon,
                  color: badgeColor,
                  bgColor: badgeColor.withValues(alpha: isDark ? 0.12 : 0.06),
                ),
              ),
              16.gapWidth,
              SizedBox(
                width: cardWidth,
                height: 100,
                child: _buildMetricCard(
                  title: "Total Cost Added",
                  value: CurrenceConverter.getCurrenceFloatInStrings(
                    totalCostAdded,
                    _userController.user.value?.baseCurrence ?? '',
                  ),
                  icon: Bx.dollar,
                  color: Colors.green,
                  bgColor: Colors.green.withValues(alpha: isDark ? 0.12 : 0.06),
                ),
              ),
              16.gapWidth,
              SizedBox(
                width: cardWidth,
                height: 100,
                child: _buildMetricCard(
                  title: "Items Adjusted",
                  value: "$totalItemsAdjusted items",
                  icon: Bx.layer,
                  color: Get.theme.colorScheme.primary,
                  bgColor: Get.theme.colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.06),
                ),
              ),
            ],
          );
        } else {
          final double cardWidth = (constraints.maxWidth - 16) / 2;
          return Row(
            children: [
              SizedBox(
                width: cardWidth,
                height: 100,
                child: _buildMetricCard(
                  title: "Adjustment Type",
                  value: reasonText,
                  icon: typeIcon,
                  color: badgeColor,
                  bgColor: badgeColor.withValues(alpha: isDark ? 0.12 : 0.06),
                ),
              ),
              16.gapWidth,
              SizedBox(
                width: cardWidth,
                height: 100,
                child: _buildMetricCard(
                  title: "Items Adjusted",
                  value: "$totalItemsAdjusted items",
                  icon: Bx.layer,
                  color: Get.theme.colorScheme.primary,
                  bgColor: Get.theme.colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.06),
                ),
              ),
            ],
          );
        }
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
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
          "Adjusted Stock Items".text(
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          16.gapHeight,
          _makeTable(widget.model.inventoryItems),
        ],
      ),
    );
  }

  Widget _makeTable(List<InvItem> inventoryItems) {
    final isDark = Get.isDarkMode;
    final rowBgColor = WidgetStateProperty.resolveWith<Color?>((states) {
      return null;
    });

    final showCost = widget.model.reason == "add";

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
            columns: [
              const DataColumn(label: Text('Item Name')),
              const DataColumn(label: Text('Current Stock'), numeric: true),
              DataColumn(label: Text(_getLabel()), numeric: true),
              if (showCost) const DataColumn(label: Text('Unit Cost'), numeric: true),
              if (showCost) const DataColumn(label: Text('Total Cost'), numeric: true),
              const DataColumn(label: Text('Stock After'), numeric: true),
            ],
            rows: inventoryItems
                .map(
                  (e) {
                    final stockAfter = _getStockAfter(e);
                    final totalCost = e.cost * e.quantity;

                    Color adjColor;
                    String prefix = "";
                    if (widget.model.reason == "add") {
                      adjColor = Colors.green;
                      prefix = "+";
                    } else if (widget.model.reason == "count") {
                      adjColor = Colors.amber;
                    } else {
                      adjColor = Colors.red;
                      prefix = "-";
                    }

                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          e.name.text(
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(e.inStock.toString().text()),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: adjColor.withValues(alpha: isDark ? 0.15 : 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: adjColor.withValues(alpha: 0.3)),
                            ),
                            child: "$prefix${e.quantity}".text(
                              style: TextStyle(
                                color: adjColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        if (showCost)
                          DataCell(
                            CurrenceConverter.getCurrenceFloatInStrings(
                              e.cost,
                              _userController.user.value?.baseCurrence ?? '',
                            ).text(),
                          ),
                        if (showCost)
                          DataCell(
                            CurrenceConverter.getCurrenceFloatInStrings(
                              totalCost,
                              _userController.user.value?.baseCurrence ?? '',
                            ).text(
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        DataCell(
                          stockAfter.toString().text(
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

  String _getLabel() {
    if (widget.model.reason == "add") {
      return "Added Stock";
    }
    if (widget.model.reason == "count") {
      return "Counted";
    }
    return "Removed Stock";
  }

  double _getStockAfter(InvItem e) {
    if (widget.model.reason == "add") {
      return e.inStock + e.quantity;
    }
    if (widget.model.reason == "count") {
      return e.quantity;
    }
    return e.inStock - e.quantity;
  }
}
