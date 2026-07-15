import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class NavProductImportExport extends StatefulWidget {
  const NavProductImportExport({super.key});

  @override
  State<NavProductImportExport> createState() =>
      _NavProductImportExportState();
}

class _NavProductImportExportState extends State<NavProductImportExport> {
  final _itemsController = Get.find<ItemsController>();
  bool _replaceOnConflict = true;
  bool _isImporting = false;
  bool _isDownloading = false;
  bool _isExporting = false;
  int? _lastInserted;
  int? _lastUpdated;
  int? _lastSkipped;
  List<String> _lastErrors = [];

  // The expected column headers for the import template
  static const List<String> _templateHeaders = [
    'Product Name',
    'Price',
    'Cost',
    'Stock Quantity',
    'Barcode',
    'SKU',
    'Category',
    'Sold By',
    'Track Stock',
    'Low Stock Threshold',
  ];

  Future<void> _downloadTemplate() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final excel = Excel.createExcel();
      excel.rename('Sheet1', 'Products Template');
      final sheet = excel['Products Template'];

      // Style the header row
      for (var i = 0; i < _templateHeaders.length; i++) {
        final cell = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(_templateHeaders[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.fromHexString('#193452'),
          fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        );
      }

      // Add an example row
      final exampleValues = [
        'Example Product',
        '9.99',
        '5.00',
        '100',
        '123456789',
        'SKU-001',
        'Electronics',
        'unit',
        'true',
        '10',
      ];
      for (var i = 0; i < exampleValues.length; i++) {
        final cell = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1));
        cell.value = TextCellValue(exampleValues[i]);
      }

      // Set column widths
      sheet.setDefaultColumnWidth(22);

      final bytes = excel.encode();
      if (bytes == null) {
        Toaster.showError('Failed to generate template');
        return;
      }

      final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

      if (isMobile) {
        // On mobile: save to Documents directory and open it
        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            '${dir.path}/MistPOS_Product_Template.xlsx';
        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);
        
        final xFile = XFile(filePath, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        await Share.shareXFiles([xFile], text: 'MistPOS Product Import Template');
        Toaster.showSuccess('Template ready to share or save!');
      } else {
        // On desktop (Windows/macOS/Linux): show save dialog
        final savePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Product Import Template',
          fileName: 'MistPOS_Product_Template.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
          bytes: Uint8List.fromList(bytes),
        );
        if (savePath != null && !Platform.isWindows && !Platform.isMacOS) {
          // On Linux filePicker may not write automatically
          final file = File(savePath);
          await file.writeAsBytes(bytes, flush: true);
        }
        if (savePath != null) {
          Toaster.showSuccess('Template saved to: $savePath');
        }
      }
    } catch (e) {
      Toaster.showError('Failed to export template: $e');
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _exportAllProducts() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final items = _itemsController.cartItems;
      if (items.isEmpty) {
        Toaster.showError('No products found to export.');
        setState(() => _isExporting = false);
        return;
      }

      final excel = Excel.createExcel();
      excel.rename('Sheet1', 'Products Export');
      final sheet = excel['Products Export'];

      // Style the header row
      for (var i = 0; i < _templateHeaders.length; i++) {
        final cell = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(_templateHeaders[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.fromHexString('#193452'),
          fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        );
      }

      // Add product rows
      for (var rowIndex = 0; rowIndex < items.length; rowIndex++) {
        final item = items[rowIndex];
        final rowValues = [
          item.name,
          item.price.toStringAsFixed(2),
          item.cost.toStringAsFixed(2),
          item.stockQuantity.toString(),
          item.barcode,
          item.sku,
          item.category,
          item.soldBy,
          item.trackStock.toString(),
          item.lowStockThreshold.toString(),
        ];
        
        for (var colIndex = 0; colIndex < rowValues.length; colIndex++) {
          final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex + 1));
          cell.value = TextCellValue(rowValues[colIndex]);
        }
      }

      sheet.setDefaultColumnWidth(22);

      final bytes = excel.encode();
      if (bytes == null) {
        Toaster.showError('Failed to generate export file');
        return;
      }

      final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

      if (isMobile) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/MistPOS_Products_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);
        
        final xFile = XFile(filePath, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        await Share.shareXFiles([xFile], text: 'MistPOS Products Export');
        Toaster.showSuccess('Export ready to share or save!');
      } else {
        final savePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Products Export',
          fileName: 'MistPOS_Products_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
          bytes: Uint8List.fromList(bytes),
        );
        if (savePath != null && !Platform.isWindows && !Platform.isMacOS) {
          final file = File(savePath);
          await file.writeAsBytes(bytes, flush: true);
        }
        if (savePath != null) {
          Toaster.showSuccess('Export saved to: $savePath');
        }
      }
    } catch (e) {
      Toaster.showError('Failed to export products: $e');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _importFromExcel() async {
    if (_isImporting) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final fileBytes = result.files.first.bytes;
    if (fileBytes == null) {
      Toaster.showError('Could not read the file');
      return;
    }

    setState(() => _isImporting = true);

    try {
      final excel = Excel.decodeBytes(fileBytes);
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];

      if (sheet == null || sheet.rows.isEmpty) {
        Toaster.showError('The file is empty');
        setState(() => _isImporting = false);
        return;
      }

      // Detect header row and column mappings
      final headerRow = sheet.rows.first;
      final Map<String, int> columnMap = {};
      for (var i = 0; i < headerRow.length; i++) {
        final header = headerRow[i]?.value?.toString().trim().toLowerCase();
        if (header != null) {
          columnMap[header] = i;
        }
      }

      // Helper: get cell value from a row by a header alias list
      String? getCell(List<Data?> row, List<String> aliases) {
        for (final alias in aliases) {
          final idx = columnMap[alias.toLowerCase()];
          if (idx != null && idx < row.length) {
            final v = row[idx]?.value;
            if (v != null) return v.toString().trim();
          }
        }
        return null;
      }

      final List<Map<String, dynamic>> products = [];

      for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        final name = getCell(row, ['product name', 'name', 'item name', 'item']);
        if (name == null || name.isEmpty) continue;

        final price = double.tryParse(
                getCell(row, ['price', 'selling price', 'sale price']) ?? '') ??
            0.0;
        final cost = double.tryParse(
                getCell(row, ['cost', 'cost price', 'purchase price']) ?? '') ??
            0.0;
        final qty = double.tryParse(
                getCell(row, ['stock quantity', 'quantity', 'stock', 'qty']) ??
                    '') ??
            0.0;
        final barcode =
            getCell(row, ['barcode', 'bar code', 'upc', 'ean']) ?? '';
        final sku = getCell(row, ['sku', 'stock keeping unit']) ?? '';
        final category = getCell(row, ['category', 'cat']) ?? '';
        final soldBy =
            getCell(row, ['sold by', 'unit type', 'unit']) ?? 'unit';
        final trackStockStr =
            getCell(row, ['track stock', 'track inventory', 'track'])
                    ?.toLowerCase() ??
                'true';
        final trackStock = trackStockStr == 'true' || trackStockStr == 'yes' || trackStockStr == '1';
        final lowStockThreshold = double.tryParse(
                getCell(row, [
                      'low stock threshold',
                      'low stock',
                      'reorder point'
                    ]) ??
                    '') ??
            0.0;

        products.add({
          'name': name,
          'price': price,
          'cost': cost,
          'stockQuantity': qty,
          'barcode': barcode,
          'sku': sku,
          'category': category,
          'soldBy': soldBy,
          'trackStock': trackStock,
          'lowStockThreshold': lowStockThreshold,
        });
      }

      if (products.isEmpty) {
        Toaster.showError('No valid product rows found in the file');
        setState(() => _isImporting = false);
        return;
      }

      // Send to backend
      final response = await Net.post(
        '/admin/products/bulk-import',
        data: {
          'products': products,
          'replaceOnConflict': _replaceOnConflict,
        },
      );

      setState(() => _isImporting = false);

      if (response.hasError) {
        Toaster.showError(response.response);
        return;
      }

      final inserted = response.body['inserted'] as int? ?? 0;
      final updated = response.body['updated'] as int? ?? 0;
      final skipped = response.body['skipped'] as int? ?? 0;
      final errors =
          (response.body['errors'] as List<dynamic>? ?? []).cast<String>();

      setState(() {
        _lastInserted = inserted;
        _lastUpdated = updated;
        _lastSkipped = skipped;
        _lastErrors = errors;
      });

      // Trigger background sync so local Isar DB updates
      _itemsController.syncCartItemsOnBackground();
      Toaster.showSuccess('Import complete! $inserted added, $updated updated');
    } catch (e) {
      setState(() => _isImporting = false);
      String errorMessage = e.toString();
      if (errorMessage.contains('custom numFmtId starts at 164')) {
        errorMessage =
            'Formatting Error: Your Excel file contains unsupported custom number formats (like currency or dates). Please open the file, select all cells, change the format to "Plain Text" or "General", and save. Alternatively, copy your data and "Paste Values Only" into a fresh spreadsheet.';
      } else {
        errorMessage = 'Failed to parse file: $e';
      }
      Toaster.showError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = isDark ? const Color(0xFF0F1117) : Colors.white;
    final cardColor =
        isDark ? const Color(0xFF16181F) : const Color(0xFFF8F9FB);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───
          _buildPageHeader(isDark, primary),
          const SizedBox(height: 24),

          // ─── Export Template Card ───
          _buildSectionCard(
            isDark: isDark,
            surface: surface,
            cardColor: cardColor,
            primary: primary,
            icon: Icons.download_rounded,
            iconColor: Colors.green,
            title: 'Download Import Template',
            subtitle:
                'Get the official Excel template with the correct column headings. Fill it in and import it below.',
            child: _buildTemplateColumns(isDark, primary),
            action: _isDownloading
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600.withAlpha(50),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green.shade600)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Downloading...',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: _downloadTemplate,
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Download Template (.xlsx)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 20),

          // ─── Import Card ───
          _buildSectionCard(
            isDark: isDark,
            surface: surface,
            cardColor: cardColor,
            primary: primary,
            icon: Icons.upload_file_rounded,
            iconColor: primary,
            title: 'Import Products from Excel',
            subtitle:
                'Select your filled .xlsx or .xls file. The importer accepts flexible column names.',
            child: _buildConflictOption(isDark, primary),
            action: _isImporting
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primary)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Importing...',
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: _importFromExcel,
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text('Select File & Import'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 20),

          // ─── Export Card ───
          _buildSectionCard(
            isDark: isDark,
            surface: surface,
            cardColor: cardColor,
            primary: primary,
            icon: Icons.file_download_rounded,
            iconColor: Colors.blue.shade600,
            title: 'Export All Products',
            subtitle:
                'Download a complete list of your products in an Excel file. This file can be edited and re-imported later.',
            child: const SizedBox.shrink(),
            action: _isExporting
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600.withAlpha(50),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue.shade600)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Exporting...',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: _exportAllProducts,
                    icon: const Icon(Icons.file_download_rounded, size: 18),
                    label: const Text('Export All Products'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

          // ─── Results Card ───
          if (_lastInserted != null) ...[
            const SizedBox(height: 20),
            _buildResultsCard(isDark, primary, cardColor),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPageHeader(bool isDark, Color primary) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withAlpha(180)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.table_chart_rounded,
              color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bulk Product Import & Export',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Export all your products, or import hundreds of products at once.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.05, end: 0);
  }

  Widget _buildSectionCard({
    required bool isDark,
    required Color surface,
    required Color cardColor,
    required Color primary,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
    required Widget action,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? Colors.white54 : Colors.black45,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 20),
          action,
        ],
      ),
    );
  }

  Widget _buildTemplateColumns(bool isDark, Color primary) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _templateHeaders.map((header) {
        final isRequired = ['Product Name', 'Price', 'Cost'].contains(header);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isRequired
                ? primary.withAlpha(25)
                : (isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(6)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isRequired ? primary.withAlpha(80) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRequired)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                header,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isRequired ? FontWeight.w600 : FontWeight.w500,
                  color: isRequired
                      ? primary
                      : (isDark ? Colors.white70 : Colors.black54),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConflictOption(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conflict Resolution',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'When a product with the same name, barcode, or SKU already exists:',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 12),
          _buildConflictRadio(
            isDark: isDark,
            primary: primary,
            value: true,
            label: 'Replace on Conflict',
            description: 'Update the existing product with the new data',
            icon: Icons.sync_rounded,
            iconColor: Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildConflictRadio(
            isDark: isDark,
            primary: primary,
            value: false,
            label: 'Append Only',
            description: 'Skip products that already exist, only add new ones',
            icon: Icons.add_circle_outline_rounded,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildConflictRadio({
    required bool isDark,
    required Color primary,
    required bool value,
    required String label,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _replaceOnConflict == value;
    return GestureDetector(
      onTap: () => setState(() => _replaceOnConflict = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? primary.withAlpha(100)
                : (isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.black.withAlpha(10)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primary : iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? primary
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.withAlpha(100),
                  width: 2,
                ),
                color: isSelected ? primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(bool isDark, Color primary, Color cardColor) {
    final hasErrors = _lastErrors.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1117) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: Colors.teal, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                'Import Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildStatChip(
                  label: 'Added',
                  value: _lastInserted ?? 0,
                  color: Colors.green),
              const SizedBox(width: 10),
              _buildStatChip(
                  label: 'Updated',
                  value: _lastUpdated ?? 0,
                  color: Colors.orange),
              const SizedBox(width: 10),
              _buildStatChip(
                  label: 'Skipped',
                  value: _lastSkipped ?? 0,
                  color: Colors.grey),
            ],
          ),
          if (hasErrors) ...[
            const SizedBox(height: 16),
            Text(
              'Errors (${_lastErrors.length})',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withAlpha(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _lastErrors
                    .take(5)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12)),
                            Expanded(
                              child: Text(
                                e,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildStatChip({
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
