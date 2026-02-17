import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class ScreenCompletePurchaseOrder extends StatefulWidget {
  final PurchaseOrderModel model;
  const ScreenCompletePurchaseOrder({super.key, required this.model});

  @override
  State<ScreenCompletePurchaseOrder> createState() =>
      _ScreenCompletePurchaseOrderState();
}

class _ScreenCompletePurchaseOrderState
    extends State<ScreenCompletePurchaseOrder> {
  final _inventory = Get.find<InventoryController>();
  bool _loading = false;
  late final PurchaseOrderModel _currentModel = widget.model;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          Get.back(result: _currentModel);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Get.theme.colorScheme.primary,
          title: "Purchase Order".text(),
          actions: [
            MistLoadIconButton(
              label: "Complete",
              onPressed: () => _complete(),
              isLoading: _loading,
            ).visibleIfNot(widget.model.status == "accepted"),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [_buildProductInformation()],
        ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      ),
    );
  }

  MistMordernLayout _buildProductInformation() {
    return MistMordernLayout(
      label: "",
      children: [
        ListTile(
          title: "Items".text(),
          trailing: "Mark All Received".text().textButton(
            onPressed: _markAllReceived,
          ),
        ),
        14.gapHeight,
        _makeTable(),
      ],
    );
  }

  Widget _makeTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(120.0), // Item
          1: FixedColumnWidth(80.0),
          2: FixedColumnWidth(80.0),
          3: FixedColumnWidth(100.0), // Cost\
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: AppTheme.surface(context)),
            children: [
              "Item".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Ordered".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Received".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "To Receive".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
            ],
          ),
          ...widget.model.inventoryItems.map<TableRow>(
            (e) => TableRow(
              children: [
                e.name.text().padding(EdgeInsets.symmetric(vertical: 15)),
                e.quantity.toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ),
                e.counted.toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ),
                e.receive
                    .toString()
                    .text(
                      style: TextStyle(color: Get.theme.colorScheme.primary),
                    )
                    .padding(EdgeInsets.symmetric(vertical: 15))
                    .onTap(() => _editReceiveItem(e)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editReceiveItem(InvItem e) {
    final proposedQuantity = TextEditingController(text: e.receive.toString());
    Get.defaultDialog(
      title: e.name,
      content: MistFormInput(
        label: "Receive quantity",
        controller: proposedQuantity,
      ),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'update'.text().textButton(
          onPressed: () {
            double? quantity = double.tryParse(proposedQuantity.text);
            if (quantity == null) {
              Toaster.showError("Invalid quantity");
              return;
            }
            e.receive = quantity;
            setState(() {
              try {
                widget.model.inventoryItems[widget.model.inventoryItems.indexOf(
                      e,
                    )] =
                    e;
              } catch (_) {}
            });
            Get.back();
          },
        ),
      ],
    );
  }

  Future<void> _complete() async {
    setState(() {
      _loading = true;
    });
    final response = await _inventory.receivePurchaseOrder(widget.model);
    if (!mounted) return;
    if (response != null) {
      Toaster.showSuccess("Order Received");
      setState(() {
        _loading = false;
        widget.model.inventoryItems = response.inventoryItems;
        widget.model.status = response.status;
        _currentModel.inventoryItems = response.inventoryItems;
        _currentModel.status = response.status;
      });
    }
  }

  void _markAllReceived() {
    for (var element in widget.model.inventoryItems) {
      element.receive = element.quantity - element.counted;
      widget.model.inventoryItems[widget.model.inventoryItems.indexOf(
            element,
          )] =
          element;
    }
    Toaster.showSuccess("All items marked as received");
    setState(() {});
  }
}
