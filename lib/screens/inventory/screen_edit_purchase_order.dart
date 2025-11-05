import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_supplier.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenEditPurchaseOrder extends StatefulWidget {
  final PurchaseOrderModel model;
  const ScreenEditPurchaseOrder({super.key, required this.model});

  @override
  State<ScreenEditPurchaseOrder> createState() =>
      _ScreenEditPurchaseOrderState();
}

class _ScreenEditPurchaseOrderState extends State<ScreenEditPurchaseOrder> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();
  late final _notesController = TextEditingController(text: widget.model.notes);
  final _inventory = Get.find<InventoryController>();
  late DateTime? _expectDate = widget.model.expectedDate;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Edit Purchase Order".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (widget.model.status != "accepted") ...[
            MistLoadIconButton(
              label: 'draft',
              isLoading: _isLoading,
              onPressed: () => _save("draft"),
            ),
            MistLoadIconButton(
              label: "save",
              onPressed: () => _save("pending"),
              isLoading: _isLoading,
            ),
          ],
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Purchase Order Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  Obx(
                    () => MistFormInput(
                      enabled: false,
                      validateString: "Supplier  is required",
                      label: "Supplier",
                      icon: Iconify(
                        Bx.abacus,
                        color: Colors.grey.withAlpha(200),
                      ),
                      underLineColor: Colors.grey.withAlpha(200),
                      controller: TextEditingController(
                        text: _inventory.selectedSupplier.value?.name ?? "",
                      ),
                    ).onTap(() => Get.to(() => ScreenSelectSupplier())),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    enabled: false,
                    validateString: "Expected date is required",
                    label: "Expected On",
                    icon: Iconify(
                      Bx.calendar,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: TextEditingController(
                      text: _expectDate != null ? _expectDate.toString() : "",
                    ),
                  ).onTap(_pickDate),
                  14.gapHeight,
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
                    "Purchase Order Items".text(),
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
                                // The onTap needs deferral here as well, if it's causing issues!
                                onTap: () =>
                                    Future.microtask(() => _showBottomBar(e)),

                                leading: CircleAvatar(
                                  child: "x ${e.quantity}".text(),
                                ),
                                subtitle:
                                    CurrenceConverter.getCurrenceFloatInStrings(
                                      e.cost,
                                      _userController
                                              .user
                                              .value
                                              ?.baseCurrence ??
                                          '',
                                    ).text(),
                                title: e.name.text(),
                                trailing:
                                    CurrenceConverter.getCurrenceFloatInStrings(
                                      e.quantity * e.cost,
                                      _userController
                                              .user
                                              .value
                                              ?.baseCurrence ??
                                          '',
                                    ).text(),
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

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      helpText: 'Select Expected Date',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    setState(() {
      _expectDate = pickedDate;
    });
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
          icon: Iconify(Bx.x),
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
        MistFormInput(label: 'Proposed Cost', controller: proposedCostsPrice),
        MistFormInput(label: 'Quantity', controller: proposedQuantity),
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

  void _save(String s) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    widget.model.expectedDate = _expectDate!;
    widget.model.inventoryItems = _inventory.selectedInvItems;
    widget.model.notes = _notesController.text;
    final response = await _inventory.updatePurchaseOrder(widget.model);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("Purchase order created");
    }
  }
}
