import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/navs/admin/nav_admin_employees.dart';
import 'package:mistpos/navs/admin/nav_admin_overview.dart';
import 'package:mistpos/navs/items_navs/nav_category_list.dart';
import 'package:mistpos/navs/items_navs/nav_items_list.dart';
import 'package:mistpos/navs/items_navs/nav_discounts_list.dart';
import 'package:mistpos/navs/items_navs/nav_modifiers_list.dart';
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
  };

  @override
  void initState() {
    super.initState();
    _adminController.getAdminStats();
  }

  String _selectedIndex = "Overview";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex.text(style: TextStyle(color: Colors.white)),
        backgroundColor: Get.theme.colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(9),
        child: navs[_selectedIndex] ?? SizedBox.shrink(),
      ),
      drawer: Obx(
        () => MistAdminDashboard(
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
      ),
      floatingActionButton: ["Employees"].contains(_selectedIndex)
          ? FloatingActionButton(onPressed: _add, child: Icon(Icons.add))
          : SizedBox.shrink(),
    );
  }

  void _add() {
    if (_selectedIndex == "Employees") {
      Get.to(() => ScreenAddEmployee());
    }
  }
}
