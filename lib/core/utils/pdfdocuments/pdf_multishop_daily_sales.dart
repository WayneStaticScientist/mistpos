import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/multishop_overview_model.dart';

class MultiShopDailySalesPdf {
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
                    pw.Text("MultiShop Daily Sales Overview", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
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
                pw.Text("Report Date: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(MistDateUtils.getInformalDate(date), style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),
            
            // Stats Overview Table
            pw.Text("Comparative Overview", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildStatsTable(multishopData, baseCurrence),
            
            pw.SizedBox(height: 32),

            // Graph Data Table
            pw.Text("Hourly Analytics Comparison", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            if (multishopData.isNotEmpty)
              _buildHourlyGraphTable(multishopData, baseCurrence)
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

  static String _formatHourLabel(int hour) {
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final ampm = hour >= 12 ? 'PM' : 'AM';
    return '$h $ampm';
  }

  static pw.Widget _buildHourlyGraphTable(List<MultiShopDailySalesData> shops, String baseCurrence) {
    // Collect all hours
    List<int> allHours = List.generate(24, (index) => index);
    
    // Only show hours where there is activity across any shop to save space
    Set<int> activeHours = {};
    for (var shop in shops) {
      final List<dynamic> hourlyData = shop.dailyData['hourlyData'] ?? [];
      for (var point in hourlyData) {
        if ((point['revenue'] ?? 0) > 0 || (point['expenses'] ?? 0) > 0 || (point['receipts'] ?? 0) > 0) {
          activeHours.add(point['hour']);
        }
      }
    }
    
    // If no active hours, just show everything or an empty state
    if (activeHours.isEmpty) {
      return pw.Text("No hourly activity recorded.", style: const pw.TextStyle(color: PdfColors.grey));
    }
    
    List<int> displayHours = activeHours.toList()..sort();

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Hour", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            ...shops.map((shop) => pw.Padding(
              padding: const pw.EdgeInsets.all(8), 
              child: pw.Text(shop.companyName + "\n(Rev / Exp)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9), textAlign: pw.TextAlign.center)
            )),
          ],
        ),
        ...displayHours.map((hour) {
          final hourStr = _formatHourLabel(hour);
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(hourStr, style: const pw.TextStyle(fontSize: 10))),
              ...shops.map((shop) {
                final List<dynamic> hourlyData = shop.dailyData['hourlyData'] ?? [];
                final point = hourlyData.firstWhere(
                  (p) => p['hour'] == hour, 
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
