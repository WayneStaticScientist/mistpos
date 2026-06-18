import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/expense_analytics_model.dart';

class PdfExpensesAnalytics {
  static Future<pw.Document> generate({
    required String baseCurrence,
    required ExpenseAnalyticsTotals totals,
    required List<ExpenseCategoryWeight> categories,
    required List<ExpenseEmployeeWeight> employees,
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
                    pw.Text("Expenses Analytics Report",
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

            // KPI Overview
            pw.Text("Expense Highlights",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800)),
            pw.SizedBox(height: 8),
            _buildKpiTable(totals, baseCurrence),
            pw.SizedBox(height: 32),

            // Categories
            pw.Text("Category Breakdown",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.orange800)),
            pw.SizedBox(height: 8),
            _buildCategoriesTable(categories, baseCurrence),
            pw.SizedBox(height: 32),

            // Employees
            pw.Text("Employee Expense Tracking",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green800)),
            pw.SizedBox(height: 8),
            _buildEmployeesTable(employees, baseCurrence),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildKpiTable(ExpenseAnalyticsTotals totals, String baseCurrence) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Period", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Total Expense", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        _buildKpiRow("Today", totals.totalToday, baseCurrence),
        _buildKpiRow("This Month", totals.totalMonth, baseCurrence),
        _buildKpiRow("This Year", totals.totalYear, baseCurrence),
        _buildKpiRow("All Time", totals.totalAllTime, baseCurrence),
      ],
    );
  }

  static pw.TableRow _buildKpiRow(String label, double amount, String baseCurrence) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(label, style: const pw.TextStyle(fontSize: 10))),
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(amount, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
      ],
    );
  }

  static pw.Widget _buildCategoriesTable(List<ExpenseCategoryWeight> list, String baseCurrence) {
    if (list.isEmpty) return pw.Text("No categories found.", style: const pw.TextStyle(color: PdfColors.grey600));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1.5),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.orange50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Category Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Weight (%)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...list.map((e) => pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.name, style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.amount, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('${e.percentage.toStringAsFixed(1)}%', style: const pw.TextStyle(fontSize: 10))),
              ],
            )),
      ],
    );
  }

  static pw.Widget _buildEmployeesTable(List<ExpenseEmployeeWeight> list, String baseCurrence) {
    if (list.isEmpty) return pw.Text("No employees found.", style: const pw.TextStyle(color: PdfColors.grey600));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1.5),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green50),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Employee Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Weight (%)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        ...list.map((e) => pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.name, style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(CurrenceConverter.getCurrenceFloatInStrings(e.amount, baseCurrence), style: const pw.TextStyle(fontSize: 10))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('${e.percentage.toStringAsFixed(1)}%', style: const pw.TextStyle(fontSize: 10))),
              ],
            )),
      ],
    );
  }
}
