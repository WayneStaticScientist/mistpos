import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/inventory_child_count.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

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
            MistLoadIconButton(
              label: "Complete",
              onPressed: () => _confirmComplete(),
              isLoading: _isLoading,
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(5),
          children: [
            32.gapHeight,
            [
                  "Stock Items".text(),
                  Obx(
                    () => MistLoader1().visibleIf(
                      _inventory.inventoryCountsLoading.value,
                    ),
                  ),
                  14.gapHeight,
                  Obx(
                    () =>
                        "There was error fetching items : ${_inventory.inventoryCountItemsError.value}"
                            .text(style: TextStyle(color: Colors.red))
                            .visibleIf(
                              _inventory.inventoryCountItemsError.isNotEmpty,
                            ),
                  ),
                  ListTile(
                    title: "Total Cost difference".text(),
                    leading: Iconify(Bx.dollar),
                    trailing:
                        CurrenceConverter.getCurrenceFloatInStrings(
                          widget.model.totalCostDifference,
                        ).text(
                          style: TextStyle(
                            color: widget.model.totalCostDifference >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                  ),
                  ListTile(
                    title: "Total Item difference".text(),
                    leading: Iconify(Bx.dollar),
                    trailing: widget.model.totalDifference.toString().text(
                      style: TextStyle(
                        color: widget.model.totalDifference >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  Obx(
                    () => _makeTable().visibleIf(
                      _inventory.inventoryCountItemsError.isEmpty &&
                          !_inventory.inventoryCountsLoading.value,
                    ),
                  ),
                ]
                .column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                )
                .padding(EdgeInsets.all(12))
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          ],
        ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      ),
    );
  }

  void _save() async {
    Get.back();
    setState(() {
      _isLoading = true;
    });
    widget.model.inventoryItems = _inventory.inventoryCountItems;
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
      Get.back();
      Toaster.showSuccess("Inventory Count was complited successfully");
      return;
    }
  }

  Widget _makeTable() {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: ScreenSizes.maxWidth,

      columns: [
        DataColumn2(label: Text('Item Name'), size: ColumnSize.L), // Has flex
        DataColumn(label: Text('Expected Stock')),
        DataColumn(label: Text('Counted')),
        DataColumn(label: Text('Difference')),
        DataColumn(label: Text('Cost '), numeric: true),
        DataColumn(label: Text('Cost Difference'), numeric: true),
      ],
      rows: _inventory.inventoryCountItems
          .map(
            (e) => DataRow(
              cells: <DataCell>[
                DataCell(e.name.text()),
                DataCell(e.count.toString().text()),
                DataCell(
                  e.counted.toString().text().textButton(
                    onPressed: () => _changeCount(e),
                  ),
                ),
                DataCell((e.difference).toString().text()),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(e.cost).text(),
                ),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.costDifference,
                  ).text(),
                ),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
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
              int quantity = int.parse(countedController.text);
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

  void _calculateQuantity(int quantity, InventoryChildCount itemInv) {
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

  _confirmComplete() {
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
