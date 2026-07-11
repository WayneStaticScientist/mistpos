import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mistpos/data/models/sales_by_category_model.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:flutter/services.dart';
import 'package:mistpos/core/utils/date_utils.dart';

class PdfSalesByCategories {
  static Future<pw.Document> generate({
    required DateTime startDate,
    required DateTime endDate,
    required List<SalesByCategoryModel> salesByCategories,
    required String baseCurrence,
  }) async {
    final pdf = pw.Document();
    final user = User.fromStorage();
    
    final totalGross = salesByCategories.fold(0.0, (prev, data) => prev + data.grossSales);
    final totalItemsSold = salesByCategories.fold(0, (prev, data) => prev + data.itemsSold);
    
    final ByteData bytes = await rootBundle.load('assets/launcher.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final image = pw.MemoryImage(byteList);
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // ── Header ──
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(user?.companyName ?? "Company Name", style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Categories Sales Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
                  ],
                ),
                pw.Image(image, width: 60, height: 60),
              ],
            ),
            pw.SizedBox(height: 18),
            
            // ── Date Range ──
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(8)),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text("From ${MistDateUtils.getInformalShortDate(startDate)} to ${MistDateUtils.getInformalShortDate(endDate)}", style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 24),
            
            // ── KPI Metrics ──
            pw.Row(
              children: [
                pw.Expanded(child: _buildCard("Active Categories", salesByCategories.length.toString(), PdfColors.purple50)),
                pw.SizedBox(width: 16),
                pw.Expanded(child: _buildCard("Gross Sales", CurrenceConverter.getCurrenceFloatInStrings(totalGross, baseCurrence), PdfColors.blue50)),
                pw.SizedBox(width: 16),
                pw.Expanded(child: _buildCard("Items Sold", totalItemsSold.toString(), PdfColors.orange50)),
              ],
            ),
            pw.SizedBox(height: 32),
            
            // ── Data Table ──
            _makeTable(salesByCategories, baseCurrence),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildCard(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          pw.SizedBox(height: 8),
          pw.Text(value, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _makeTable(List<SalesByCategoryModel> data, String baseCurrence) {
    if (data.isEmpty) {
      return pw.Center(child: pw.Text("No sales data available.", style: const pw.TextStyle(color: PdfColors.grey600)));
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(1.2),
      },
      children: [
        // Table Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Category", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Gross Sales", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Refunds", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Items Sold", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        // Table Rows
        ...data.map((e) => pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(e.categoryName, style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.grossSales, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.refunds, baseCurrence), style: pw.TextStyle(fontSize: 10, color: e.refunds > 0 ? PdfColors.red : null))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(e.itemsSold.toString(), style: const pw.TextStyle(fontSize: 10))),
          ],
        )),
      ],
    );
  }
}
