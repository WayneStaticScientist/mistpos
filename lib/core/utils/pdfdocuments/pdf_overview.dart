import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/sales_stats_model.dart';
import 'package:mistpos/data/models/product_stats_model.dart';
import 'package:mistpos/data/models/this_month_summary_model.dart';

class AdminOverviewPdf {
  static Future<pw.Document> generate({
    required DateTime week,
    required DateTime startDate,
    required DateTime endDate,
    required String baseCurrence,
    required StatsProductModel? statsProductModel,
    required int totalProducts,
    required StatsSalesModel? statsSalesModel,
    required ThisMonthSummaryModel? thisMonthSummary,
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
                    pw.Text(user?.companyName ?? "Company Name", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Analytics & Overview Report", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
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
                pw.Text("Report Period: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text("${MistDateUtils.getInformalShortDate(startDate)} to ${MistDateUtils.getInformalShortDate(endDate)}", style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),
            
            // ── Product Overview Table ──
            pw.Text("Product Overview", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildProductTable(statsProductModel, totalProducts, baseCurrence),
            
            pw.SizedBox(height: 32),

            // ── Sales Overview Table ──
            pw.Text("Sales Overview", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildSalesTable(statsSalesModel, baseCurrence),
            
            pw.SizedBox(height: 32),

            // ── This Month Summary ──
            if (thisMonthSummary != null) ...[
              pw.Text("This Month Summary", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
              pw.SizedBox(height: 8),
              _buildThisMonthSummaryTable(thisMonthSummary, baseCurrence),
            ],
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildProductTable(StatsProductModel? stats, int totalProducts, String baseCurrence) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Total Products", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Items In Stock", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Stock Value", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Total Revenue", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(totalProducts.toString(), style: const pw.TextStyle(fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(stats?.totalStock.toString() ?? "0", style: const pw.TextStyle(fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(stats?.totalCost ?? 0, baseCurrence), style: const pw.TextStyle(fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(stats?.totalRevenue ?? 0, baseCurrence), style: const pw.TextStyle(fontSize: 11))),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSalesTable(StatsSalesModel? stats, String baseCurrence) {
    final profit = (stats?.totalSales ?? 0) - (stats?.totalCost ?? 0);
    
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
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Metric", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Value", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
          ],
        ),
        _salesRow("Total Sales", CurrenceConverter.getCurrenceFloatInStrings(stats?.totalSales ?? 0, baseCurrence)),
        _salesRow("Gross Profit", CurrenceConverter.getCurrenceFloatInStrings(profit, baseCurrence), isBold: true),
        _salesRow("Discounts", CurrenceConverter.getCurrenceFloatInStrings(stats?.totalDiscounts ?? 0, baseCurrence)),
        _salesRow("Taxes", CurrenceConverter.getCurrenceFloatInStrings(stats?.totalTaxs ?? 0, baseCurrence)),
        _salesRow("Refunds", CurrenceConverter.getCurrenceFloatInStrings(stats?.totalRefunds ?? 0, baseCurrence)),
        _salesRow("Total Loss", CurrenceConverter.getCurrenceFloatInStrings(stats?.totalLossValue ?? 0, baseCurrence), color: PdfColors.red800),
        _salesRow("Total Receipts", stats?.totalReceipts.toString() ?? "0"),
        _salesRow("Active Cashiers", stats?.numberOfCashiers.toString() ?? "0"),
      ],
    );
  }

  static pw.TableRow _salesRow(String label, String value, {bool isBold = false, PdfColor? color}) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: pw.Text(label, style: pw.TextStyle(fontSize: 11, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal))),
        pw.Padding(padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, color: color))),
      ],
    );
  }

  static pw.Widget _buildThisMonthSummaryTable(ThisMonthSummaryModel stats, String baseCurrence) {
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
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Metric", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
            pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text("Value", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
          ],
        ),
        _salesRow("Total Revenue", CurrenceConverter.getCurrenceFloatInStrings(stats.totalRevenue, baseCurrence)),
        _salesRow("Gross Profit", CurrenceConverter.getCurrenceFloatInStrings(stats.grossProfit, baseCurrence)),
        _salesRow("Net Profit", CurrenceConverter.getCurrenceFloatInStrings(stats.netProfit, baseCurrence)),
        _salesRow("Total Expenses", CurrenceConverter.getCurrenceFloatInStrings(stats.totalExpenses, baseCurrence)),
        _salesRow("Items Sold", stats.totalItemsSold.toString()),
        _salesRow("Receipts Processed", stats.totalReceipts.toString()),
        _salesRow("Peak Sales Time", stats.peakSalesRange),
      ],
    );
  }
}
