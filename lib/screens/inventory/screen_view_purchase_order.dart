import 'package:exui/material.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/fa.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenViewPurchaseOrder extends StatefulWidget {
  final PurchaseOrderModel model;
  const ScreenViewPurchaseOrder({super.key, required this.model});

  @override
  State<ScreenViewPurchaseOrder> createState() =>
      _ScreenViewPurchaseOrderState();
}

class _ScreenViewPurchaseOrderState extends State<ScreenViewPurchaseOrder> {
  final _inventory = Get.find<InventoryController>();
  SupplierModel? model;
  bool _loading = true;
  bool _updatingState = false;
  String _error = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await _inventory.getSupplierById(widget.model.sellerId);
      if (mounted) {
        setState(() {
          model = response.model;
          _loading = false;
          _error = response.message;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Get.theme.colorScheme.onPrimary,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Purchase Order".text(),
        actions: [
          if (widget.model.status.toLowerCase() == "pending") ...[
            MistLoadIconButton(
              label: "Reject",
              isLoading: _updatingState,
              onPressed: () => _updateState("Reject The Order", "declined"),
            ),
            MistLoadIconButton(
              label: "Approve",
              isLoading: _updatingState,
              onPressed: () => _updateState("Accept The Order", "accepted"),
            ),
          ],
          if (widget.model.status.toLowerCase() == "draft") ...[
            MistLoadIconButton(
              isLoading: _updatingState,
              label: "confirm",
              onPressed: () =>
                  _updateState("Set the order for approval", "pending"),
            ),
          ],
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildProductSummary(),
          24.gapHeight,
          _buildSupplierInformation(),
          24.gapHeight,
          _buildProductInformation(),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }

  _buildProductSummary() {
    final totalProductPrice = widget.model.inventoryItems.fold(
      0.0,
      (prev, current) => prev + current.amount,
    );
    final totalItems = widget.model.inventoryItems.fold(
      0,
      (prev, current) => prev + current.quantity,
    );
    return [
          "Summary ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              CardOverview(
                label: "Total Price",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  totalProductPrice,
                ),
              ),
              CardOverview(label: "Total Items", value: totalItems.toString()),
              [
                    "Status".text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _getStatus(widget.model.status),
                    widget.model.status.toUpperCase().text(),
                  ]
                  .column(crossAxisAlignment: CrossAxisAlignment.start)
                  .sizedBox(height: 100, width: 150)
                  .padding(EdgeInsets.all(12))
                  .decoratedBox(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
            ],
          ),
          Iconify(Bx.pencil),
          widget.model.notes.text(),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        );
  }

  _buildSupplierInformation() {
    return [
          "Supplier Information".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (_loading)
            LoadingAnimationWidget.staggeredDotsWave(
              color: Get.theme.colorScheme.primary,
              size: 50,
            ),
          18.gapHeight,
          if (_error.isNotEmpty)
            "There was error fetching the supplier details ".text(
              style: TextStyle(color: Colors.red),
            ),
          if (model != null) ...[
            ExpansionTile(
              shape: RoundedRectangleBorder(),
              title: "Supplier details".text(),
              children: [
                ListTile(
                  title: model!.name.text(),
                  leading: Iconify(Bx.user),
                  subtitle: "Name".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: model!.email?.text(),
                  leading: Iconify(Bx.envelope),
                  subtitle: "Email".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: model!.country?.text(),
                  leading: Iconify(Bx.flag),
                  subtitle: "Country".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: model!.city?.text(),
                  leading: Iconify(Bx.building),
                  subtitle: "City".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: model!.address1?.text(),
                  leading: Iconify(Bx.current_location),
                  subtitle: "Address 1".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: model!.address2?.text(),
                  leading: Iconify(Bx.current_location),
                  subtitle: "Address 2".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: model!.postalCode?.text(),
                  leading: Iconify(Bx.code),
                  subtitle: "Postal code".text(),
                ),
              ],
            ),
          ],
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        );
  }

  _buildProductInformation() {
    return [
          "Product Information ".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ExpansionTile(
            shape: RoundedRectangleBorder(),
            title: "Products".text(),
            children: widget.model.inventoryItems
                .map(
                  (e) => ListTile(
                    leading: CircleAvatar(child: "x ${e.quantity}".text()),
                    title: e.name.text(),
                    subtitle:
                        "Prop ${CurrenceConverter.getCurrenceFloatInStrings(e.cost)}"
                            .text(style: TextStyle(fontSize: 12)),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      e.amount,
                    ).text(style: TextStyle(color: Colors.green)),
                  ),
                )
                .toList(),
          ),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        );
  }

  Widget _getStatus(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.orange, size: 35);
    }
    if (status.toLowerCase() == "declined") {
      return Iconify(Bx.x, color: Colors.red, size: 35);
    }
    if (status.toLowerCase() == "accepted") {
      return Iconify(Fa.thumbs_up, color: Colors.lightGreenAccent, size: 35);
    }
    return Iconify(Bx.archive, color: Colors.grey, size: 35);
  }

  _updateState(String s, String t) {
    Get.defaultDialog(
      title: "Confirm Changes",
      content: s.text(),
      actions: [
        'close'.text().textButton(onPressed: () => Get.back()),
        'confirm'.text().textButton(
          onPressed: () {
            Get.back();
            _changeState(t);
          },
        ),
      ],
    );
  }

  void _changeState(String t) async {
    setState(() {
      _updatingState = true;
    });
    widget.model.status = t;
    final response = await _inventory.updatePurchaseOrder(widget.model);
    if (!mounted) return;
    setState(() {
      _updatingState = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("Order Updated");
    }
  }
}
