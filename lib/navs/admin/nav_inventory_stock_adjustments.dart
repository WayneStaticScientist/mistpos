import 'dart:async';

import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/inventory/screen_view_stock_adjustment.dart';

class NavInventoryStockAdjustments extends StatefulWidget {
  const NavInventoryStockAdjustments({super.key});

  @override
  State<NavInventoryStockAdjustments> createState() =>
      _NavInventoryStockAdjustmentsState();
}

class _NavInventoryStockAdjustmentsState
    extends State<NavInventoryStockAdjustments> {
  final _refreshController = RefreshController();
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
          !(MistSubscriptionUtils.proList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _inventory.loadStockAdjustments(page: 1);
      _initializeTimer();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_inventory.company.value == null ||
          !(MistSubscriptionUtils.proList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          await _inventory.loadStockAdjustments(
            page: 1,
            search: _searchTerm,
            status: _statusFilter,
          );
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
        },
        onLoading: () async {
          if (_inventory.stockAdjustOrderPage.value <
              _inventory.stockAdjustOrderTotalPages.value) {
            await _inventory.loadStockAdjustments(
              page: _inventory.stockAdjustOrderPage.value + 1,
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
            MistSearchField(label: "Search ", controller: _searchController),
            ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MistChip(label: "All", selected: _statusFilter == "").onTap(() {
                  setState(() {
                    _statusFilter = '';
                  });
                  loadInventoryStockerOrders();
                }),
                ...Inventory.adjustStockReasons.map(
                  (e) =>
                      MistChip(
                        label: e['label'] ?? '',
                        selected: _statusFilter == e['value'],
                      ).onTap(() {
                        setState(() {
                          _statusFilter = e['value'] ?? '';
                        });
                        loadInventoryStockerOrders();
                      }),
                ),
              ],
            ).sizedBox(width: double.infinity, height: 70),
            Obx(() {
              if (_inventory.stockerOrders.isEmpty &&
                  _inventory.stockAdjustOrdersLoading.value) {
                return MistLoader1().center();
              }
              if (_inventory.stockerOrders.isEmpty &&
                  !_inventory.stockAdjustOrdersLoading.value) {
                return "No Stock Adjustments Found ".text().center();
              }
              return ListView.builder(
                shrinkWrap: true, // IMPORTANT
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildTile(_inventory.stockerOrders[index]);
                },
                itemCount: _inventory.stockerOrders.length,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTile(StockAdjustmentModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),

      onTap: () => Get.to(() => ScreenViewStockAdjustment(model: model)),
      leading: CircleAvatar(child: Iconify(Bx.tag, color: Colors.white)),
      title:
          [
            (model.label).text(),
            MistDateUtils.getInformalDate(
              model.createdAt,
            ).text(style: TextStyle(fontSize: 12, color: Colors.grey)),
            Inventory.adjustStockReasons
                    .firstWhere(
                      (element) => element['value'] == model.reason,
                    )['label']
                    ?.text(style: TextStyle(fontSize: 12, color: Colors.red)) ??
                ''.text(),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        _inventory.loadStockAdjustments(
          search: _searchTerm,
          page: 1,
          status: _statusFilter,
        );
      }
    });
  }

  void loadInventoryStockerOrders() async {
    await _inventory.loadStockAdjustments(
      page: 1,
      search: _searchTerm,
      status: _statusFilter,
    );
    _refreshController.loadComplete();
  }
}
