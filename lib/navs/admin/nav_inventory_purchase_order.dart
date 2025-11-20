import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/inventory/screen_view_purchase_order.dart';

class NavInventoryPurchaseOrder extends StatefulWidget {
  const NavInventoryPurchaseOrder({super.key});

  @override
  State<NavInventoryPurchaseOrder> createState() =>
      _NavInventoryPurchaseOrderState();
}

class _NavInventoryPurchaseOrderState extends State<NavInventoryPurchaseOrder> {
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
      _inventory.loadPurchaseOrders(page: 1);
    });
    _initializeTimer();
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
          !(MistSubscriptionUtils.proList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          await loadInventoryPurchaseOrders();
          _refreshController.refreshCompleted();
        },

        // 💡 INFINITE SCROLLING LOGIC (onLoading)
        onLoading: () async {
          if (_inventory.purchaseOrderPage.value <
              _inventory.purchaseOrderTotalPages.value) {
            await _inventory.loadPurchaseOrders(
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
            MistSearchField(label: "Search ", controller: _searchController),
            ListView(
              scrollDirection: Axis.horizontal,
              children: Inventory.purchaseOrderStatus
                  .map(
                    (e) =>
                        MistChip(
                          label: e['label'] ?? '',
                          selected: _statusFilter == e['value'],
                        ).onTap(() {
                          setState(() {
                            _statusFilter = e['value'] ?? '';
                          });
                          loadInventoryPurchaseOrders();
                        }),
                  )
                  .toList(),
            ).sizedBox(height: 60, width: double.infinity),
            Obx(() {
              if (_inventory.purchaseOrdersLoading.value &&
                  _inventory.purchaseOrders.isEmpty) {
                return MistLoader1().center();
              }
              if (_inventory.purchaseOrders.isEmpty &&
                  !_inventory.purchaseOrdersLoading.value) {
                return "No Purchase Orders found. Click + to add new purchaseOrder"
                    .text()
                    .center();
              }
              return ListView.builder(
                shrinkWrap: true, // IMPORTANT
                physics: NeverScrollableScrollPhysics(),
                itemCount: _inventory.purchaseOrders.length,
                itemBuilder: (context, index) {
                  return _buildTile(_inventory.purchaseOrders[index]);
                },
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTile(PurchaseOrderModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Get.to(() => ScreenViewPurchaseOrder(model: model)),
      leading: CircleAvatar(child: Iconify(Bx.tag, color: Colors.white)),
      subtitle: MistDateUtils.getInformalDate(model.createdAt).text(),
      title: (model.label).text(),
      trailing: _getIcon(model.status),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        // Start a new search from page 1
        _inventory.loadPurchaseOrders(
          search: _searchTerm,
          page: 1,
          status: _statusFilter,
        );
      }
    });
  }

  Future<void> loadInventoryPurchaseOrders() async {
    await _inventory.loadPurchaseOrders(
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
    if (status.toLowerCase() == "partial-received") {
      return Iconify(Bx.time, color: Colors.yellow, size: 35);
    }
    return Iconify(Bx.archive, color: Colors.grey, size: 35);
  }
}
