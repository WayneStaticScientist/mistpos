import 'dart:typed_data';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/multishop_gigantic_model.dart';

class GiganticOverviewPdf {
  static Future<pw.Document> generate({
    required DateTime? startDate,
    required DateTime endDate,
    required String baseCurrence,
    required GiganticOverview data,
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

    final dateRangeStr = startDate == null
        ? 'All Time (Up to ${MistDateUtils.getInformalShortDate(endDate)})'
        : '${MistDateUtils.getInformalShortDate(startDate)} — ${MistDateUtils.getInformalShortDate(endDate)}';

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
                    pw.Text(
                      user?.companyName ?? "Enterprise",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Gigantic Enterprise Overview",
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.grey700,
                      ),
                    ),
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
                pw.Text(
                  "Report Period: ",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.Text(dateRangeStr, style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 24),

            // Enterprise Totals
            pw.Text(
              "Enterprise Totals",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildTotalsTable(data.totals, baseCurrence),

            pw.SizedBox(height: 24),

            // Top Performing Companies
            pw.Text(
              "Top Performing Companies",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildCompaniesTable(data.companyRankings, baseCurrence),

            pw.SizedBox(height: 24),

            // Employee Performance
            pw.Text(
              "Employee Performance Across Enterprise",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildEmployeesTable(data.employees, baseCurrence),
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildTotalsTable(
    GiganticTotals totals,
    String baseCurrence,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _buildTableCell("Metric", isHeader: true),
            _buildTableCell("Value", isHeader: true, align: pw.TextAlign.right),
          ],
        ),
        _buildTotalsRow(
          "Total Revenue",
          CurrenceConverter.getCurrenceFloatInStrings(
            totals.revenue,
            baseCurrence,
          ),
        ),
        _buildTotalsRow(
          "Gross Profit",
          CurrenceConverter.getCurrenceFloatInStrings(
            totals.grossProfit,
            baseCurrence,
          ),
        ),
        _buildTotalsRow(
          "Net Profit",
          CurrenceConverter.getCurrenceFloatInStrings(
            totals.netProfit,
            baseCurrence,
          ),
        ),
        _buildTotalsRow(
          "Total Expenses",
          CurrenceConverter.getCurrenceFloatInStrings(
            totals.expenses,
            baseCurrence,
          ),
        ),
        _buildTotalsRow(
          "Total Taxes",
          CurrenceConverter.getCurrenceFloatInStrings(
            totals.taxes,
            baseCurrence,
          ),
        ),
        _buildTotalsRow(
          "Total Discounts",
          CurrenceConverter.getCurrenceFloatInStrings(
            totals.discounts,
            baseCurrence,
          ),
        ),
        _buildTotalsRow("Number of Receipts", totals.receipts.toString()),
        _buildTotalsRow("Total Employees", totals.cashiersCount.toString()),
      ],
    );
  }

  static pw.TableRow _buildTotalsRow(String label, String value) {
    return pw.TableRow(
      children: [
        _buildTableCell(label),
        _buildTableCell(value, align: pw.TextAlign.right),
      ],
    );
  }

  static pw.Widget _buildCompaniesTable(
    List<CompanyRanking> rankings,
    String baseCurrence,
  ) {
    if (rankings.isEmpty) {
      return pw.Text(
        "No company data available.",
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            _buildTableCell("Company Name", isHeader: true),
            _buildTableCell(
              "Revenue",
              isHeader: true,
              align: pw.TextAlign.right,
            ),
            _buildTableCell(
              "Profit",
              isHeader: true,
              align: pw.TextAlign.right,
            ),
            _buildTableCell("Score", isHeader: true, align: pw.TextAlign.right),
          ],
        ),
        ...rankings.map((company) {
          return pw.TableRow(
            children: [
              _buildTableCell(company.companyName),
              _buildTableCell(
                CurrenceConverter.getCurrenceFloatInStrings(
                  company.revenue,
                  baseCurrence,
                ),
                align: pw.TextAlign.right,
              ),
              _buildTableCell(
                CurrenceConverter.getCurrenceFloatInStrings(
                  company.profit,
                  baseCurrence,
                ),
                align: pw.TextAlign.right,
              ),
              _buildTableCell(
                CurrenceConverter.getCurrenceFloatInStrings(
                  company.score,
                  baseCurrence,
                ),
                align: pw.TextAlign.right,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildEmployeesTable(
    List<GiganticEmployee> employees,
    String baseCurrence,
  ) {
    if (employees.isEmpty) {
      return pw.Text(
        "No employee data available.",
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1.5),
        4: pw.FlexColumnWidth(1.5),
        5: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _buildTableCell("Employee Name", isHeader: true),
            _buildTableCell("Company", isHeader: true),
            _buildTableCell(
              "Receipts",
              isHeader: true,
              align: pw.TextAlign.right,
            ),
            _buildTableCell(
              "Revenue",
              isHeader: true,
              align: pw.TextAlign.right,
            ),
            _buildTableCell(
              "Profit",
              isHeader: true,
              align: pw.TextAlign.right,
            ),
            _buildTableCell(
              "Shifts",
              isHeader: true,
              align: pw.TextAlign.right,
            ),
          ],
        ),
        ...employees.map((emp) {
          return pw.TableRow(
            children: [
              _buildTableCell(emp.name),
              _buildTableCell(emp.companyName),
              _buildTableCell(
                emp.receipts.toString(),
                align: pw.TextAlign.right,
              ),
              _buildTableCell(
                CurrenceConverter.getCurrenceFloatInStrings(
                  emp.revenue,
                  baseCurrence,
                ),
                align: pw.TextAlign.right,
              ),
              _buildTableCell(
                CurrenceConverter.getCurrenceFloatInStrings(
                  emp.profit,
                  baseCurrence,
                ),
                align: pw.TextAlign.right,
              ),
              _buildTableCell(emp.shifts.toString(), align: pw.TextAlign.right),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 10 : 9,
        ),
      ),
    );
  }
}
