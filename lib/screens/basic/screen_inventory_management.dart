import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/screens/inventory/screen_add_transfer_order.dart';
import 'package:mistpos/widgets/layouts/inventory_nav_bar.dart';
import 'package:mistpos/screens/inventory/screen_add_supplier.dart';
import 'package:mistpos/navs/admin/nav_inventory_purchase_order.dart';
import 'package:mistpos/navs/admin/nav_inventory_suppliers_list.dart';
import 'package:mistpos/navs/admin/nav_inventory_stock_adjustments.dart';
import 'package:mistpos/screens/inventory/screen_add_purchase_order.dart';
import 'package:mistpos/screens/inventory/screen_add_stockadjustments.dart';

class ScreenInventoryManagement extends StatefulWidget {
  const ScreenInventoryManagement({super.key});

  @override
  State<ScreenInventoryManagement> createState() =>
      _ScreenInventoryManagementState();
}

class _ScreenInventoryManagementState extends State<ScreenInventoryManagement> {
  final _userController = Get.find<UserController>();
  final navs = {
    "Suppliers": NavInventorySuppliersList(),
    "Transfer Orders": const SizedBox.shrink(),
    "Stock Adjustments": NavInventoryStockAdjustments(),
    "Purchase Orders": const NavInventoryPurchaseOrder(),
  };
  String _selectedIndex = "Purchase Orders";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > (ScreenSizes.maxWidth);
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex.text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            SizedBox(
              width: ScreenSizes.navMaxWidth,
              child: _buildNavBar(false),
            ),
          Expanded(child: navs[_selectedIndex] ?? SizedBox.shrink()),
        ],
      ),
      drawer: isLargeScreen ? null : _buildNavBar(true),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
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
    if (_selectedIndex == "Stock Adjustments") {
      Get.to(() => ScreenAddStockadjustments());
    }
    if (_selectedIndex == "Transfer Orders") {
      Get.to(() => ScreenAddTransferOrder());
    }
  }

  Widget _buildNavBar(bool goback) {
    return MistInventoryNavBar(
      userName: _userController.user.value?.fullName ?? "User",
      userEmail: _userController.user.value?.email ?? "Email",
      selectedTile: _selectedIndex,
      onTap: (String label) {
        setState(() {
          _selectedIndex = label;
        });
        if (goback) Get.back();
      },
    );
  }
}
