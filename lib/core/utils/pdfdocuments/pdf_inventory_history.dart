import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/data/models/inventory_history_model.dart';

class PdfInventoryHistory {
  static Future<pw.Document> generate({
    required DateTime? startDate,
    required DateTime? endDate,
    required List<InventoryHistoryModel> invHistory,
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
                    pw.Text("Inventory History Report",
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

            // ── Inventory History Table ──
            pw.Text("Inventory Logs",
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildHistoryTable(invHistory),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildHistoryTable(List<InventoryHistoryModel> historyModel) {
    final tableHeaders = [
      'Item Name',
      'Document Type',
      'Qty Change',
      'Date',
    ];

    final tableData = historyModel.map((e) {
      final change = e.quantityChange ?? 0.0;
      final displayChange = change == 0
          ? "0"
          : "${change > 0 ? '+' : ''}${change.toStringAsFixed(0)}";
      return [
        e.itemName ?? '-',
        e.documentType ?? "-",
        displayChange,
        e.createdAt != null ? MistDateUtils.getInformalShortDate(e.createdAt!) : "",
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
      },
      cellStyle: const pw.TextStyle(fontSize: 9),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1.2),
      },
    );
  }
}
