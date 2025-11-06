import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/screens/basic/screen_view_company.dart';

class NavAdminStores extends StatefulWidget {
  const NavAdminStores({super.key});

  @override
  State<NavAdminStores> createState() => _NavAdminStoresState();
}

class _NavAdminStoresState extends State<NavAdminStores> {
  final _adminController = Get.find<AdminController>();
  final _refreshController = RefreshController();
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adminController.loadCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        await _adminController.loadCompanies();
        _refreshController.refreshCompleted();
      },
      child: Obx(() {
        if (_adminController.loadingCompanies.value) {
          return Center(child: MistLoader1());
        }
        if (_adminController.companies.isEmpty) {
          return "No Companies".text().center();
        }
        return [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor:
                      _userController.user.value?.company ==
                          _adminController.companies[index].hexId
                      ? Colors.green.withAlpha(50)
                      : null,
                  onTap: () => Get.to(
                    () => ScreenViewCompany(
                      company: _adminController.companies[index],
                    ),
                  ),
                  leading: Iconify(Bx.store, color: AppTheme.color(context)),
                  subtitle: _adminController.companies[index].email.text(
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  title: _adminController.companies[index].name.text(),
                );
              },
              itemCount: _adminController.companies.length,
            ),
          ),
        ].column();
      }),
    );
  }
}
