import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/payment_request_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/subscriptions.dart';

class PdfBillingHistory {
  static Future<pw.Document> generate({
    required String baseCurrence,
    required List<PaymentRequestModel> payments,
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
                    pw.Text("Billing History Report", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
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
            
            // ── Data Table ──
            pw.Text("Payment Records", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _makeTable(payments, baseCurrence),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _makeTable(List<PaymentRequestModel> payments, String baseCurrence) {
    if (payments.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
        child: pw.Center(child: pw.Text("No billing records found.", style: const pw.TextStyle(color: PdfColors.grey600))),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Table Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Plan", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Months", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Status", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        // Table Rows
        ...payments.map((e) => pw.TableRow(
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(MistDateUtils.getInformalDate(e.createdAt), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(MistSubscriptionUtils.getPlanDisplayName(e.subscription), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.months.toString(), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.amount, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                e.status,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: e.status == 'Completed' ? PdfColors.green800 : (e.status == 'Failed' ? PdfColors.red800 : PdfColors.orange800),
                ),
              ),
            ),
          ],
        )).toList(),
      ],
    );
  }
}
