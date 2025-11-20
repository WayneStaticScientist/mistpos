import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/currence/edit_currencies.dart';

class ScreenViewCompany extends StatefulWidget {
  final CompanyModel company;
  const ScreenViewCompany({super.key, required this.company});

  @override
  State<ScreenViewCompany> createState() => _ScreenViewCompanyState();
}

class _ScreenViewCompanyState extends State<ScreenViewCompany> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _inventoryController = Get.find<InventoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.company.name.text()),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          MistMordernLayout(
            label: "Edit",
            children: [
              18.gapHeight,
              Obx(() {
                if (_userController.switchingStore.value) {
                  return MistLoader1();
                }
                return ListTile(
                  onTap: _switch,
                  title: "Switch to this Store".text(
                    style: TextStyle(color: Colors.green),
                  ),
                  tileColor: Colors.green.withAlpha(100),
                  leading: Iconify(Tabler.switch_2, color: Colors.green),
                ).visibleIfNot(
                  _userController.user.value?.company == widget.company.hexId,
                );
              }),
              ListTile(
                title: "Change Name".text(),
                onTap: _changeName,
                leading: Iconify(Bx.edit, color: AppTheme.color(context)),
              ),
              ListTile(
                onTap: () => Get.to(() => EditCurrencies()),
                title: "Adjust Exchange Rates".text(),
                leading: Iconify(Bx.money, color: AppTheme.color(context)),
              ).visibleIf(
                _userController.user.value?.company == widget.company.hexId,
              ),
              ListTile(
                onTap: _deleteStore,
                title: "Delete Store".text(style: TextStyle(color: Colors.red)),
                leading: Iconify(Bx.trash, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _changeName() {
    final name = TextEditingController(text: widget.company.name);
    Get.defaultDialog(
      title: "Change Name",
      content: MistFormInput(label: "New Name", controller: name),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "change".text().textButton(
          onPressed: () async {
            if (name.text.trim().isEmpty) {
              Toaster.showError("Name is required");
              return;
            }
            Get.back();
            widget.company.name = name.text;
            final result = await _adminController.updateCompany(
              widget.company.toJson(),
              widget.company.hexId,
            );
            if (result) {
              Toaster.showSuccess("store update was succesffully");
            }
            if (!mounted) return;
            setState(() {});
          },
        ),
      ],
    );
  }

  void _deleteStore() {
    Get.defaultDialog(
      title: "Delete Store",
      content: "Are you sure you want to delete this store".text(),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "delete".text().textButton(
          onPressed: () async {
            Get.back();
            final result = await _adminController.deleteCompany(
              widget.company.hexId,
            );
            if (result) {
              Get.back();
              Toaster.showSuccess("store deleted successfully");
            }
          },
        ),
      ],
    );
  }

  void _switch() async {
    final result = await _userController.switchStore(widget.company.hexId);
    if (result) {
      _inventoryController.loadCompany();
    }
  }
}
