import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/product_stats_model.dart';

class PdfInvEvaluation {
  static Future<pw.Document> generate({
    required DateTime? startDate,
    required DateTime? endDate,
    required StatsProductModel statsProductModel,
    required List<ItemModel> inventoryProducts,
    required String baseCurrence,
  }) async {
    final pdf = pw.Document();
    final user = User.fromStorage();

    // Load Logo
    pw.MemoryImage? logoImage;
    try {
      final ByteData data = await rootBundle.load('assets/launcher.png');
      logoImage = pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      // ignore
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // ── Header with Logo ──
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(user?.companyName ?? "Company Name",
                        style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Inventory Valuation Report",
                        style: pw.TextStyle(
                            fontSize: 18, color: PdfColors.grey700)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 60, height: 60),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 12),

            // ── Date Range ──
            pw.Row(
              children: [
                pw.Text("Report Period: ",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(
                    (startDate == null || endDate == null)
                        ? "All Time"
                        : "${MistDateUtils.getInformalShortDate(startDate)} to ${MistDateUtils.getInformalShortDate(endDate)}",
                    style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),

            // ── Summary ──
            pw.Text("Summary",
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildSummaryTable(statsProductModel, baseCurrence),

            pw.SizedBox(height: 32),

            // ── Inventory Products ──
            pw.Text("Inventory Products",
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildProductsTable(inventoryProducts, baseCurrence),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildSummaryTable(
      StatsProductModel stats, String baseCurrence) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5),
        1: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(
                padding: const pw.EdgeInsets.all(10),
                child: pw.Text("Metric",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(10),
                child: pw.Text("Value",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11))),
          ],
        ),
        _summaryRow(
            "Total Inventory Value",
            CurrenceConverter.getCurrenceFloatInStrings(
                stats.totalCost, baseCurrence)),
        _summaryRow(
            "Total Retail Value",
            CurrenceConverter.getCurrenceFloatInStrings(
                stats.totalRevenue, baseCurrence)),
        _summaryRow(
            "Potential Profit",
            CurrenceConverter.getCurrenceFloatInStrings(
                stats.totalRevenue - stats.totalCost, baseCurrence)),
        _summaryRow(
            "Margin",
            "${stats.totalRevenue > 0 ? ((stats.totalCost / stats.totalRevenue) * 100).toStringAsFixed(0) : '0'}%"),
      ],
    );
  }

  static pw.TableRow _summaryRow(String label, String value,
      {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: pw.Text(label,
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isBold ? pw.FontWeight.bold : pw.FontWeight.normal))),
        pw.Padding(
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: pw.Text(value,
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isBold ? pw.FontWeight.bold : pw.FontWeight.normal))),
      ],
    );
  }

  static pw.Widget _buildProductsTable(
      List<ItemModel> products, String baseCurrence) {
    final tableHeaders = [
      'Item Name',
      'Quantity',
      'Cost',
      'Retail',
      'Profit',
      'Margin',
    ];

    final tableData = products.map((e) {
      final effectiveQty = ((e.isCompositeItem && !e.useProduction && e.trackStock) || (!e.trackStock)) ? 1 : e.stockQuantity;
      final margin = e.price > 0 ? ((e.cost / e.price) * 100).toStringAsFixed(2) : "0.00";
      
      return [
        e.name,
        e.stockQuantity.toString(),
        CurrenceConverter.getCurrenceFloatInStrings(e.cost * effectiveQty, baseCurrence),
        CurrenceConverter.getCurrenceFloatInStrings(e.price * effectiveQty, baseCurrence),
        CurrenceConverter.getCurrenceFloatInStrings((e.price - e.cost) * effectiveQty, baseCurrence),
        "$margin%",
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: tableHeaders,
      data: tableData,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.black),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
      cellHeight: 22,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
      },
      cellStyle: const pw.TextStyle(fontSize: 9),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
        5: const pw.FlexColumnWidth(1),
      },
    );
  }
}
