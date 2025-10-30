import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/utils/toast.dart';

class ScreenViewCustomer extends StatefulWidget {
  final CustomerModel model;
  const ScreenViewCustomer({super.key, required this.model});

  @override
  State<ScreenViewCustomer> createState() => _ScreenViewCustomerState();
}

class _ScreenViewCustomerState extends State<ScreenViewCustomer> {
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    final selectedCustomer = widget.model;
    return Scaffold(
      appBar: AppBar(
        title: (selectedCustomer.fullName).text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(
            () => IconButton(
              onPressed: _deleteCustomer,
              icon: _itemsController.deletingCustomer.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Iconify(Carbon.delete, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildLayoutDetails(selectedCustomer),
    );
  }

  Widget _buildLayoutDetails(CustomerModel selectedCustomer) {
    return ListView(
      padding: EdgeInsets.all(14),
      children: [
        [
              "Personal Details"
                  .text(style: TextStyle(fontWeight: FontWeight.bold))
                  .padding(EdgeInsets.all(14)),
              ListTile(
                leading: Iconify(Bx.user, color: Colors.white),
                title: "Name".text(),
                subtitle: selectedCustomer.fullName.text(),
              ),
              ListTile(
                leading: Iconify(Bx.envelope, color: Colors.white),
                title: "Email".text(),
                subtitle: selectedCustomer.email.text(),
              ),
              ListTile(
                leading: Iconify(Bx.phone, color: Colors.white),
                title: "Phone".text(),
                subtitle: selectedCustomer.phoneNumber.text(),
              ),
              ListTile(
                leading: Iconify(Bx.map, color: Colors.white),
                title: "Address".text(),
                subtitle: selectedCustomer.address.text(),
              ),
            ]
            .column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .decoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(10),
                borderRadius: BorderRadius.circular(20),
              ),
            )
            .padding(EdgeInsets.all(8)),
        [
              "Promotional Details"
                  .text(style: TextStyle(fontWeight: FontWeight.bold))
                  .padding(EdgeInsets.all(14)),
              ListTile(
                leading: Iconify(Bx.walk, color: Colors.white),
                title: "Visits".text(),
                subtitle: selectedCustomer.visits.toString().text(),
              ),
              ListTile(
                leading: Iconify(Bx.star, color: Colors.white),
                title: "Points".text(),
                subtitle: selectedCustomer.points.toStringAsFixed(2).text(),
              ),
              ListTile(
                leading: Iconify(Bx.money, color: Colors.white),
                title: "Total Amount Spent".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  selectedCustomer.purchaseValue,
                ).text(),
              ),
              ListTile(
                leading: Iconify(Carbon.money, color: Colors.white),
                title: "Profit Brought".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  selectedCustomer.inboundProfit,
                ).text(),
              ),
            ]
            .column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .decoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(10),
                borderRadius: BorderRadius.circular(20),
              ),
            )
            .padding(EdgeInsets.all(8)),
      ],
    );
  }

  void _deleteCustomer() {
    if (_itemsController.deletingCustomer.value) return;
    Get.defaultDialog(
      title: "Delete",
      content: "Delete ${widget.model.fullName}!Its not reversible".text(),
      actions: [
        "no".text().textButton(onPressed: () => Get.back()),
        "yes".text().textButton(onPressed: () => _delete(widget.model)),
      ],
    );
  }

  void _delete(CustomerModel model) async {
    final result = await _itemsController.deleteCustomer(model);
    if (!mounted) return;
    if (result) {
      Get.back();
      Toaster.showSuccess("customer deleted");
    }
  }
}
