import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NavAdminEmployees extends StatefulWidget {
  const NavAdminEmployees({super.key});

  @override
  State<NavAdminEmployees> createState() => _NavAdminEmployeesState();
}

class _NavAdminEmployeesState extends State<NavAdminEmployees> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onRefresh() {
    _adminController.fetchEmployees();
  }

  @override
  void initState() {
    super.initState();
    _adminController.fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
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
  }

  Widget _buildLoader() {
    return [
      18.gapHeight,
      LoadingAnimationWidget.staggeredDotsWave(
        color: Get.theme.colorScheme.primary,
        size: 50,
      ),
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
                  leading: CircleAvatar(
                    backgroundColor: Get.theme.colorScheme.primary,
                    child: Iconify(
                      Bx.user,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                  title: e.fullName.text(),
                  subtitle: _userController.user.value?.hexId == e.id
                      ? "You".text()
                      : e.role.text(),
                ),
              )
              .toList()
              .column(mainAxisSize: MainAxisSize.min);
  }
}
