import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/inputs/input_form.dart';
import 'package:mistpos/data/models/inventory_count_model.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/data/models/inventory_child_count.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_inventory_count.dart';
import 'package:mistpos/core/utils/date_utils.dart';

class ScreenInventoryCount extends StatefulWidget {
  final InventoryCountModel model;
  const ScreenInventoryCount({super.key, required this.model});

  @override
  State<ScreenInventoryCount> createState() => _ScreenInventoryCountState();
}

// The correct callback signature for onPopInvokedWithResult

class _ScreenInventoryCountState extends State<ScreenInventoryCount> {
  bool _isLoading = false;
  final _inventory = Get.find<InventoryController>();
  final _itemController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();

  void _printDocument() async {
    Toaster.showSuccess("Preparing document, please wait...");
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    
    final tempModel = InventoryCountModel(
      id: widget.model.id,
      notes: widget.model.notes,
      status: widget.model.status,
      company: widget.model.company,
      senderId: widget.model.senderId,
      totalDifference: _inventory.inventoryCountItems
          .map((e) => e.difference)
          .fold(0.0, (val, el) => val + el),
      countBasedOn: widget.model.countBasedOn,
      inventoryItems: List<InventoryChildCount>.from(_inventory.inventoryCountItems),
      totalCostDifference: _inventory.inventoryCountItems
          .map((e) => e.costDifference)
          .fold(0.0, (val, el) => val + el),
      createdAt: widget.model.createdAt,
      updatedAt: widget.model.updatedAt,
      label: widget.model.label,
    );

    try {
      final pdf = await PdfInventoryCount.generate(
        model: tempModel,
        baseCurrency: baseCurrency,
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Inventory_Count_Report.pdf',
      );
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _inventory.loadInventoryCountItems(
        widget.model.countBasedOn,
        widget.model.inventoryItems.map((e) => e.id).toList(),
      );
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text(
            'Are you sure you want to discard changes and exit?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('STAY'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('EXIT'),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final shouldExit = await _onWillPop(context);
        if (shouldExit) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: "Inventory Count".text(),
          backgroundColor: Get.theme.colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.print, color: Colors.white),
              onPressed: _printDocument,
              tooltip: "Print to PDF",
            ),
            MistLoadIconButton(
              label: "Complete",
              onPressed: () => _confirmComplete(),
              isLoading: _isLoading,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            _buildHeaderCard(isDark),
            20.gapHeight,
            _buildMetricsGrid(isDark),
            20.gapHeight,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Stock Items".text(
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        final count = _inventory.inventoryCountItems.length;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: "$count items".text(
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  Obx(
                    () => MistLoader1().visibleIf(
                      _inventory.inventoryCountsLoading.value,
                    ),
                  ),
                  12.gapHeight,
                  Obx(
                    () => "There was error fetching items : ${_inventory.inventoryCountItemsError.value}"
                        .text(style: const TextStyle(color: Colors.red))
                        .visibleIf(
                          _inventory.inventoryCountItemsError.isNotEmpty,
                        ),
                  ),
                  Obx(
                    () => _makeTable().visibleIf(
                      _inventory.inventoryCountItemsError.isEmpty &&
                          !_inventory.inventoryCountsLoading.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber[800]!.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_note_rounded, color: Colors.amber[800]!, size: 16),
                    6.gapWidth,
                    "Drafting".text(
                      style: TextStyle(
                        color: Colors.amber[800]!,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.inventory_rounded,
                size: 20,
                color: Get.theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          16.gapHeight,
          widget.model.label.text(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          16.gapHeight,
          Divider(
            color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
            height: 1,
          ),
          16.gapHeight,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Created".text(
                      style: TextStyle(
                        fontSize: 11,
                        color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.gapHeight,
                    MistDateUtils.getInformalDate(widget.model.createdAt!).text(
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Based On".text(
                      style: TextStyle(
                        fontSize: 11,
                        color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.gapHeight,
                    widget.model.countBasedOn.toUpperCase().text(
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(bool isDark) {
    final costDiff = widget.model.totalCostDifference;
    final costColor = costDiff >= 0 ? Colors.green : Colors.red;
    final costBgColor = costColor.withValues(alpha: isDark ? 0.12 : 0.06);

    final itemDiff = widget.model.totalDifference;
    final itemColor = itemDiff >= 0 ? Colors.green : Colors.red;
    final itemBgColor = itemColor.withValues(alpha: isDark ? 0.12 : 0.06);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 16) / 2;
        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              height: 100,
              child: _buildMetricCard(
                title: "Cost Difference",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  costDiff,
                  _userController.user.value?.baseCurrence ?? '',
                ),
                icon: Bx.dollar,
                color: costColor,
                bgColor: costBgColor,
              ),
            ),
            16.gapWidth,
            SizedBox(
              width: cardWidth,
              height: 100,
              child: _buildMetricCard(
                title: "Item Difference",
                value: itemDiff > 0 ? "+$itemDiff" : "$itemDiff",
                icon: Bx.adjust,
                color: itemColor,
                bgColor: itemBgColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: title.text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              8.gapWidth,
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Iconify(icon, color: color, size: 16),
              ),
            ],
          ),
          value.text(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _save() async {
    Get.back();
    setState(() {
      _isLoading = true;
    });
    widget.model.inventoryItems = _inventory.inventoryCountItems;
    
    // Recalculate totals to ensure they are accurately saved to backend
    widget.model.totalDifference = _inventory.inventoryCountItems
        .map((e) => e.difference)
        .fold(0.0, (val, el) => val + el);
    widget.model.totalCostDifference = _inventory.inventoryCountItems
        .map((e) => e.costDifference)
        .fold(0.0, (val, el) => val + el);

    final response = await _inventory.updateInventoryCounts(
      widget.model.toJson(),
      widget.model.id,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (response) {
      _itemController.syncCartItemsOnBackground(page: 1);
      widget.model.status = "completed";
      Get.back(result: widget.model);
      Toaster.showSuccess("Inventory Count was completed successfully");
      return;
    }
  }

  Widget _makeTable() {
    final isDark = Get.isDarkMode;
    final rowBgColor = WidgetStateProperty.resolveWith<Color?>((states) {
      return null;
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: ScreenSizes.maxWidth - 64),
          child: DataTable(
            columnSpacing: 16,
            horizontalMargin: 16,
            headingRowColor: WidgetStateProperty.all(
              Get.theme.colorScheme.primary.withValues(alpha: 0.06),
            ),
            dataRowColor: rowBgColor,
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
              fontSize: 13,
            ),
            columns: const [
              DataColumn(label: Text('Item Name')),
              DataColumn(label: Text('Expected')),
              DataColumn(label: Text('Counted')),
              DataColumn(label: Text('Diff')),
              DataColumn(label: Text('Cost'), numeric: true),
              DataColumn(label: Text('Cost Diff'), numeric: true),
            ],
            rows: _inventory.inventoryCountItems
                .map(
                  (e) {
                    final diffColor = e.difference == 0
                        ? Get.theme.colorScheme.onSurface
                        : (e.difference > 0 ? Colors.green : Colors.red);
                    
                    final costDiffColor = e.costDifference == 0
                        ? Get.theme.colorScheme.onSurface
                        : (e.costDifference > 0 ? Colors.green : Colors.red);

                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          e.name.text(
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(e.count.toString().text()),
                        DataCell(
                          InkWell(
                            onTap: () => _changeCount(e),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Get.theme.colorScheme.primary.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  e.counted.toString().text(
                                    style: TextStyle(
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  6.gapWidth,
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          (e.difference > 0 ? "+${e.difference}" : "${e.difference}").text(
                            style: TextStyle(color: diffColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          CurrenceConverter.getCurrenceFloatInStrings(
                            e.cost,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(),
                        ),
                        DataCell(
                          CurrenceConverter.getCurrenceFloatInStrings(
                            e.costDifference,
                            _userController.user.value?.baseCurrence ?? '',
                          ).text(
                            style: TextStyle(color: costDiffColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _changeCount(InventoryChildCount itemInv) {
    final countedController = TextEditingController(
      text: itemInv.counted.toString(),
    );

    Get.defaultDialog(
      title: itemInv.name,
      content: [
        MistFormInput(label: "Counted", controller: countedController),
      ].column(mainAxisSize: MainAxisSize.min),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'update'.text().textButton(
          onPressed: () {
            try {
              double quantity = double.parse(countedController.text);
              if (quantity < 0) {
                Toaster.showError("Error | number shouldnt be less than 0");
                return;
              }
              _calculateQuantity(quantity, itemInv);
              Get.back();
            } catch (e) {
              Toaster.showError(e.toString());
            }
          },
        ),
      ],
    );
  }

  void _calculateQuantity(double quantity, InventoryChildCount itemInv) {
    int index = _inventory.inventoryCountItems.indexWhere(
      (e) => e.id == itemInv.id,
    );
    if (index == -1) {
      Toaster.showError("Item not found");
      return;
    }
    itemInv.counted = quantity;
    itemInv.difference = quantity - itemInv.count;
    itemInv.costDifference = (itemInv.difference * itemInv.cost);
    _inventory.inventoryCountItems[index] = itemInv;
    widget.model.totalDifference = _inventory.inventoryCountItems
        .map((e) => e.difference)
        .fold(0, (value, element) => value + element);
    widget.model.totalCostDifference = _inventory.inventoryCountItems
        .map((e) => e.costDifference)
        .fold(0.0, (value, element) => value + element);
    setState(() {});
  }

  void _confirmComplete() {
    Get.defaultDialog(
      title: "Are You sure?",
      content: Text(
        "Marking this as completed will update all products and its irreversible",
      ),
      confirm: "Yes".text().textButton(onPressed: () => _save()),
      cancel: "No".text().textButton(onPressed: () => Get.back()),
    );
  }
}
