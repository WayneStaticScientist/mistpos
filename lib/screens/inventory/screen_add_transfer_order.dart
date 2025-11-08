import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/transfer_order_model.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddTransferOrder extends StatefulWidget {
  const ScreenAddTransferOrder({super.key});

  @override
  State<ScreenAddTransferOrder> createState() => _ScreenAddTransferOrderState();
}

class _ScreenAddTransferOrderState extends State<ScreenAddTransferOrder> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _user = Get.find<UserController>();
  final _notesController = TextEditingController();
  final _inventory = Get.find<InventoryController>();
  final _adminController = Get.find<AdminController>();
  String? _toStore;
  List<InvItem> _rejects = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adminController.loadCompanies();
    });
  }

  @override
  void dispose() {
    _inventory.selectedInvItems.clear();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Transfer Order".text(),
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
      body: _rejects.isNotEmpty
          ? _buildRejectsScreen()
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(5),
                children: [
                  MistMordernLayout(
                    label: "Transfer Information",
                    children: [
                      8.gapHeight,
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: "Current Store".text(),
                        subtitle: _user.user.value!.companyName.text(),
                        leading: Iconify(Bx.building, color: Colors.white),
                      ),
                      24.gapHeight,

                      "Transfer Items to which store".text(),

                      Obx(() {
                        if (_adminController.loadingCompanies.value) {
                          return MistLoader1();
                        }
                        if (_adminController.companies.isEmpty) {
                          return "No Stores found".text();
                        }
                        return DropdownButton(
                              value: _toStore,
                              isDense: true,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  _toStore = value;
                                });
                              },
                              items: List.generate(
                                _adminController.companies.length,
                                (index) {
                                  return DropdownMenuItem(
                                    value:
                                        _adminController.companies[index].hexId,
                                    child: _adminController
                                        .companies[index]
                                        .name
                                        .text(),
                                  );
                                },
                              ),
                              hint: Text(
                                "Select Which store you want to transfer ",
                              ),
                            )
                            .sizedBox(width: double.infinity)
                            .visibleIf(_adminController.companies.isNotEmpty);
                      }),
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
                    ],
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
                                        child: "${(e.quantity)}".text(
                                          style: TextStyle(color: Colors.white),
                                        ),
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
          icon: Iconify(Bx.edit, color: Colors.white),
          label: "Edit",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          onTap: () => {Get.back(), _inventory.removeodel(itemInv)},
          icon: Iconify(Bx.user_plus, color: Colors.white),
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
        MistFormInput(label: "Quantinty", controller: proposedQuantity),
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
    if (_toStore == null) {
      Toaster.showError("Destination company shouldnt be empty");
      return;
    }
    if (_toStore == _user.user.value!.company) {
      Toaster.showError("Destination company should be a different company");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final order = TransferOrderModel(
      id: '',
      senderId: '',
      company: '',
      toCompany: _toStore ?? '',
      notes: _notesController.text,
      inventoryItems: _inventory.selectedInvItems,
    );
    final response = await _inventory.addInventoryTransferOrder(order.toJson());
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _rejects = response.rejects;
    });
    if (response.status && response.rejects.isEmpty) {
      Get.back();
      Toaster.showSuccess("Transfer order processed");
      return;
    }
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
