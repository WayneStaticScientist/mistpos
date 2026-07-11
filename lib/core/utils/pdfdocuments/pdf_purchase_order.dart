import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/purchase_order_model.dart';
import 'package:mistpos/data/models/supplier_model.dart';
import 'package:mistpos/data/models/inv_item.dart';

class PdfPurchaseOrder {
  static Future<pw.Document> generate({
    required PurchaseOrderModel model,
    required SupplierModel? supplier,
    required String baseCurrency,
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

    // Calculations
    final totalQtyOrdered = model.inventoryItems.fold(0.0, (prev, current) => prev + current.quantity);
    final totalQtyReceived = model.inventoryItems.fold(0.0, (prev, current) => prev + current.counted);
    final totalProductAmount = model.inventoryItems.fold(0.0, (prev, current) => prev + current.amount);

    final statusColor = model.status.toLowerCase() == "accepted"
        ? PdfColors.green900
        : (model.status.toLowerCase() == "pending"
            ? PdfColors.amber900
            : (model.status.toLowerCase() == "declined" ? PdfColors.red900 : PdfColors.grey700));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header with Logo
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      user?.companyName ?? "MistPOS Store",
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text("PURCHASE ORDER REPORT", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                if (logoImage != null)
                  pw.Image(logoImage, width: 50, height: 50)
                else
                  pw.SizedBox(width: 50, height: 50),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 12),

            // Metadata section
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildMetaRow("Order Label:", model.label.isEmpty || model.label == '-' ? "Purchase Order" : model.label),
                      _buildMetaRow("Status:", model.status.toUpperCase(), valueColor: statusColor),
                      _buildMetaRow("Date Created:", MistDateUtils.formatNormalDate(model.createdAt)),
                      _buildMetaRow("Expected Delivery:", MistDateUtils.formatNormalDate(model.expectedDate)),
                      if (model.notes.isNotEmpty)
                        _buildMetaRow("Notes:", model.notes),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (supplier != null) ...[
                        pw.Text("SUPPLIER DETAILS", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                        pw.SizedBox(height: 4),
                        pw.Text(supplier.name, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        if (supplier.email != null && supplier.email!.isNotEmpty)
                          pw.Text("Email: ${supplier.email}", style: const pw.TextStyle(fontSize: 9)),
                        if (supplier.address1 != null && supplier.address1!.isNotEmpty)
                          pw.Text("Address: ${supplier.address1}", style: const pw.TextStyle(fontSize: 9)),
                        if (supplier.city != null || supplier.country != null)
                          pw.Text("Location: ${supplier.city ?? ''}, ${supplier.country ?? ''}", style: const pw.TextStyle(fontSize: 9)),
                      ] else ...[
                        _buildMetaRow("Supplier ID:", model.sellerId),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 16),

            // Summary section
            pw.Text("Summary Statistics", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox("Ordered Items", "${model.inventoryItems.length}"),
                _buildStatBox("Total Qty (Ordered / Recv)", "${totalQtyOrdered.toInt()} / ${totalQtyReceived.toInt()}"),
                _buildStatBox("Total PO Cost", CurrenceConverter.getCurrenceFloatInStrings(totalProductAmount, baseCurrency), valueColor: PdfColors.blue800),
              ],
            ),
            pw.SizedBox(height: 24),

            // Table section
            pw.Text("Ordered Products List", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildItemsTable(model.inventoryItems, baseCurrency),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildMetaRow(String label, String value, {PdfColor? valueColor}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
          children: [
            pw.TextSpan(text: "$label ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TextSpan(text: value, style: valueColor != null ? pw.TextStyle(color: valueColor, fontWeight: pw.FontWeight.bold) : null),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildStatBox(String title, String value, {PdfColor? valueColor}) {
    return pw.Container(
      width: 160,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(List<InvItem> items, String baseCurrency) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.8),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            _tableCell('Product Name', isHeader: true),
            _tableCell('Qty Ordered', isHeader: true),
            _tableCell('Qty Received', isHeader: true),
            _tableCell('Cost Price', isHeader: true),
            _tableCell('Total Amount', isHeader: true),
          ],
        ),
        // Rows
        ...items.map((e) {
          return pw.TableRow(
            children: [
              _tableCell(e.name),
              _tableCell(e.quantity.toString()),
              _tableCell(e.counted.toString()),
              _tableCell(CurrenceConverter.getCurrenceFloatInStrings(e.cost, baseCurrency)),
              _tableCell(CurrenceConverter.getCurrenceFloatInStrings(e.amount, baseCurrency)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _tableCell(String text, {bool isHeader = false, PdfColor? valueColor, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: (isHeader || isBold) ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: valueColor ?? PdfColors.black,
        ),
      ),
    );
  }
}
