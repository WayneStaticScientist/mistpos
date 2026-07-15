import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/dialy_sale_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';

class PdfDailySales {
  static Future<pw.Document> generate({
    required DateTime endDate,
    DateTime? startDate,
    required String baseCurrence,
    required List<DialySaleModel> dailySales,
  }) async {
    final pdf = pw.Document();
    final user = User.fromStorage();
    
    // Load Logo
    pw.MemoryImage? logoImage;
    try {
      final ByteData data = await rootBundle.load('assets/launcher.png');
      logoImage = pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      // ignore if logo not found
    }

    final totalSales = dailySales.fold(0.0, (prev, data) => prev + data.totalSales);
    final totalCosts = dailySales.fold(0.0, (prev, data) => prev + data.totalCosts);
    final netProfit = totalSales - totalCosts;

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
                    pw.Text(user?.companyName ?? "Company Name", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Daily Sales Report", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
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
                pw.Text("Period: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                if (startDate == null)
                  pw.Text(MistDateUtils.formatNormalDate(endDate), style: const pw.TextStyle(fontSize: 12)),
                if (startDate != null)
                  pw.Text("${MistDateUtils.getInformalShortDate(startDate)} to ${MistDateUtils.getInformalShortDate(endDate)}", style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),
            
            // ── KPI Summary Table ──
            pw.Text("Financial Summary", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildSummaryTable(totalSales, totalCosts, netProfit, baseCurrence),
            pw.SizedBox(height: 32),
            
            // ── Data Table ──
            pw.Text("Itemized Sales", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _makeTable(dailySales, baseCurrence),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildSummaryTable(double sales, double costs, double profit, String baseCurrence) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Total Sales", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Total Costs", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Net Profit", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(sales, baseCurrence), style: const pw.TextStyle(fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(costs, baseCurrence), style: const pw.TextStyle(fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(profit, baseCurrence), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: profit >= 0 ? PdfColors.green800 : PdfColors.red800))),
          ],
        ),
      ],
    );
  }

  static pw.Widget _makeTable(List<DialySaleModel> dailySales, String baseCurrence) {
    if (dailySales.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
        child: pw.Center(child: pw.Text("No sales data available.", style: const pw.TextStyle(color: PdfColors.grey600))),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Table Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Item Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Qty Sold", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Total Sales", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Total Costs", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        // Table Rows
        ...dailySales.map((e) => pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.productName, style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.totalCount.toString(), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.totalSales, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.totalCosts, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
          ],
        )),
      ],
    );
  }
}
