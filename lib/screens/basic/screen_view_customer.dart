import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenViewCustomer extends StatefulWidget {
  final CustomerModel model;
  const ScreenViewCustomer({super.key, required this.model});

  @override
  State<ScreenViewCustomer> createState() => _ScreenViewCustomerState();
}

class _ScreenViewCustomerState extends State<ScreenViewCustomer> {
  final _itemsController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();
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
                leading: Iconify(Bx.user, color: AppTheme.color(context)),
                title: "Name".text(),
                subtitle: selectedCustomer.fullName.text(),
              ),
              ListTile(
                leading: Iconify(Bx.envelope, color: AppTheme.color(context)),
                title: "Email".text(),
                subtitle: selectedCustomer.email.text(),
              ),
              ListTile(
                leading: Iconify(Bx.phone, color: AppTheme.color(context)),
                title: "Phone".text(),
                subtitle: selectedCustomer.phoneNumber.text(),
              ),
              ListTile(
                leading: Iconify(Bx.map, color: AppTheme.color(context)),
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
                leading: Iconify(Bx.walk, color: AppTheme.color(context)),
                title: "Visits".text(),
                subtitle: selectedCustomer.visits.toString().text(),
              ),
              ListTile(
                leading: Iconify(Bx.star, color: AppTheme.color(context)),
                title: "Points".text(),
                trailing: Obx(
                  () => _itemsController.updatingCustomerPoints.value
                      ? MistLoader1()
                      : IconButton(
                          onPressed: _addPoints,
                          icon: Icon(Icons.add),
                        ),
                ),
                subtitle: selectedCustomer.points.toStringAsFixed(2).text(),
              ),
              ListTile(
                leading: Iconify(Bx.money, color: AppTheme.color(context)),
                title: "Total Amount Spent".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  selectedCustomer.purchaseValue,
                  _userController.user.value?.baseCurrence ?? '',
                ).text(),
              ),
              ListTile(
                leading: Iconify(Carbon.money, color: AppTheme.color(context)),
                title: "Profit Brought".text(),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  selectedCustomer.inboundProfit,
                  _userController.user.value?.baseCurrence ?? '',
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

  void _addPoints() {
    final pointsController = TextEditingController();
    Get.defaultDialog(
      title: "Add Points",
      content: MistFormInput(label: "Points", controller: pointsController),
      actions: [
        "cancel".text().textButton(onPressed: () => Get.back()),
        "add".text().textButton(
          onPressed: () {
            final points = double.tryParse(pointsController.text);
            if (points == null) {
              Toaster.showError("invalid points");
              return;
            }
            _updateCustomerPoints(points);
            Get.back();
          },
        ),
      ],
    );
  }

  void _updateCustomerPoints(double points) async {
    final response = await _itemsController.updateCustomerPoints(
      widget.model.hexId,
      points,
    );
    if (response == null) {
      return;
    }
    Toaster.showSuccess("points updated");
    if (!mounted) return;
    setState(() {
      widget.model.points = response.points;
      widget.model.purchaseValue = response.purchaseValue;
      widget.model.inboundProfit = response.inboundProfit;
    });
  }
}
