import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/multishop_overview_model.dart';

class MultiShopOverviewPdf {
  static Future<pw.Document> generate({
    required DateTime? startDate,
    required DateTime endDate,
    required String baseCurrence,
    required List<MultiShopData> multishopData,
    required List<MultiShopGraphData> multishopGraphs,
    required String period,
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

    // Determine common dates from graphs
    Set<String> uniqueDates = {};
    for (var shop in multishopGraphs) {
      for (var point in shop.graphData) {
        if (point['date'] != null) {
          uniqueDates.add(point['date']);
        }
      }
    }
    List<String> allDates = uniqueDates.toList()..sort();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(user?.companyName ?? "Company Name", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("MultiShop Analytics Overview", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 60, height: 60),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 12),
            
            // Date Range
            pw.Row(
              children: [
                pw.Text("Report Period: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text("${startDate == null ? 'All Time' : MistDateUtils.getInformalShortDate(startDate)} to ${MistDateUtils.getInformalShortDate(endDate)}", style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),
            
            // Stats Overview Table
            pw.Text("Performance Overview", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildStatsTable(multishopData, baseCurrence),
            
            pw.SizedBox(height: 32),

            // Graph Data Table
            pw.Text("Analytics Comparison ($period)", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            if (multishopGraphs.isNotEmpty && allDates.isNotEmpty)
              _buildGraphTable(multishopGraphs, allDates, baseCurrence)
            else
              pw.Text("No analytical data available for this period.", style: const pw.TextStyle(color: PdfColors.grey)),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildStatsTable(List<MultiShopData> shops, String baseCurrence) {
    if (shops.isEmpty) return pw.SizedBox();

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Shop", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Revenue", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Gross Profit", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Net Profit", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Expenses", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...shops.map((shop) {
          final stats = shop.stats;
          final gross = stats.totalSales - stats.totalCost;
          final net = gross - stats.totalExpenses;
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(shop.companyName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(stats.totalSales, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(gross, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(net, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(stats.totalExpenses, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildGraphTable(List<MultiShopGraphData> shops, List<String> allDates, String baseCurrence) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            ...shops.map((shop) => pw.Padding(
              padding: const pw.EdgeInsets.all(8), 
              child: pw.Text(shop.companyName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))
            )),
          ],
        ),
        ...allDates.asMap().entries.map((entry) {
          final i = entry.key;
          final dateStr = entry.value;
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10))),
              ...shops.map((shop) {
                double val = 0.0;
                final point = shop.graphData.firstWhere(
                  (p) => p['date'] == dateStr, 
                  orElse: () => <String, dynamic>{}
                );
                val = (point['totalPaid'] ?? 0.0).toDouble();
                return pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(val, baseCurrence), style: const pw.TextStyle(fontSize: 10)));
              }),
            ],
          );
        }),
      ],
    );
  }
}
