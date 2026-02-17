import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddStockadjustments extends StatefulWidget {
  const ScreenAddStockadjustments({super.key});

  @override
  State<ScreenAddStockadjustments> createState() =>
      _ScreenAddStockadjustmentsState();
}

class _ScreenAddStockadjustmentsState extends State<ScreenAddStockadjustments> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _inventory = Get.find<InventoryController>();
  final _userController = Get.find<UserController>();
  String _reason = "add";
  List<InvItem> _rejects = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Stock Adjustment".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          MistLoadIconButton(
            label: "Adjust",
            onPressed: () => _save(),
            isLoading: _isLoading,
          ),
        ],
      ),
      body: _rejects.isNotEmpty
          ? _buildRejectsScreen()
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(5),
                children: [
                  [
                        "Adjustment Information".text(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        24.gapHeight,
                        "Reason".text(),
                        8.gapHeight,
                        DropdownButton(
                          value: _reason,
                          isDense: true,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              _reason = value ?? 'add';
                            });
                          },
                          items: List.generate(
                            Inventory.adjustStockReasons.length,
                            (index) {
                              final data = Inventory.adjustStockReasons[index];
                              return DropdownMenuItem(
                                value: (data['value'] ?? ''),
                                child: (data['label'] ?? '').text(),
                              );
                            },
                          ),
                          hint: Text("Select Category"),
                        ).sizedBox(width: double.infinity),
                        18.gapHeight,
                        MistFormInput(
                          label: "Notes",
                          icon: Iconify(
                            Bx.note,
                            color: Colors.grey.withAlpha(200),
                          ),
                          underLineColor: Colors.grey.withAlpha(200),
                          controller: _notesController,
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
                  32.gapHeight,
                  [
                        [
                          "Stock Items".text(),
                          IconButton(
                            onPressed: () =>
                                Get.to(() => ScreenSelectPurchaseOrderItems()),
                            icon: Icon(Icons.add),
                          ),
                        ].row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        14.gapHeight,
                        Obx(
                          () => _inventory.selectedInvItems.isEmpty
                              ? "No items selected".text()
                              : _makeTable(_inventory.selectedInvItems),
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
              ),
            ).constrained(maxWidth: 600).center(),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final order = StockAdjustmentModel(
      id: '',
      senderId: '',
      company: '',
      reason: _reason,
      notes: _notesController.text,
      inventoryItems: _inventory.selectedInvItems,
      createdAt: DateTime.now(),
    );
    final response = await _inventory.addInventoryStockAdjustment(
      order.toJson(),
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _rejects = response.rejects;
    });
    if (response.status && response.rejects.isEmpty) {
      Get.back();
      Toaster.showSuccess("Stock Ajusted");
      return;
    }
    Toaster.showSuccess(
      "Stock adjustment was succeefull but with some few errors",
    );
  }

  Widget _buildRejectsScreen() {
    return ListView(
      padding: EdgeInsets.all(5),
      children: [
        [
              "This following items were rejected Coz there were not found"
                  .text(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
              24.gapHeight,
              ..._rejects.map(
                (e) => ListTile(
                  title: e.name.text(),
                  subtitle: e.sku.text(),
                  leading: Iconify(Bx.cart),
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
    );
  }

  SingleChildScrollView _makeTable(List<InvItem> selectedInvItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(120.0), // Item
          1: FixedColumnWidth(80.0),
          2: FixedColumnWidth(80.0),
          3: FixedColumnWidth(_reason == "add" ? 100.0 : 0.0), // Cost
          4: FixedColumnWidth(80),
          5: FixedColumnWidth(80),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: AppTheme.surface(context)),
            children: [
              "Item".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "In Stock".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              _getLabel().text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Cost"
                  .text()
                  .padding(EdgeInsets.symmetric(vertical: 10, horizontal: 3))
                  .visibleIf(_reason == "add"),
              "Stock After".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ), // This is the 5th item/column
              "".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
            ],
          ),
          ...selectedInvItems.map<TableRow>(
            (e) => TableRow(
              children: [
                e.name.text().padding(EdgeInsets.symmetric(vertical: 15)),
                e.inStock.toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ),
                InkWell(
                  child: e.quantity
                      .toString()
                      .text(
                        style: TextStyle(color: Get.theme.colorScheme.primary),
                      )
                      .padding(EdgeInsets.symmetric(vertical: 15)),
                  onTap: () => _changeQuantity(e),
                ),
                InkWell(
                  child:
                      CurrenceConverter.getCurrenceFloatInStrings(
                            e.cost,
                            _userController.user.value?.baseCurrence ?? '',
                          )
                          .text(
                            style: TextStyle(
                              color: Get.theme.colorScheme.primary,
                            ),
                          )
                          .padding(EdgeInsets.symmetric(vertical: 15)),
                  onTap: () => _changePrice(e),
                ).visibleIf(_reason == "add"),
                (_getStockAfter(e)).toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ), // This is the 5th item's data
                InkWell(
                  onTap: () => _inventory.removeodel(e),
                  child: Iconify(Bx.trash_alt, color: AppTheme.color(context)),
                ).padding(EdgeInsets.symmetric(vertical: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeQuantity(InvItem itemInv) {
    final proposedQuantity = TextEditingController(
      text: itemInv.quantity.toString(),
    );
    Get.defaultDialog(
      title: itemInv.name,
      content: [
        MistFormInput(label: 'Quantity', controller: proposedQuantity),
      ].column(mainAxisSize: MainAxisSize.min),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'update'.text().textButton(
          onPressed: () {
            double? quantity = double.tryParse(proposedQuantity.text);
            if (quantity == null) {
              Toaster.showError("Invalid quantity");
              return;
            }
            itemInv.quantity = quantity;
            itemInv.amount = quantity * itemInv.cost;
            _inventory.updateInvItem(itemInv);
            Get.back();
          },
        ),
      ],
    );
  }

  void _changePrice(InvItem itemInv) {
    final proposedCostsPrice = TextEditingController(
      text: CurrenceConverter.selectedCurrency(itemInv.cost).toString(),
    );
    Get.defaultDialog(
      title: itemInv.name,
      content: [
        MistFormInput(label: 'Proposed Cost', controller: proposedCostsPrice),
      ].column(mainAxisSize: MainAxisSize.min),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'update'.text().textButton(
          onPressed: () {
            double? cost = double.tryParse(proposedCostsPrice.text);
            if (cost == null || cost < 0) {
              Toaster.showError("Invalid cost");
              return;
            }
            itemInv.cost = CurrenceConverter.baseCurrency(cost);
            itemInv.amount = itemInv.quantity * cost;
            _inventory.updateInvItem(itemInv);
            Get.back();
          },
        ),
      ],
    );
  }

  String _getLabel() {
    if (_reason == "add") {
      return "Add Stock";
    }
    if (_reason == "count") {
      return "Counted";
    }
    return "Remove Stock";
  }

  double _getStockAfter(InvItem e) {
    if (_reason == "add") {
      return e.inStock + e.quantity;
    }
    if (_reason == "count") {
      return e.quantity;
    }
    return e.inStock - e.quantity;
  }
}
