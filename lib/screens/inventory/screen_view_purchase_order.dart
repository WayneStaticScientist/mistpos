import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';

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
  String _error = "";
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await _inventory.getSupplierById(widget.model.sellerId);
      setState(() {
        model = response.model;
        _loading = false;
        _error = response.message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Get.theme.colorScheme.onPrimary,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Purchase Order".text(),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          [
                "Sender Information".text(
                  style: TextStyle(fontWeight: FontWeight.bold),
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
              ),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }
}
