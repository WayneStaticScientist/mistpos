import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/basic/screem_edit_employee.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';

class NavAdminEmployees extends StatefulWidget {
  const NavAdminEmployees({super.key});

  @override
  State<NavAdminEmployees> createState() => _NavAdminEmployeesState();
}

class _NavAdminEmployeesState extends State<NavAdminEmployees> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _inventoryController = Get.find<InventoryController>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onRefresh() {
    _adminController.fetchEmployees();
  }

  @override
  void initState() {
    super.initState();
    if (_inventoryController.company.value != null &&
        (MistSubscriptionUtils.basicList.contains(
          _inventoryController.company.value!.subscriptionType.type,
        )) &&
        MistDateUtils.getDaysDifference(
              _inventoryController.company.value!.subscriptionType.validUntil!,
            ) >=
            0) {
      _adminController.fetchEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_inventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventoryController
                    .company
                    .value!
                    .subscriptionType
                    .validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.basicList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(),
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Obx(
              () => _adminController.loadingEmployess.value
                  ? _buildLoader()
                  : _listEmployees(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLoader() {
    return [
      18.gapHeight,
      MistLoader1(),
      18.gapHeight,
      "Loading Employees".text(),
    ].column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget _listEmployees() {
    return _adminController.employees.isEmpty
        ? [
            Iconify(
              Carbon.no_ticket,
              size: 60,
              color: Get.theme.colorScheme.primary,
            ),
            18.gapHeight,
            "No Employees click new to add one".text(),
          ].column(mainAxisSize: MainAxisSize.min)
        : _adminController.employees
              .map(
                (e) => ListTile(
                  onTap: () =>
                      Get.to(() => ScreenEditEmployee(employeeModel: e)),
                  leading: CircleAvatar(
                    backgroundColor: Get.theme.colorScheme.primary,
                    child: Iconify(Bx.user, color: Colors.white),
                  ),
                  title: e.fullName.text(),
                  subtitle: _userController.user.value?.hexId == e.id
                      ? "You".text()
                      : e.role.text(),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chevron_right),
                  ),
                ),
              )
              .toList()
              .column(mainAxisSize: MainAxisSize.min);
  }
}
