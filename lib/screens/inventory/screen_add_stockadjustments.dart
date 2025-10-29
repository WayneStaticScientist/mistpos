import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
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
        foregroundColor: Get.theme.colorScheme.onPrimary,
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
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _inventory.selectedInvItems.length,
                                  itemBuilder: (context, index) {
                                    final e =
                                        _inventory.selectedInvItems[index];
                                    return ListTile(
                                      onTap: () => Future.microtask(
                                        () => _showBottomBar(e),
                                      ),
                                      leading: CircleAvatar(
                                        child: _getPrefix(e.quantity).text(),
                                      ),
                                      subtitle: "in stock ${e.inStock}".text(),
                                      title: e.name.text(),
                                      trailing: _reason == "add"
                                          ? CurrenceConverter.getCurrenceFloatInStrings(
                                              e.quantity * e.cost,
                                            ).text()
                                          : null,
                                    );
                                  },
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
              ),
            ).constrained(maxWidth: 600).center(),
    );
  }

  _showBottomBar(InvItem itemInv) {
    Get.bottomSheet(
      [
        CardButtons(
          onTap: () => {Get.back(), _edit(itemInv)},
          icon: Iconify(Bx.edit),
          label: "Edit",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          onTap: () => {Get.back(), _inventory.removeodel(itemInv)},
          icon: Iconify(Bx.user_plus),
          label: "Remove",
          color: Get.theme.colorScheme.secondary.withAlpha(50),
        ).expanded1,
      ].row().padding(EdgeInsets.only(top: 18)).safeArea(),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  _edit(InvItem itemInv) {
    final proposedCostsPrice = TextEditingController(
      text: itemInv.cost.toString(),
    );
    final proposedQuantity = TextEditingController(
      text: itemInv.quantity.toString(),
    );
    Get.defaultDialog(
      title: itemInv.name,
      content: [
        if (_reason == 'add')
          MistFormInput(label: 'Cost', controller: proposedCostsPrice),
        MistFormInput(label: _getTitle(), controller: proposedQuantity),
      ].column(mainAxisSize: MainAxisSize.min),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'update'.text().textButton(
          onPressed: () {
            try {
              int quantity = int.parse(proposedQuantity.text);
              double cost = double.parse(proposedCostsPrice.text);
              itemInv.quantity = quantity;
              itemInv.cost = cost;
              itemInv.amount = quantity * cost;
              _inventory.updateInvItem(itemInv);
              Get.back();
            } catch (e) {
              Toaster.showError(e.toString());
            }
          },
        ),
      ],
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

  String _getTitle() {
    switch (_reason) {
      case 'add':
        return "Add Stock Amount";
      case "count":
        return "counted stock";
    }
    return "Remove Stock";
  }

  String _getPrefix(int size) {
    if (_reason == "add") {
      return "+ $size";
    }
    if (_reason == "count") {
      return "= $size";
    }
    return "- $size";
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
}
