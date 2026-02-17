import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_supplier.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddPurchaseOrder extends StatefulWidget {
  const ScreenAddPurchaseOrder({super.key});

  @override
  State<ScreenAddPurchaseOrder> createState() => _ScreenAddPurchaseOrderState();
}

class _ScreenAddPurchaseOrderState extends State<ScreenAddPurchaseOrder> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _inventory = Get.find<InventoryController>();
  final _userController = Get.find<UserController>();
  DateTime? _expectDate;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Purchase Order".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
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

  void _save(String s) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final order = PurchaseOrderModel(
      status: s,
      senderId: '',
      company: '',
      expectedDate: _expectDate!,
      notes: _notesController.text,
      inventoryItems: _inventory.selectedInvItems,
      sellerId: _inventory.selectedSupplier.value!.id ?? "",
      id: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final response = await _inventory.addInventoryPurchaseOrder(order.toJson());
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("Purchase order created");
    }
  }

  SingleChildScrollView _makeTable(List<InvItem> selectedInvItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(120.0), // Item
          1: FixedColumnWidth(80.0),
          2: FixedColumnWidth(80.0),
          3: FixedColumnWidth(100.0), // Cost
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
              "Quantity".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Purchase Cost".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Amount".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ), // This is the 5th item/column
              "".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ), // This is the 5th item/column
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
                ),
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.amount,
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(
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
}
