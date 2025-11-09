import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:mistpos/models/production_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddProduction extends StatefulWidget {
  const ScreenAddProduction({super.key});

  @override
  State<ScreenAddProduction> createState() => _ScreenAddProductionState();
}

class _ScreenAddProductionState extends State<ScreenAddProduction> {
  bool _isLoading = false;
  final _label = TextEditingController();
  final _userController = Get.find<UserController>();
  final _inventory = Get.find<InventoryController>();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _label.dispose();
    _inventory.selectedInvItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Add Productions".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          MistLoadIconButton(
            label: "Add",
            onPressed: () => _save(),
            isLoading: _isLoading,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Form(
            key: _formKey,
            child: MistMordernLayout(
              label: "Items",
              children: [
                14.gapHeight,
                MistFormInput(
                  label: "Label",
                  controller: _label,
                  validateString: "Label is required",
                ),
                14.gapHeight,
                ListTile(
                  title: "Composite Items".text(),
                  contentPadding: EdgeInsets.all(0),
                  trailing: IconButton(
                    onPressed: () => Get.to(
                      () => ScreenSelectPurchaseOrderItems(
                        isCompositeItems: true,
                      ),
                    ),
                    icon: Icon(Icons.add),
                  ),
                ),
                Obx(
                  () => "There are no items selected | Select at least one"
                      .text(style: TextStyle(color: Colors.red))
                      .visibleIf(_inventory.selectedInvItems.isEmpty),
                ),

                Obx(
                  () => _makeTable().visibleIf(
                    _inventory.selectedInvItems.isNotEmpty,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  Widget _makeTable() {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: ScreenSizes.maxWidth,

      columns: [
        DataColumn2(label: Text('Item Name'), size: ColumnSize.L), // Has flex
        DataColumn(label: Text('Cost')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('')),
      ],
      rows: _inventory.selectedInvItems
          .map(
            (e) => DataRow(
              cells: <DataCell>[
                DataCell(e.name.text()),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.cost,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                ),
                DataCell(
                  e.quantity.toString().text().textButton(
                    onPressed: () => _changeCount(e),
                  ),
                ),

                DataCell(
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _removeItem(e),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
  }

  void _changeCount(InvItem itemInv) {
    final countedController = TextEditingController(
      text: itemInv.quantity.toString(),
    );

    Get.defaultDialog(
      title: itemInv.name,
      content: [
        MistFormInput(label: "Quantity", controller: countedController),
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

  void _calculateQuantity(double quantity, InvItem itemInv) {
    itemInv.quantity = quantity;
    _inventory.updateInvItem(itemInv);
  }

  void _removeItem(InvItem e) {
    _inventory.removeodel(e);
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_inventory.selectedInvItems.isEmpty) {
      Toaster.showError("There are no items selected");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final model = ProductionModel(
      items: _inventory.selectedInvItems,
      hexId: '',
      label: _label.text,
    );
    final response = await _inventory.addProduction(model.toJson());
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("Production added");
      return;
    }
  }
}
