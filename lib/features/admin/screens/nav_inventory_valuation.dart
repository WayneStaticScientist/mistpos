import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/product_stats_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_inv_evaluation.dart';

class NavInventoryValuation extends StatefulWidget {
  const NavInventoryValuation({super.key});

  @override
  State<NavInventoryValuation> createState() => NavInventoryValuationState();
}

class NavInventoryValuationState extends State<NavInventoryValuation> {
  final _userController = Get.find<UserController>();
  final _inventoryController = Get.find<InventoryController>();
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inventoryController.loadInventoryValuation(
        start: _startDate,
        end: _endDate,
      );
      if (_inventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventoryController
                    .company
                    .value!
                    .subscriptionType
                    .validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _inventoryController.loadInventoryProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_inventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventoryController
                    .company
                    .value!
                    .subscriptionType
                    .validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SingleChildScrollView(
        child: [
          14.gapHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              [
                Iconify(Bx.calendar, color: AppTheme.color(context)),
                8.gapWidth,
                (_startDate == null || _endDate == null)
                    ? "All Time".text(style: const TextStyle(fontWeight: FontWeight.bold))
                    : "From ${MistDateUtils.getInformalShortDate(_startDate!)} - ${(DateUtils.isSameDay(_endDate!, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(_endDate!))}"
                        .text(),
                if (_startDate != null) ...[
                  8.gapWidth,
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                      });
                      _inventoryController.loadInventoryValuation(
                        start: null,
                        end: null,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: Colors.red),
                    ),
                  ),
                ]
              ].row().onTap(_changeDateRange),
              IconButton(
                icon: const Icon(Icons.print, color: Colors.blue),
                tooltip: "Print Analytics Report",
                onPressed: printDocument,
              ),
            ],
          ),
          "Tap on the date icon to change date ranges".text(
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          Obx(() {
            if (_inventoryController.loadingInventoryValuation.value) {
              return MistLoader1();
            }
            if (_inventoryController.statsPoducts.value == null) {
              return "No value for that specified time".text();
            }
            return _makeSummary(_inventoryController.statsPoducts.value!);
          }),
          18.gapHeight,

          Obx(() {
            if (_inventoryController.loadingInventoryProducts.value) {
              return MistLoader1();
            }
            if (_inventoryController.inventoryProducts.isEmpty) {
              return "No products found".text();
            }

            return Column(
              children: [
                _makeTable(_inventoryController.inventoryProducts),
                16.gapHeight,
                _buildPagination(
                  currentPage: _inventoryController.inventoryProductsPage.value,
                  totalPages: _inventoryController.inventoryProductsTotalPages.value,
                  onPageChanged: (page) {
                    _inventoryController.loadInventoryProducts(page: page);
                  },
                ),
              ],
            );
          }),
        ].column(),
      );
    });
  }

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required Function(int) onPageChanged,
  }) {
    // Show pagination UI even if there's only 1 page so it's visibly clear it exists
    final effectiveTotalPages = totalPages > 0 ? totalPages : 1;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          Text('Page $currentPage of $effectiveTotalPages', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < effectiveTotalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      _endDate = date.end;
      _startDate = date.start;
    });
    _inventoryController.loadInventoryValuation(
      start: _startDate,
      end: _endDate,
    );
  }

  Widget _makeSummary(StatsProductModel statsProductModel) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
        final marginValue = statsProductModel.totalRevenue > 0 
            ? ((statsProductModel.totalCost / statsProductModel.totalRevenue) * 100).toStringAsFixed(0) 
            : '0';

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: constraints.maxWidth > 600 ? 2.5 : 3.0,
          children: [
            _buildSummaryCard(
              "Total Inventory Value",
              CurrenceConverter.getCurrenceFloatInStrings(statsProductModel.totalCost, currency),
              Bx.package,
              Colors.blue,
            ),
            _buildSummaryCard(
              "Total Retail Value",
              CurrenceConverter.getCurrenceFloatInStrings(statsProductModel.totalRevenue, currency),
              Bx.store,
              Colors.purple,
            ),
            _buildSummaryCard(
              "Potential Profit",
              CurrenceConverter.getCurrenceFloatInStrings(statsProductModel.totalRevenue - statsProductModel.totalCost, currency),
              Bx.trending_up,
              Colors.green,
            ),
            _buildSummaryCard(
              "Margin",
              "$marginValue%",
              Bx.pie_chart_alt_2,
              Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, String icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Iconify(icon, color: color, size: 28),
          ),
          16.gapWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.gapHeight,
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeTable(RxList<ItemModel> inventoryProducts) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Iconify(Bx.box, color: AppTheme.color(context)),
                12.gapWidth,
                "Inventory Products".text(
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.3),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          SizedBox(
            height: 600,
            child: DataTable2(
              headingRowColor: WidgetStateProperty.resolveWith((states) => AppTheme.surface(context).withAlpha(100)),
              dataRowHeight: 65,
              headingRowHeight: 50,
              horizontalMargin: 24,
              minWidth: 900,
              dividerThickness: 0,
              columns: const [
                DataColumn2(label: Text('Product Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)), size: ColumnSize.L),
                DataColumn2(label: Text('In Stock', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                DataColumn2(label: Text('Avg. Cost', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                DataColumn2(label: Text('Retail Price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                DataColumn2(label: Text('Pot. Profit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                DataColumn2(label: Text('Margin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              ],
              rows: inventoryProducts.map((e) {
                final effectiveQty = ((e.isCompositeItem && !e.useProduction && e.trackStock) || (!e.trackStock)) ? 1 : e.stockQuantity;
                final costStr = CurrenceConverter.getCurrenceFloatInStrings(e.cost * effectiveQty, currency);
                final retailStr = CurrenceConverter.getCurrenceFloatInStrings(e.price * effectiveQty, currency);
                final profitVal = (e.price - e.cost) * effectiveQty;
                final profitStr = CurrenceConverter.getCurrenceFloatInStrings(profitVal, currency);
                final marginStr = "${e.price > 0 ? ((e.cost / e.price) * 100).toStringAsFixed(1) : '0.0'}%";
                
                final bool lowStock = e.stockQuantity <= 10 && e.trackStock;
                
                return DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.blue),
                        ),
                        12.gapWidth,
                        Expanded(
                          child: Text(
                            e.name, 
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.color(context)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: lowStock ? Colors.red.withAlpha(20) : Colors.green.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        e.stockQuantity.toString(), 
                        style: TextStyle(
                          color: lowStock ? Colors.red.shade700 : Colors.green.shade700, 
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(costStr, style: TextStyle(fontWeight: FontWeight.w500, color: AppTheme.color(context)))),
                  DataCell(Text(retailStr, style: TextStyle(fontWeight: FontWeight.w500, color: AppTheme.color(context)))),
                  DataCell(Text(profitStr, style: TextStyle(color: profitVal >= 0 ? Colors.green.shade600 : Colors.red.shade600, fontWeight: FontWeight.bold))),
                  DataCell(Text(marginStr, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    ).sizedBox(width: double.infinity);
  }

  void printDocument() async {
    if (_inventoryController.statsPoducts.value == null) {
      Toaster.showError("Stats hasnt loaded yet | please wait them to load");
      return;
    }
    Toaster.showSuccess("Preparing document, please wait...");
    
    final allProducts = await _inventoryController.getAllInventoryProductsForExport();
    
    if (allProducts.isEmpty && _inventoryController.inventoryProducts.isNotEmpty) {
      Toaster.showError("Failed to fetch products for export.");
      return;
    }
    
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    
    try {
      final pdf = await PdfInvEvaluation.generate(
        endDate: _endDate,
        startDate: _startDate,
        baseCurrence: baseCurrency,
        statsProductModel: _inventoryController.statsPoducts.value!,
        inventoryProducts: allProducts,
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Inventory_Valuation_Report.pdf',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }
}
