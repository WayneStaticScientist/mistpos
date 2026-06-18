import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';

class PdfReceit {
  static Future<pw.Document> generate(
    ItemReceitModel receitModel,
    String baseCurrence,
    User? user,
  ) async {
    final pdf = pw.Document();

    // Load logo if available
    pw.MemoryImage? logoImage;
    try {
      final ByteData data = await rootBundle.load('assets/launcher.png');
      final Uint8List bytes = data.buffer.asUint8List();
      logoImage = pw.MemoryImage(bytes);
    } catch (_) {
      // Ignored if logo not found
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // ── App Logo & Company Header ──
              if (logoImage != null)
                pw.Image(logoImage, height: 60, width: 60),
              pw.SizedBox(height: 8),
              pw.Text(
                user?.companyName ?? "Company Name",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "Thank you for your business",
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey400, thickness: 1),
              pw.SizedBox(height: 12),

              // ── Receipt Details ──
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBlock("Receipt No", receitModel.label),
                  _buildInfoBlock("Date", MistDateUtils.getInformalShortDate(receitModel.createdAt), crossAxisAlignment: pw.CrossAxisAlignment.end),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBlock("Cashier", receitModel.cashier),
                  _buildInfoBlock("Terminal", "pos 1", crossAxisAlignment: pw.CrossAxisAlignment.end),
                ],
              ),
              pw.SizedBox(height: 16),

              // ── Items Table Header ──
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(flex: 3, child: _colHeader("Item")),
                    pw.Expanded(flex: 1, child: _colHeader("Qty", align: pw.TextAlign.center)),
                    pw.Expanded(flex: 2, child: _colHeader("Price", align: pw.TextAlign.right)),
                    pw.Expanded(flex: 2, child: _colHeader("Total", align: pw.TextAlign.right)),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),

              // ── Items List ──
              ...receitModel.items.map((e) {
                double totalPrice = (e.price + e.addenum) * e.count;
                if (e.discountId != null && e.discountId!.isNotEmpty) {
                  if (e.percentageDiscount) {
                    totalPrice = totalPrice * (1 - e.discount / 100);
                  } else {
                    totalPrice = totalPrice - e.discount;
                  }
                }
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              e.name,
                              style: pw.TextStyle(
                                fontSize: 10, 
                                fontWeight: pw.FontWeight.bold,
                                color: e.refunded ? PdfColors.red700 : PdfColors.black,
                                decoration: e.refunded ? pw.TextDecoration.lineThrough : pw.TextDecoration.none,
                              ),
                            ),
                            if (e.refunded)
                              pw.Text(
                                "(Refunded ${e.originalCount} -> ${e.count})",
                                style: const pw.TextStyle(fontSize: 8, color: PdfColors.red700),
                              ),
                            if (e.addenum > 0)
                              pw.Text(
                                "Addon: ${CurrenceConverter.getCurrenceFloatInStrings(e.addenum, baseCurrence)}",
                                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                              ),
                            if (e.discountId != null && e.discountId!.isNotEmpty)
                              pw.Text(
                                "Discount: ${e.percentageDiscount ? '${e.discount}%' : CurrenceConverter.getCurrenceFloatInStrings(e.discount, baseCurrence)}",
                                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                              ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          e.count.toString(),
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          CurrenceConverter.getCurrenceFloatk(e.price, baseCurrence),
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          CurrenceConverter.getCurrenceFloatk(totalPrice, baseCurrence),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              pw.SizedBox(height: 16),

              // ── Summary ──
              _summaryRow("Subtotal", CurrenceConverter.getCurrenceFloatInStrings(receitModel.total - receitModel.tax, baseCurrence)),
              
              if (receitModel.discounts.isNotEmpty) ...[
                ...receitModel.discounts.map(
                  (e) => _summaryRow(
                    e.name ?? "Discount",
                    (e.percentageDiscount == true)
                        ? "-${e.discount}%"
                        : "-${CurrenceConverter.getCurrenceFloatInStrings(e.discount ?? 0, baseCurrence)}",
                  ),
                ),
              ],
              
              _summaryRow("Taxes", CurrenceConverter.getCurrenceFloatInStrings(receitModel.tax, baseCurrence)),
              
              if (receitModel.miniTax.isNotEmpty) ...[
                ...receitModel.miniTax.map(
                  (e) => _summaryRow(e.label, "${e.value}%"),
                ),
              ],
              
              pw.SizedBox(height: 4),
              pw.Divider(color: PdfColors.grey400, thickness: 1),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total${receitModel.creditSale ? ' (Credit)' : ''}", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text(CurrenceConverter.getCurrenceFloatInStrings(receitModel.total, baseCurrence), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 8),
              _summaryRow("Paid (${receitModel.payment})", CurrenceConverter.getCurrenceFloatInStrings(receitModel.amount, baseCurrence)),
              
              if (!receitModel.creditSale) ...[
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Change", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
                    pw.Text(CurrenceConverter.getCurrenceFloatInStrings(receitModel.amount - receitModel.total, baseCurrence), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
                  ],
                ),
              ],
              pw.SizedBox(height: 16),
              
              // ── Footer ──
              pw.Text("Powered by MistPOS", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildInfoBlock(String label, String value, {pw.CrossAxisAlignment crossAxisAlignment = pw.CrossAxisAlignment.start}) {
    return pw.Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
        pw.SizedBox(height: 2),
        pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _colHeader(String label, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Text(
      label,
      textAlign: align,
      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
    );
  }

  static pw.Widget _summaryRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
