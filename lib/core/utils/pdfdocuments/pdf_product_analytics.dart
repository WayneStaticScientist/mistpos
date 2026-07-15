import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/product_analytics_model.dart';

class PdfProductAnalytics {
  static Future<pw.Document> generate({
    required String baseCurrence,
    required List<TopSellerProduct> topSellers,
    required List<LowSellerProduct> lowSellers,
    required List<UnsoldProduct> unsoldProducts,
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
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(user?.companyName ?? "Company Name",
                        style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue800)),
                    pw.SizedBox(height: 4),
                    pw.Text("Product Analytics Report",
                        style: pw.TextStyle(
                            fontSize: 18, color: PdfColors.grey700)),
                    pw.Text("Generated on: ${MistDateUtils.formatNormalDate(DateTime.now())}",
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 60, height: 60),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 24),

            // Top Sellers
            pw.Text("Top Selling Products",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green800)),
            pw.SizedBox(height: 8),
            _buildTopSellersTable(topSellers, baseCurrence),
            pw.SizedBox(height: 32),

            // Low Sellers
            pw.Text("Low Selling Products (< 10 units)",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.orange800)),
            pw.SizedBox(height: 8),
            _buildLowSellersTable(lowSellers, baseCurrence),
            pw.SizedBox(height: 32),

            // Unsold Products
            pw.Text("Unsold Products",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red800)),
            pw.SizedBox(height: 8),
            _buildUnsoldProductsTable(unsoldProducts, baseCurrence),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildTopSellersTable(List<TopSellerProduct> list, String baseCurrence) {
    if (list.isEmpty) return pw.Text("No top sellers found.", style: const pw.TextStyle(color: PdfColors.grey600));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Product Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Qty Sold", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Revenue", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...list.map((e) => pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.name, style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.totalSold.toInt().toString(), style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.revenue, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              ],
            )),
      ],
    );
  }

  static pw.Widget _buildLowSellersTable(List<LowSellerProduct> list, String baseCurrence) {
    if (list.isEmpty) return pw.Text("No low sellers found.", style: const pw.TextStyle(color: PdfColors.grey600));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.orange50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Product Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Qty Sold", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Revenue", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...list.map((e) => pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.name, style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.totalSold.toInt().toString(), style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.revenue, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              ],
            )),
      ],
    );
  }

  static pw.Widget _buildUnsoldProductsTable(List<UnsoldProduct> list, String baseCurrence) {
    if (list.isEmpty) return pw.Text("All products have been sold at least once.", style: const pw.TextStyle(color: PdfColors.grey600));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.red50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Product Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("In Stock", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Price", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...list.map((e) => pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.name, style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.stockQuantity.toString(), style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.price, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
              ],
            )),
      ],
    );
  }
}
