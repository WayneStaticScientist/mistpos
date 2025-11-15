import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/navs/admin/daily_sales.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/navs/admin/nav_shifts_view.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/navs/admin/nav_admin_stores.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/navs/admin/nav_admin_employees.dart';
import 'package:mistpos/navs/admin/nav_admin_overview.dart';
import 'package:mistpos/navs/items_navs/nav_items_list.dart';
import 'package:mistpos/screens/basic/screen_add_store.dart';
import 'package:mistpos/navs/admin/nav_transfer_orders.dart';
import 'package:mistpos/navs/admin/nav_inventory_counts.dart';
import 'package:mistpos/navs/admin/nav_sales_by_payment.dart';
import 'package:mistpos/navs/admin/screen_list_customers.dart';
import 'package:mistpos/navs/admin/nav_inventory_history.dart';
import 'package:mistpos/navs/admin/nav_sales_by_employee.dart';
import 'package:mistpos/screens/basic/screen_add_employee.dart';
import 'package:mistpos/screens/basic/screen_add_customer.dart';
import 'package:mistpos/navs/items_navs/nav_category_list.dart';
import 'package:mistpos/navs/items_navs/nav_discounts_list.dart';
import 'package:mistpos/navs/admin/nav_inventory_valuation.dart';
import 'package:mistpos/navs/items_navs/nav_modifiers_list.dart';
import 'package:mistpos/widgets/layouts/receits_layout_view.dart';
import 'package:mistpos/navs/admin/nav_inventory_production.dart';
import 'package:mistpos/widgets/layouts/mist_admin_dashboard.dart';
import 'package:mistpos/screens/inventory/screen_add_supplier.dart';
import 'package:mistpos/screens/inventory/screen_add_production.dart';
import 'package:mistpos/navs/admin/nav_inventory_purchase_order.dart';
import 'package:mistpos/navs/admin/nav_inventory_suppliers_list.dart';
import 'package:mistpos/navs/admin/nav_inventory_stock_adjustments.dart';
import 'package:mistpos/screens/inventory/screen_add_transfer_order.dart';
import 'package:mistpos/screens/inventory/screen_add_purchase_order.dart';
import 'package:mistpos/screens/inventory/screen_add_inventory_counts.dart';
import 'package:mistpos/screens/inventory/screen_add_stockadjustments.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  final _dailySalesKey = GlobalKey<DailySalesState>();
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _adminOverviewKey = GlobalKey<NavAdminOverViewState>();
  final _salesByEmployeeKeys = GlobalKey<NavSalesByEmployeeState>();
  final _salesByPayment = GlobalKey<NavSalesByPaymentState>();
  final _shiftsKey = GlobalKey<NavShiftsViewState>();
  final _navInvHistoryKey = GlobalKey<NavInventoryHistoryState>();
  final _navInvEvaluation = GlobalKey<NavInventoryValuationState>();
  late final navs = {
    "Items": NavItemsList(),
    "Overview": NavAdminOverView(key: _adminOverviewKey),
    'Receits': ReceitsLayoutView(),
    "Categories": NavCategoryList(),
    "Modifiers": NavModifiersList(),
    "Discounts": NavDiscountsList(),
    "Employees": NavAdminEmployees(),
    "Customers": NavListCustomers(),
    "Stores": NavAdminStores(),
    "Daily Sales": DailySales(key: _dailySalesKey),
    "Sales By Employee": NavSalesByEmployee(key: _salesByEmployeeKeys),
    "Sales By Payments": NavSalesByPayment(key: _salesByPayment),
    "Shifts": NavShiftsView(key: _shiftsKey),
    "Transfer Orders": const NavTransferOrders(),
    "Productions": const NavInventoryProduction(),
    "Inventory Counts": const NavInventoryCounts(),
    "Suppliers": const NavInventorySuppliersList(),
    "Purchase Orders": const NavInventoryPurchaseOrder(),
    "Stock Adjustments": const NavInventoryStockAdjustments(),
    "Inventory History": NavInventoryHistory(key: _navInvHistoryKey),
    "Inventory Valuation": NavInventoryValuation(key: _navInvEvaluation),
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
        actions: [
          IconButton(
            onPressed: _printDocument,
            icon: Iconify(Bx.printer, color: Colors.white),
          ).visibleIf(
            [
              "Overview",
              "Daily Sales",
              "Sales By Employee",
              "Sales By Payments",
              "Shifts",
              "Inventory History",
              "Inventory Valuation",
            ].contains(_selectedIndex),
          ),
        ],
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
      floatingActionButton:
          [
            "Employees",
            "Customers",
            'Stores',
            "Transfer Orders",
            "Productions",
            "Inventory Counts",
            "Suppliers",
            "Purchase Orders",
            "Stock Adjustments",
          ].contains(_selectedIndex)
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
    if (_selectedIndex == 'Stores') {
      Get.to(() => ScreenAddStore());
    }
    if (_selectedIndex == 'Purchase Orders') {
      Get.to(() => ScreenAddPurchaseOrder());
    }
    if (_selectedIndex == 'Transfer Orders') {
      Get.to(() => ScreenAddTransferOrder());
    }
    if (_selectedIndex == 'Productions') {
      Get.to(() => ScreenAddProduction());
    }
    if (_selectedIndex == 'Inventory Counts') {
      Get.to(() => ScreenAddInventoryCounts());
    }
    if (_selectedIndex == 'Suppliers') {
      Get.to(() => ScreenAddSupplier());
    }
    if (_selectedIndex == 'Stock Adjustments') {
      Get.to(() => ScreenAddStockadjustments());
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

  void _printDocument() {
    if (_selectedIndex == 'Overview') {
      _adminOverviewKey.currentState?.printDocument();
      return;
    }
    if (_selectedIndex == 'Daily Sales') {
      _dailySalesKey.currentState?.printDocument();
      return;
    }
    if (_selectedIndex == "Sales By Employee") {
      _salesByEmployeeKeys.currentState?.printDocument();
      return;
    }
    if (_selectedIndex == "Sales By Payments") {
      _salesByPayment.currentState?.printDocument();
      return;
    }
    if (_selectedIndex == "Shifts") {
      _shiftsKey.currentState?.printDocument();
      return;
    }
    if (_selectedIndex == "Inventory History") {
      _navInvHistoryKey.currentState?.printDocument();
      return;
    }
    if (_selectedIndex == "Inventory Valuation") {
      _navInvHistoryKey.currentState?.printDocument();
      return;
    }
    Toaster.showError("page is unprintable");
  }
}
