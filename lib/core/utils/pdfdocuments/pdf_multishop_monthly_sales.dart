import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/multishop_overview_model.dart';

class MultiShopMonthlySalesPdf {
  static Future<pw.Document> generate({
    required DateTime date,
    required String baseCurrence,
    required List<MultiShopDailySalesData> multishopData,
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

    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final monthStr = '${months[date.month - 1]} ${date.year}';

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
                    pw.Text("MultiShop Monthly Sales Overview", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
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
                pw.Text("Report Month: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(monthStr, style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),
            
            // Stats Overview Table
            pw.Text("Comparative Overview", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildStatsTable(multishopData, baseCurrence),
            
            pw.SizedBox(height: 32),

            // Graph Data Table
            pw.Text("Daily Analytics Comparison", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            if (multishopData.isNotEmpty)
              _buildDailyGraphTable(multishopData, baseCurrence, date)
            else
              pw.Text("No analytical data available for this period.", style: const pw.TextStyle(color: PdfColors.grey)),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildStatsTable(List<MultiShopDailySalesData> shops, String baseCurrence) {
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
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Taxes", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Discounts", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...shops.map((shop) {
          final stats = shop.dailyData;
          final totalSales = (stats['totalSales'] ?? 0.0).toDouble();
          final gross = (stats['grossProfit'] ?? 0.0).toDouble();
          final net = (stats['netProfit'] ?? 0.0).toDouble();
          final expenses = (stats['totalExpenses'] ?? 0.0).toDouble();
          final taxes = (stats['totalTaxs'] ?? 0.0).toDouble();
          final discounts = (stats['totalDiscounts'] ?? 0.0).toDouble();
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(shop.companyName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(totalSales, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(gross, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(net, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(expenses, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(taxes, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(discounts, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildDailyGraphTable(List<MultiShopDailySalesData> shops, String baseCurrence, DateTime date) {
    // Only show days where there is activity across any shop to save space
    Set<int> activeDays = {};
    for (var shop in shops) {
      final List<dynamic> dailyData = shop.dailyData['dailyData'] ?? [];
      for (var point in dailyData) {
        if ((point['revenue'] ?? 0) > 0 || (point['expenses'] ?? 0) > 0 || (point['receipts'] ?? 0) > 0) {
          activeDays.add(point['day']);
        }
      }
    }
    
    // If no active days, just show everything or an empty state
    if (activeDays.isEmpty) {
      return pw.Text("No daily activity recorded.", style: const pw.TextStyle(color: PdfColors.grey));
    }
    
    List<int> displayDays = activeDays.toList()..sort();

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Day", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            ...shops.map((shop) => pw.Padding(
              padding: const pw.EdgeInsets.all(8), 
              child: pw.Text(shop.companyName + "\n(Rev / Exp)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9), textAlign: pw.TextAlign.center)
            )),
          ],
        ),
        ...displayDays.map((day) {
          final monthsShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          final dayStr = '${monthsShort[date.month - 1]} ${day.toString().padLeft(2, '0')}';
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(dayStr, style: const pw.TextStyle(fontSize: 10))),
              ...shops.map((shop) {
                final List<dynamic> dailyData = shop.dailyData['dailyData'] ?? [];
                final point = dailyData.firstWhere(
                  (p) => p['day'] == day, 
                  orElse: () => <String, dynamic>{}
                );
                
                final revenue = (point['revenue'] ?? 0.0).toDouble();
                final expenses = (point['expenses'] ?? 0.0).toDouble();
                
                final formatted = "${CurrenceConverter.getCurrenceFloatInStrings(revenue, baseCurrence)} / ${CurrenceConverter.getCurrenceFloatInStrings(expenses, baseCurrence)}";

                return pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(formatted, style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center));
              }),
            ],
          );
        }),
      ],
    );
  }
}
