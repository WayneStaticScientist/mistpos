import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/inventory_child_count.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddInventoryCounts extends StatefulWidget {
  const ScreenAddInventoryCounts({super.key});

  @override
  State<ScreenAddInventoryCounts> createState() =>
      _ScreenAddInventoryCountsState();
}

class _ScreenAddInventoryCountsState extends State<ScreenAddInventoryCounts> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _inventory = Get.find<InventoryController>();
  String? _countBasedOn;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Inventory Counts".text(),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Inventory Counts Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  24.gapHeight,
                  "Which items are need for counts".text(),
                  8.gapHeight,
                  DropdownButton(
                    value: _countBasedOn,
                    isDense: true,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _countBasedOn = value;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: "Selected Items".text(),
                      ),
                      DropdownMenuItem(value: "*", child: "All Items".text()),
                    ],
                    hint: Text("Select Which store you want to transfer "),
                  ).sizedBox(width: double.infinity),
                  18.gapHeight,
                  MistFormInput(
                    label: "Notes",
                    icon: Iconify(Bx.note, color: Colors.grey.withAlpha(200)),
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
                  ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                  14.gapHeight,
                  Obx(
                    () => _inventory.selectedInvItems.isEmpty
                        ? "No items selected".text()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _inventory.selectedInvItems.length,
                            itemBuilder: (context, index) {
                              final e = _inventory.selectedInvItems[index];
                              return ListTile(
                                trailing: IconButton(
                                  onPressed: () => _inventory.removeodel(e),
                                  icon: Icon(Icons.close),
                                ),
                                leading: CircleAvatar(
                                  child: "${(e.quantity)}".text(),
                                ),
                                subtitle: "in stock ${e.inStock}".text(),
                                title: e.name.text(),
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
                )
                .visibleIf(_countBasedOn != "*"),
            ["All items are to be counted".text()]
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
                )
                .visibleIf(_countBasedOn == "*"),
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
    final order = InventoryCountModel(
      id: '',
      countBasedOn: _countBasedOn ?? "*",
      senderId: '',
      company: '',
      notes: _notesController.text,
      inventoryItems: _inventory.selectedInvItems
          .map(
            (e) => InventoryChildCount(
              id: e.id,
              name: e.name,
              count: e.quantity,
              difference: 0,
              cost: e.cost,
            ),
          )
          .toList(),
      status: 'pending',
    );
    final response = await _inventory.addInventoryCounts(order.toJson());
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("Inventory counts added");
      return;
    }
  }
}
