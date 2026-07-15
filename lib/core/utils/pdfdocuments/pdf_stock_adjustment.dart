import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/stock_adjustment_model.dart';
import 'package:mistpos/data/models/inv_item.dart';
import 'package:mistpos/core/constants/constants.dart';

class PdfStockAdjustment {
  static Future<pw.Document> generate({
    required StockAdjustmentModel model,
    required String baseCurrency,
  }) async {
    final pdf = pw.Document();
    final user = User.fromStorage();

    // Find the readable label for the adjustment reason
    final reasonMap = Inventory.adjustStockReasons.firstWhere(
      (element) => element['value'] == model.reason,
      orElse: () => {"label": model.reason, "value": model.reason},
    );
    final reasonLabel = reasonMap['label'] ?? model.reason;

    // Load Logo
    pw.MemoryImage? logoImage;
    try {
      final ByteData data = await rootBundle.load('assets/launcher.png');
      logoImage = pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      // ignore
    }

    // Calculations
    final totalItemsCount = model.inventoryItems.length;
    final totalQtyAdjusted = model.inventoryItems.map((e) => e.quantity).fold(0.0, (val, el) => val + el);
    final totalCostVal = model.reason == "add"
        ? model.inventoryItems.map((e) => e.quantity * e.cost).fold(0.0, (val, el) => val + el)
        : 0.0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header with Logo
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      user?.companyName ?? "MistPOS Store",
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text("STOCK ADJUSTMENT REPORT", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 50, height: 50)
                else
                  pw.SizedBox(width: 50, height: 50),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 12),

            // Metadata section
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildMetaRow("Label / Name:", model.label.isEmpty || model.label == '--' ? "Stock Adjustment" : model.label),
                      _buildMetaRow("Reason:", reasonLabel),
                      if (model.notes.isNotEmpty)
                        _buildMetaRow("Notes:", model.notes),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildMetaRow("Date Created:", MistDateUtils.formatNormalDate(model.createdAt)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 16),

            // Summary section
            pw.Text("Summary Statistics", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox("Total Adjusted Products", "$totalItemsCount"),
                _buildStatBox("Total Qty Adjusted", "${totalQtyAdjusted.toInt()}"),
                if (model.reason == "add")
                  _buildStatBox("Total Added Cost", CurrenceConverter.getCurrenceFloatInStrings(totalCostVal, baseCurrency), valueColor: PdfColors.green700)
                else
                  _buildStatBox("Cost Impact", "N/A"),
              ],
            ),
            pw.SizedBox(height: 24),

            // Table section
            pw.Text("Products List", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildItemsTable(model.inventoryItems, model.reason, baseCurrency),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildMetaRow(String label, String value, {PdfColor? valueColor}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
          children: [
            pw.TextSpan(text: "$label ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TextSpan(text: value, style: valueColor != null ? pw.TextStyle(color: valueColor, fontWeight: pw.FontWeight.bold) : null),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildStatBox(String title, String value, {PdfColor? valueColor}) {
    return pw.Container(
      width: 160,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(List<InvItem> items, String reason, String baseCurrency) {
    final showCost = reason == "add";
    final qtyColLabel = reason == "add" ? "Added Qty" : (reason == "count" ? "Counted Qty" : "Removed Qty");

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(1.2),
        if (showCost) ...{
          4: const pw.FlexColumnWidth(1.5),
          5: const pw.FlexColumnWidth(1.8),
        }
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            _tableCell('Product Name', isHeader: true),
            _tableCell('Before Adj', isHeader: true),
            _tableCell(qtyColLabel, isHeader: true),
            _tableCell('After Adj', isHeader: true),
            if (showCost) ...[
              _tableCell('Cost Price', isHeader: true),
              _tableCell('Total Cost', isHeader: true),
            ]
          ],
        ),
        // Rows
        ...items.map((e) {
          final stockAfter = reason == "add"
              ? e.inStock + e.quantity
              : (reason == "count" ? e.quantity : e.inStock - e.quantity);
          final totalCost = e.quantity * e.cost;

          return pw.TableRow(
            children: [
              _tableCell(e.name),
              _tableCell(e.inStock.toString()),
              _tableCell(e.quantity.toString()),
              _tableCell(stockAfter.toString()),
              if (showCost) ...[
                _tableCell(CurrenceConverter.getCurrenceFloatInStrings(e.cost, baseCurrency)),
                _tableCell(CurrenceConverter.getCurrenceFloatInStrings(totalCost, baseCurrency)),
              ]
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _tableCell(String text, {bool isHeader = false, PdfColor? valueColor, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: (isHeader || isBold) ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: valueColor ?? PdfColors.black,
        ),
      ),
    );
  }
}
