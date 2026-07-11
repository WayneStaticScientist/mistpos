import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/date_utils.dart';

class PdfResellerReport {
  static Future<pw.Document> generateMerchantsReport({
    required List<dynamic> companies,
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
                    pw.Text(user?.companyName ?? "Reseller", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Referred Merchants Report", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text("Generated on: ${MistDateUtils.formatNormalDate(DateTime.now())}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 60, height: 60),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 24),

            // Table
            pw.Text("Merchant List", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _makeMerchantsTable(companies),
          ];
        },
      ),
    );
    return pdf;
  }

  static Future<pw.Document> generateMonthlyReport({
    required List<dynamic> monthlyBreakdown,
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
                    pw.Text(user?.companyName ?? "Reseller", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Monthly Earnings Summary Report", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text("Year: ${DateTime.now().year}", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Generated on: ${MistDateUtils.formatNormalDate(DateTime.now())}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 60, height: 60),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 24),

            // Table
            pw.Text("Earnings Breakdown", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _makeMonthlyTable(monthlyBreakdown),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _makeMerchantsTable(List<dynamic> companies) {
    if (companies.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
        child: pw.Center(child: pw.Text("No referred merchants found.", style: const pw.TextStyle(color: PdfColors.grey600))),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Merchant Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Payment Plan", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Referred Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...companies.map((c) {
          final name = c['name'] ?? "N/A";
          final plan = c['paymentPlan'] ?? "free";
          final dateStr = c['createdAt'] != null
              ? MistDateUtils.getInformalDate(DateTime.parse(c['createdAt'].toString()))
              : "N/A";

          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(name, style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(plan.toString().toUpperCase(), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10))),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _makeMonthlyTable(List<dynamic> monthlyBreakdown) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Month", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Transactions Count", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Commission Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...monthlyBreakdown.map((m) {
          final month = m['month'] ?? "N/A";
          final count = m['count'] ?? 0;
          final amount = (m['amount'] ?? 0.0).toDouble();

          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(month, style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(count.toString(), style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("\$${amount.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: amount > 0 ? PdfColors.green800 : PdfColors.black))),
            ],
          );
        }).toList(),
      ],
    );
  }
}
