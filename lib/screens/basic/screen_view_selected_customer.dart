import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/utils/toast.dart';

class ScreenViewSelectedCustomer extends StatefulWidget {
  const ScreenViewSelectedCustomer({super.key});

  @override
  State<ScreenViewSelectedCustomer> createState() =>
      _ScreenViewSelectedCustomerState();
}

class _ScreenViewSelectedCustomerState
    extends State<ScreenViewSelectedCustomer> {
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedCustomer = _itemsController.selectedCustomer.value;
      return Scaffold(
        appBar: AppBar(
          title: (selectedCustomer?.fullName ?? "No Customer Selected").text(),
          backgroundColor: Get.theme.colorScheme.primary,
          foregroundColor: Get.theme.colorScheme.onPrimary,
          actions: [
            IconButton(
              onPressed: _removeCustomer,
              icon: Iconify(Bx.x, color: Colors.white),
            ),
          ],
        ),
        body: selectedCustomer == null
            ? "No selected customer ?".text().center()
            : _buildLayoutDetails(selectedCustomer),
      );
    });
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
                leading: Iconify(Bx.user),
                title: "Name".text(),
                subtitle: selectedCustomer.fullName.text(),
              ),
              ListTile(
                leading: Iconify(Bx.envelope),
                title: "Email".text(),
                subtitle: selectedCustomer.email.text(),
              ),
              ListTile(
                leading: Iconify(Bx.phone),
                title: "Phone".text(),
                subtitle: selectedCustomer.phoneNumber.text(),
              ),
              ListTile(
                leading: Iconify(Bx.map),
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
                leading: Iconify(Bx.user),
                title: "Visits".text(),
                subtitle: selectedCustomer.visits.toString().text(),
              ),
              ListTile(
                leading: Iconify(Bx.star),
                title: "Points".text(),
                subtitle: selectedCustomer.points.toStringAsFixed(2).text(),
              ),
              ListTile(
                leading: Iconify(Bx.map),
                title: "Total Amount Spent".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  selectedCustomer.purchaseValue,
                ).text(),
              ),
              ListTile(
                leading: Iconify(Bx.phone),
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

  void _removeCustomer() {
    if (_itemsController.selectedCustomer.value == null) return;
    Get.defaultDialog(
      title: "Remove",
      content:
          "Remove ${_itemsController.selectedCustomer.value!.fullName} from the ticker"
              .text(),
      actions: [
        "no".text().textButton(onPressed: () => Get.back()),
        "yes".text().textButton(
          onPressed: () {
            Get.back();
            _itemsController.selectedCustomer.value = null;
            Toaster.showSuccess("removed customer");
          },
        ),
      ],
    );
  }
}
