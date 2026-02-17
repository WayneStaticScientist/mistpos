import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/models/expense_model.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/controllers/expenses_controller.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/screens/inventory/screen_view_expense.dart';

class NavInventoryExpenses extends StatefulWidget {
  const NavInventoryExpenses({super.key});

  @override
  State<NavInventoryExpenses> createState() => _NavInventoryExpensesState();
}

class _NavInventoryExpensesState extends State<NavInventoryExpenses> {
  final _refreshController = RefreshController();
  final _expenses = Get.find<ExpensesController>();
  final _inventory = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  String _statusFilter = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inventory.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventory.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _expenses.fetchPaginatedExpenses();
      _initializeTimer();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _refreshController.dispose(); // Important to dispose the RefreshController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_inventory.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventory.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          await loadExpenses();
          _refreshController.refreshCompleted();
        },

        // 💡 INFINITE SCROLLING LOGIC (onLoading)
        onLoading: () async {
          if (_expenses.paginatedExpensesPage.value <
              _expenses.totalPaginatedExpenses.value) {
            await _expenses.fetchPaginatedExpenses(
              page: _inventory.purchaseOrderPage.value + 1,
              search: _searchTerm,
              status: _statusFilter,
            );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        child: ListView(
          children: [
            MistSearchField(label: "Expenses ", controller: _searchController),
            ListView(
              scrollDirection: Axis.horizontal,
              children: Inventory.inventoryExpense
                  .map(
                    (e) =>
                        MistChip(
                          label: e['label'] ?? '',
                          selected: _statusFilter == e['value'],
                        ).onTap(() {
                          setState(() {
                            _statusFilter = e['value'] ?? '';
                          });
                          loadExpenses();
                        }),
                  )
                  .toList(),
            ).sizedBox(height: 60, width: double.infinity),
            Obx(() {
              if (_expenses.fetchingPaginatedExpenses.value &&
                  _expenses.paginatedExpenses.isEmpty) {
                return MistLoader1().center();
              }
              if (_expenses.paginatedExpenses.isEmpty &&
                  !_expenses.fetchingPaginatedExpenses.value) {
                return "No Expense found from the list".text().center();
              }
              return ListView.builder(
                shrinkWrap: true, // IMPORTANT
                physics: NeverScrollableScrollPhysics(),
                itemCount: _expenses.paginatedExpenses.length,
                itemBuilder: (context, index) {
                  return _buildTile(_expenses.paginatedExpenses[index]);
                },
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTile(ExpenseModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Get.to(() => ScreenViewExpense(model: model)),
      leading: Iconify(Bx.money, color: AppTheme.color(context)),
      subtitle: MistDateUtils.getInformalDate(model.date).text(),
      title: Text((model.category['label'] ?? '-=')),
      trailing: _getIcon(model.status),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        // Start a new search from page 1
        _expenses.fetchPaginatedExpenses(
          search: _searchTerm,
          page: 1,
          status: _statusFilter,
        );
      }
    });
  }

  Future<void> loadExpenses() async {
    await _expenses.fetchPaginatedExpenses(
      page: 1,
      search: _searchTerm,
      status: _statusFilter,
    );
    _refreshController.loadComplete();
  }

  Widget _getIcon(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.orange, size: 35);
    }
    if (status.toLowerCase() == "declined") {
      return Iconify(Bx.x, color: Colors.red, size: 35);
    }
    if (status.toLowerCase() == "accepted") {
      return Iconify(Bx.check_circle, color: Colors.green, size: 35);
    }

    return Iconify(Bx.archive, color: Colors.grey, size: 35);
  }
}
