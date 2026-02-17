import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/screens/basic/screen_add_employee.dart';
import 'package:mistpos/screens/basic/screen_change_employee.dart';

class ScreenAccountSelection extends StatefulWidget {
  const ScreenAccountSelection({super.key});

  @override
  State<ScreenAccountSelection> createState() => _ScreenAccountSelectionState();
}

class _ScreenAccountSelectionState extends State<ScreenAccountSelection> {
  final _refreshController = RefreshController();
  final _searchController = TextEditingController();
  final _userController = Get.find<UserController>();
  String _searchKey = "";
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _loadUsers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Select Account".text()),
      body:
          [
                MistSearchField(
                  label: "Search Accounts",
                  controller: _searchController,
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async {
                      await _userController.findRelatedAccounts();
                      _refreshController.refreshCompleted();
                    },
                    child: Obx(
                      () => ListView.builder(
                        itemBuilder: (context, index) {
                          if (index < _userController.relatedAccounts.length) {
                            return _buildTile(
                              _userController.relatedAccounts[index],
                            );
                          }
                          if (_userController.loadingRelatedAccounts.value) {
                            return _buildLoader();
                          }
                          if (_userController.relatedAccountsError.isNotEmpty) {
                            return [
                                  _userController.relatedAccountsError.value
                                      .text(),
                                ]
                                .row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                )
                                .padding(EdgeInsets.symmetric(vertical: 50));
                          }
                          return ["No more accounts".text()]
                              .row(mainAxisAlignment: MainAxisAlignment.center)
                              .padding(EdgeInsets.symmetric(vertical: 50));
                        },
                        itemCount: _userController.relatedAccounts.length + 1,
                      ),
                    ),
                  ),
                ),
              ]
              .column()
              .padding(EdgeInsets.all(14))
              .constrained(maxWidth: ScreenSizes.maxWidth)
              .center(),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () => Get.to(() => ScreenAddEmployee()),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ListTile _buildTile(User model) {
    return ListTile(
      onTap: () => Get.to(() => ScreenChangeEmployee(user: model)),
      title: model.fullName.text(),
      subtitle: model.role.text(),
      leading: CircleAvatar(
        child: model.fullName[0].toUpperCase().text(
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    if (_userController.loadingRelatedAccounts.value) {
      return [MistLoader1()]
          .row(mainAxisAlignment: MainAxisAlignment.center)
          .padding(EdgeInsets.symmetric(vertical: 50));
    }
    return const SizedBox.shrink();
  }

  void _loadUsers() async {
    await _userController.findRelatedAccounts(searchKey: _searchKey);
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchKey != searchTerm) {
        _searchKey = searchTerm;
        _loadUsers();
      }
    });
  }
}
