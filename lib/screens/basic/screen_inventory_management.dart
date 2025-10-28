import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/inventory/screen_add_supplier.dart';
import 'package:mistpos/widgets/layouts/inventory_nav_bar.dart';
import 'package:mistpos/navs/admin/nav_inventory_purchase_order.dart';
import 'package:mistpos/navs/admin/nav_inventory_suppliers_list.dart';
import 'package:mistpos/screens/inventory/screen_add_purchase_order.dart';

class ScreenInventoryManagement extends StatefulWidget {
  const ScreenInventoryManagement({super.key});

  @override
  State<ScreenInventoryManagement> createState() =>
      _ScreenInventoryManagementState();
}

class _ScreenInventoryManagementState extends State<ScreenInventoryManagement> {
  final _userController = Get.find<UserController>();
  final navs = {
    "Purchase Orders": const NavInventoryPurchaseOrder(),
    "Suppliers": NavInventorySuppliersList(),
  };
  String _selectedIndex = "Purchase Orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex.text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Get.theme.colorScheme.onPrimary,
      ),
      body: navs[_selectedIndex] ?? SizedBox.shrink(),
      drawer: MistInventoryNavBar(
        userName: _userController.user.value?.fullName ?? "User",
        userEmail: _userController.user.value?.email ?? "Email",
        selectedTile: _selectedIndex,
        onTap: (String label) {
          setState(() {
            _selectedIndex = label;
          });
          Navigator.pop(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openSelectedScreen,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _openSelectedScreen() {
    if (_selectedIndex == "Purchase Orders") {
      Get.to(() => ScreenAddPurchaseOrder());
    }
    if (_selectedIndex == "Suppliers") {
      Get.to(() => ScreenAddSupplier());
    }
  }
}
