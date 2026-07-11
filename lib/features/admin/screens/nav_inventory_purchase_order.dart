import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/constants/constants.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/widgets/layouts/chips.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/data/models/purchase_order_model.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/inventory/screens/screen_view_purchase_order.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';

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
      _inventory.loadPurchaseOrders(page: 1);
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

  Map<String, List<PurchaseOrderModel>> _groupOrdersByDate(List<PurchaseOrderModel> list) {
    final Map<String, List<PurchaseOrderModel>> groups = {};
    for (var order in list) {
      final header = MistDateUtils.formatDayHeader(order.createdAt);
      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(order);
    }
    return groups;
  }

  Widget _buildDateHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.color(context).withAlpha(15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.color(context).withAlpha(200),
              ),
            ),
          ),
          8.gapWidth,
          Text(
            "($count)",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          16.gapWidth,
          Expanded(
            child: Divider(
              color: AppTheme.color(context).withAlpha(20),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(PurchaseOrderModel model) {
    final themeColor = AppTheme.color(context);
    final surfaceColor = AppTheme.surface(context);
    
    Color badgeBg;
    Color badgeText;
    IconData statusIcon;

    switch (model.status.toLowerCase()) {
      case 'accepted':
        badgeBg = Colors.green.withAlpha(25);
        badgeText = Colors.green.shade700;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'pending':
        badgeBg = Colors.orange.withAlpha(25);
        badgeText = Colors.orange.shade700;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'declined':
        badgeBg = Colors.red.withAlpha(25);
        badgeText = Colors.red.shade700;
        statusIcon = Icons.cancel_outlined;
        break;
      case 'partial-received':
        badgeBg = Colors.blue.withAlpha(25);
        badgeText = Colors.blue.shade700;
        statusIcon = Icons.pending_actions_outlined;
        break;
      default:
        badgeBg = Colors.grey.withAlpha(25);
        badgeText = Colors.grey.shade700;
        statusIcon = Icons.archive_outlined;
    }

    final totalItems = model.inventoryItems.length;
    final totalQtyOrdered = model.inventoryItems.fold(0.0, (val, el) => val + el.quantity);
    final totalQtyReceived = model.inventoryItems.fold(0.0, (val, el) => val + el.counted);
    final totalCost = model.inventoryItems.fold(0.0, (val, el) => val + el.amount);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withAlpha(15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => ScreenViewPurchaseOrder(model: model)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: themeColor.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.shopping_cart_outlined, color: themeColor.withAlpha(200), size: 20),
                        ),
                        12.gapWidth,
                        Text(
                          model.label.isEmpty || model.label == '-' ? "Purchase Order" : model.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: themeColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      MistDateUtils.formatTime(model.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                12.gapHeight,
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 12, color: badgeText),
                          4.gapWidth,
                          Text(
                            model.status.toUpperCase(),
                            style: TextStyle(
                              color: badgeText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "$totalItems ${totalItems == 1 ? 'product' : 'products'}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                if (model.notes.isNotEmpty) ...[
                  12.gapHeight,
                  Text(
                    model.notes,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeColor.withAlpha(140),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                Divider(height: 24, color: themeColor.withAlpha(15)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatColumn(
                      "Ordered Qty",
                      "${totalQtyOrdered.toInt()}",
                      themeColor,
                    ),
                    _buildStatColumn(
                      "Received Qty",
                      "${totalQtyReceived.toInt()}",
                      totalQtyReceived == totalQtyOrdered ? Colors.green.shade700 : Colors.blue.shade700,
                    ),
                    _buildStatColumn(
                      "Total Cost",
                      CurrenceConverter.getCurrenceFloatInStrings(totalCost, Get.find<UserController>().user.value?.baseCurrence ?? ''),
                      themeColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        4.gapHeight,
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
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
          await loadInventoryPurchaseOrders();
          _refreshController.refreshCompleted();
        },

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
              
              final groupedOrders = _groupOrdersByDate(_inventory.purchaseOrders);
              final dateKeys = groupedOrders.keys.toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dateKeys.length,
                itemBuilder: (context, dateIndex) {
                  final dateHeader = dateKeys[dateIndex];
                  final orders = groupedOrders[dateHeader]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateHeader(dateHeader, orders.length),
                      ...orders.map((order) => _buildModernCard(order)),
                    ],
                  );
                },
              );
            }),
          ],
        ),
      );
    });
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
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
}
