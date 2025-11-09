import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistpos/screens/inventory/screen_edit_purchase_order.dart';
import 'package:mistpos/screens/inventory/screen_complete_purchase_order.dart';

class ScreenViewPurchaseOrder extends StatefulWidget {
  final PurchaseOrderModel model;
  const ScreenViewPurchaseOrder({super.key, required this.model});

  @override
  State<ScreenViewPurchaseOrder> createState() =>
      _ScreenViewPurchaseOrderState();
}

class _ScreenViewPurchaseOrderState extends State<ScreenViewPurchaseOrder> {
  final _inventory = Get.find<InventoryController>();
  final _userController = Get.find<UserController>();
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
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Purchase Order".text(),
        actions: [
          if (widget.model.status.toLowerCase() == "pending") ...[
            MistLoadIconButton(
              label: "Reject",
              isLoading: _updatingState,
              onPressed: () => _updateState("Reject The Order", "declined"),
            ),
          ],
          MistLoadIconButton(
            label: "receive",
            onPressed: () => _navigateToReceive(),
          ).visibleIf(
            widget.model.status.toLowerCase() == "pending" ||
                widget.model.status.toLowerCase() == "partial-received",
          ),
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
      floatingActionButton: widget.model.status.toLowerCase() == "draft"
          ? FloatingActionButton(
              onPressed: _editPurchaseOrder,
              child: Icon(Icons.edit, color: Colors.white),
            )
          : null,
    );
  }

  _buildProductSummary() {
    final totalItems = widget.model.inventoryItems.fold(
      0.0,
      (prev, current) => prev + current.quantity,
    );
    final totalApproved = widget.model.inventoryItems.fold(
      0.0,
      (prev, current) => prev + current.counted,
    );
    return [
          "Summary ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          14.gapHeight,
          widget.model.label.text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          14.gapHeight,
          [
            "Date :".text(
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            MistDateUtils.getInformalDate(widget.model.createdAt).text(),
          ].row(),
          14.gapHeight,
          [
            "Expected On :".text(
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            MistDateUtils.getInformalDate(widget.model.expectedDate).text(),
          ].row(),
          32.gapHeight,
          "Completion Amount (${totalApproved / totalItems * 100} %)".text(),
          12.gapHeight,
          LinearProgressIndicator(value: totalApproved / totalItems),
          32.gapHeight,
          Iconify(Bx.note, color: AppTheme.color(context)),
          widget.model.notes.text(),
          32.gapHeight,
          "Status".text(
            style: TextStyle(color: Get.theme.colorScheme.secondary),
          ),
          widget.model.status
              .toUpperCase()
              .text(
                style: TextStyle(
                  color: _getColor(widget.model.status),
                  fontWeight: FontWeight.bold,
                ),
              )
              .textIconButton(
                onPressed: () {},
                icon: _getStatus(widget.model.status),
              ),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(color: AppTheme.surface(context)),
        );
  }

  _buildSupplierInformation() {
    return MistMordernLayout(
      label: "Supplier Information",
      children: [
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
                leading: Iconify(Bx.user, color: AppTheme.color(context)),
                subtitle: "Name".text(),
              ),
              12.gapHeight,
              ListTile(
                title: model!.email?.text(),
                leading: Iconify(Bx.envelope, color: AppTheme.color(context)),
                subtitle: "Email".text(),
              ),
              12.gapHeight,
              ListTile(
                title: model!.country?.text(),
                leading: Iconify(Bx.flag, color: AppTheme.color(context)),
                subtitle: "Country".text(),
              ),
              12.gapHeight,
              ListTile(
                title: model!.city?.text(),
                leading: Iconify(Bx.building, color: AppTheme.color(context)),
                subtitle: "City".text(),
              ),
              12.gapHeight,
              ListTile(
                title: model!.address1?.text(),
                leading: Iconify(
                  Bx.current_location,
                  color: AppTheme.color(context),
                ),
                subtitle: "Address 1".text(),
              ),
              12.gapHeight,
              ListTile(
                title: model!.address2?.text(),
                leading: Iconify(
                  Bx.current_location,
                  color: AppTheme.color(context),
                ),
                subtitle: "Address 2".text(),
              ),
              12.gapHeight,
              ListTile(
                title: model!.postalCode?.text(),
                leading: Iconify(Bx.code, color: AppTheme.color(context)),
                subtitle: "Postal code".text(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  _buildProductInformation() {
    final totalProductPrice = widget.model.inventoryItems.fold(
      0.0,
      (prev, current) => prev + current.amount,
    );

    return MistMordernLayout(
      label: "Product Information ",
      children: [
        14.gapHeight,
        _makeTable(),
        Row(
          children: [
            "Total".text(style: TextStyle(fontWeight: FontWeight.bold)),
            14.gapWidth,
            CurrenceConverter.getCurrenceFloatInStrings(
              totalProductPrice,
              _userController.user.value?.baseCurrence ?? '',
            ).text(),
          ],
        ),
      ],
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
      return Iconify(Bx.check_circle, color: Colors.green, size: 35);
    }
    if (status.toLowerCase() == "partial-received") {
      return Iconify(Bx.time, color: Colors.yellow, size: 35);
    }
    return Iconify(Bx.archive, color: Colors.grey, size: 35);
  }

  Color _getColor(String status) {
    if (status.toLowerCase() == "pending") {
      return Colors.orange;
    }
    if (status.toLowerCase() == "declined") {
      return Colors.red;
    }
    if (status.toLowerCase() == "accepted") {
      return Colors.green;
    }
    if (status.toLowerCase() == "partial-received") {
      return Colors.yellow;
    }
    return Colors.grey;
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

  void _editPurchaseOrder() {
    if (widget.model.status == "accepted") {
      Toaster.showError("cant edit already sent inventory object");
      return;
    }
    if (model == null) {
      Toaster.showError("Supplier not Loaded ? Supplier has to load first");
      return;
    }
    _inventory.selectedSupplier.value = model;
    _inventory.selectedInvItems.value = widget.model.inventoryItems;
    Get.to(() => ScreenEditPurchaseOrder(model: widget.model));
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
              "Quantity".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Purchase Costs".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Amount".text().padding(
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
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.cost,
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.symmetric(vertical: 15)),
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.amount,
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.symmetric(vertical: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _navigateToReceive() async {
    final result = await Get.to(
      () => ScreenCompletePurchaseOrder(model: widget.model),
    );
    if (result != null) {
      widget.model.inventoryItems = result.inventoryItems;
      widget.model.status = result.status;
      setState(() {});
    }
  }
}
