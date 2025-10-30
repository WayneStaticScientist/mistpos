import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/navs/admin/nav_admin_employees.dart';
import 'package:mistpos/navs/admin/nav_admin_overview.dart';
import 'package:mistpos/navs/admin/screen_list_customers.dart';
import 'package:mistpos/navs/items_navs/nav_category_list.dart';
import 'package:mistpos/navs/items_navs/nav_items_list.dart';
import 'package:mistpos/navs/items_navs/nav_discounts_list.dart';
import 'package:mistpos/navs/items_navs/nav_modifiers_list.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/screens/basic/screen_add_customer.dart';
import 'package:mistpos/screens/basic/screen_add_employee.dart';
import 'package:mistpos/widgets/layouts/receits_layout_view.dart';
import 'package:mistpos/widgets/layouts/mist_admin_dashboard.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final navs = {
    "Items": NavItemsList(),
    "Overview": NavAdminOverView(),
    'Receits': ReceitsLayoutView(),
    "Categories": NavCategoryList(),
    "Modifiers": NavModifiersList(),
    "Discounts": NavDiscountsList(),
    "Employees": NavAdminEmployees(),
    "Customers": NavListCustomers(),
  };

  @override
  void initState() {
    super.initState();
    _adminController.getAdminStats();
  }

  String _selectedIndex = "Overview";
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > (ScreenSizes.maxWidth);
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex.text(style: TextStyle(color: Colors.white)),
        backgroundColor: Get.theme.colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            SizedBox(width: ScreenSizes.navMaxWidth, child: _makeDrawer(false)),
          Padding(
            padding: EdgeInsetsGeometry.all(9),
            child: navs[_selectedIndex] ?? SizedBox.shrink(),
          ).expanded1,
        ],
      ),
      drawer: isLargeScreen ? null : _makeDrawer(true),
      floatingActionButton: ["Employees", "Customers"].contains(_selectedIndex)
          ? FloatingActionButton(
              onPressed: _add,
              elevation: 0,
              child: Icon(Icons.add, color: Colors.white),
            )
          : SizedBox.shrink(),
    );
  }

  void _add() {
    if (_selectedIndex == "Employees") {
      Get.to(() => ScreenAddEmployee());
    }
    if (_selectedIndex == "Customers") {
      Get.to(() => ScreenAddCustomer());
    }
  }

  _makeDrawer(bool r) {
    return Obx(
      () => MistAdminDashboard(
        userName: _userController.user.value?.fullName ?? "User",
        userEmail: _userController.user.value?.email ?? "Email",
        selectedTile: _selectedIndex,
        onTap: (String label) {
          setState(() {
            _selectedIndex = label;
          });
          if (r) Get.back();
        },
      ),
    );
  }
}
