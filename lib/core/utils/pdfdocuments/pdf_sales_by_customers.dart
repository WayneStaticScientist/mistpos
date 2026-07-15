import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/sales_by_customer_model.dart';

class SalesByCustomersPdf {
  static Future<pw.Document> generate({
    required DateTime startDate,
    required DateTime endDate,
    required String baseCurrency,
    required SalesByCustomerModel data,
  }) async {
    final pdf = pw.Document();
    final user = User.fromStorage();

    // Load Logo
    pw.MemoryImage? logoImage;
    try {
      final ByteData imgData = await rootBundle.load('assets/launcher.png');
      logoImage = pw.MemoryImage(imgData.buffer.asUint8List());
    } catch (e) {
      // ignore
    }

    final totalRevenue = data.totalCustomersSales + data.totalUncategorizedSales;
    final penetrationRatio = totalRevenue > 0 ? (data.totalCustomersSales / totalRevenue) * 100 : 0.0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
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
                    pw.Text(
                      user?.companyName ?? "Company Name",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.indigo800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Sales by Customers Analysis",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 50, height: 50),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(color: PdfColors.indigo200, thickness: 1.5),
            pw.SizedBox(height: 10),

            // Date Range
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Report Period: ${MistDateUtils.getInformalShortDate(startDate)} to ${MistDateUtils.getInformalShortDate(endDate)}",
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
                pw.Text(
                  "Generated on: ${MistDateUtils.getInformalShortDate(DateTime.now())}",
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Summary Section
            pw.Text(
              "Period Revenue Summary",
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.indigo800,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildSummaryTable(data, baseCurrency, totalRevenue, penetrationRatio),
            pw.SizedBox(height: 24),

            // Top Customers Section
            if (data.topCustomers.isNotEmpty) ...[
              pw.Text(
                "Top 10 Customer Spenders",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.indigo800,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildTopCustomersTable(data.topCustomers, baseCurrency, data.totalCustomersSales),
              pw.SizedBox(height: 24),
            ],

            // Customer Transactions Registry Section
            pw.Text(
              "Customer Transactions Registry",
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.indigo800,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildRegistryTable(data.list, baseCurrency),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildSummaryTable(
    SalesByCustomerModel data,
    String baseCurrency,
    double totalRevenue,
    double penetrationRatio,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5),
        1: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.indigo50),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Revenue Metric", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Value", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
          ],
        ),
        _buildRow("Registered Customers Sales", CurrenceConverter.getCurrenceFloatInStrings(data.totalCustomersSales, baseCurrency)),
        _buildRow("Uncategorized Sales", CurrenceConverter.getCurrenceFloatInStrings(data.totalUncategorizedSales, baseCurrency)),
        _buildRow("Total Revenue", CurrenceConverter.getCurrenceFloatInStrings(totalRevenue, baseCurrency), isBold: true, color: PdfColors.indigo800),
        _buildRow("Identification Penetration Ratio", "${penetrationRatio.toStringAsFixed(1)}% Identified"),
      ],
    );
  }

  static pw.TableRow _buildRow(String label, String value, {bool isBold = false, PdfColor? color}) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTopCustomersTable(
    List<CustomerSalesData> topCustomers,
    String baseCurrency,
    double totalCustomersSales,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1.2),
        4: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.indigo50),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("#", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Customer Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Receipts Count", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Total Spent", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Share %", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
          ],
        ),
        ...topCustomers.asMap().entries.map((entry) {
          final idx = entry.key;
          final c = entry.value;
          final share = totalCustomersSales > 0 ? (c.totalPaid / totalCustomersSales) * 100 : 0.0;
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text("${idx + 1}", style: const pw.TextStyle(fontSize: 9)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(c.customerName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(c.receiptCount.toString(), style: const pw.TextStyle(fontSize: 9)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  CurrenceConverter.getCurrenceFloatInStrings(c.totalPaid, baseCurrency),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.green800),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text("${share.toStringAsFixed(1)}%", style: const pw.TextStyle(fontSize: 9)),
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildRegistryTable(List<CustomerSalesData> list, String baseCurrency) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(1.2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.indigo50),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Customer Identity", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Receipts", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Cumulative Paid", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("Outstanding Credit", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
          ],
        ),
        ...list.map((c) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(c.customerName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(c.receiptCount.toString(), style: const pw.TextStyle(fontSize: 9)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  CurrenceConverter.getCurrenceFloatInStrings(c.totalPaid, baseCurrency),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.green800),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  CurrenceConverter.getCurrenceFloatInStrings(c.currentCredit, baseCurrency),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                    color: c.currentCredit > 0 ? PdfColors.red800 : PdfColors.grey700,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
