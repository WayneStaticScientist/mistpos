import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddTax extends StatefulWidget {
  const ScreenAddTax({super.key});

  @override
  State<ScreenAddTax> createState() => _ScreenAddTaxState();
}

class _ScreenAddTaxState extends State<ScreenAddTax> {
  bool _isLoading = false;
  bool _activated = true;
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemsController = Get.find<ItemsController>();
  final _itemValueController = TextEditingController();
  final _invenController = Get.find<InventoryController>();
  @override
  void dispose() {
    _invenController.selectedInvItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Tax Option"),
        actions: [
          MistLoadIconButton(
            label: 'Save',
            isLoading: _isLoading,
            onPressed: _saveItem,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Tax Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Tax Label is required",
                    label: "Tax label",
                    icon: Iconify(Bx.abacus, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _itemNameController,
                  ),
                  14.gapHeight,
                  ListTile(
                    onTap: () => setState(() {
                      _activated = !_activated;
                    }),
                    contentPadding: EdgeInsets.zero,
                    subtitle: "Select wether it should be applied".text(
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    title: "Activated".text(),
                    leading: Checkbox(
                      value: _activated,
                      onChanged: (e) {
                        setState(() {
                          _activated = e ?? false;
                        });
                      },
                    ),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Tax Value is required",
                    label: "Tax Value (0-99%)",
                    icon: Iconify(
                      Bx.calculator,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _itemValueController,
                  ),
                  14.gapHeight,
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
            MistMordernLayout(
              label: "Apply On ",
              children: [
                [
                  "Affected Items".text(),
                  IconButton(
                    onPressed: () =>
                        Get.to(() => ScreenSelectPurchaseOrderItems()),
                    icon: Icon(Icons.add),
                  ),
                ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                14.gapHeight,
                Obx(
                  () => _invenController.selectedInvItems.isEmpty
                      ? "If no items are selected it will apply to all items"
                            .text(style: TextStyle(color: Colors.red))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _invenController.selectedInvItems.length,
                          itemBuilder: (context, index) {
                            final e = _invenController.selectedInvItems[index];
                            return ListTile(
                              contentPadding: EdgeInsets.all(0),
                              trailing: IconButton(
                                onPressed: () => _invenController.removeodel(e),
                                icon: Icon(Icons.close),
                              ),
                              leading: CircleAvatar(
                                child: e.name[0].toUpperCase().text(),
                              ),
                              title: e.name.text(),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.tryParse(_itemValueController.text);
    if (amount == null || amount < 0) {
      Toaster.showError("Invalid tax value");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final response = await _itemsController.addTaxes(
      TaxModel(
        label: _itemNameController.text.trim(),
        value: amount,
        activated: _activated,
        selectedIds: _invenController.selectedInvItems
            .map((e) => e.id)
            .toList(),
      ).toJson(),
    );
    if (response) {
      Get.back();
      Toaster.showSuccess("Tax added successfully");
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
}
