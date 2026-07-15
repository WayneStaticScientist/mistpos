import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/data/models/transfer_order_model.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/inventory/screens/screen_view_transfer_order.dart';
import 'package:mistpos/core/themes/app_theme.dart';

class NavTransferOrders extends StatefulWidget {
  const NavTransferOrders({super.key});

  @override
  State<NavTransferOrders> createState() => _NavTransferOrdersState();
}

class _NavTransferOrdersState extends State<NavTransferOrders> {
  final _refreshController = RefreshController();
  final _iventoryController = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounce;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_iventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _iventoryController.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _iventoryController.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _initializeTimer();
      _iventoryController.loadTransferOrders(page: 1);
    });
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<TransferOrderModel>> _groupTransfersByDate(List<TransferOrderModel> list) {
    final Map<String, List<TransferOrderModel>> groups = {};
    for (var transfer in list) {
      if (transfer.createdAt == null) continue;
      final header = MistDateUtils.formatDayHeader(transfer.createdAt!);
      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(transfer);
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

  Widget _buildModernCard(TransferOrderModel model) {
    final themeColor = AppTheme.color(context);
    final surfaceColor = AppTheme.surface(context);

    final totalItems = model.inventoryItems.length;
    final totalQtyTransferred = model.inventoryItems.fold(0.0, (val, el) => val + el.quantity);
    final totalSuccessfulTransfers = model.inventoryItems.where((e) => e.updated).length;

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
          onTap: () => Get.to(() => ScreenViewTransferOrder(model: model)),
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
                          child: Icon(Icons.swap_horiz_outlined, color: themeColor.withAlpha(200), size: 20),
                        ),
                        12.gapWidth,
                        Text(
                          model.label.isEmpty || model.label == '--' ? "Transfer Order" : model.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: themeColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    if (model.createdAt != null)
                      Text(
                        MistDateUtils.formatTime(model.createdAt!),
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
                        color: Colors.blue.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_shipping_outlined, size: 12, color: Colors.blue.shade700),
                          4.gapWidth,
                          Text(
                            "Stock Transfer",
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "$totalItems ${totalItems == 1 ? 'item' : 'items'}",
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
                      "Items Count",
                      "$totalItems",
                      themeColor,
                    ),
                    _buildStatColumn(
                      "Transferred Qty",
                      "${totalQtyTransferred.toInt()}",
                      themeColor,
                    ),
                    _buildStatColumn(
                      "Transfer Status",
                      "$totalSuccessfulTransfers / $totalItems Transferred",
                      totalSuccessfulTransfers == totalItems ? Colors.green.shade700 : Colors.orange.shade700,
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
      if (_iventoryController.company.value == null ||
          MistDateUtils.getDaysDifference(
                _iventoryController.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.proList.contains(
            _iventoryController.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          _iventoryController.loadTransferOrders(page: 1, search: _searchTerm);
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
        },
        onLoading: () async {
          if (_iventoryController.transferOrderPage.value <
              _iventoryController.transferOrderTotalPages.value) {
            await _iventoryController.loadTransferOrders(
              page: _iventoryController.transferOrderPage.value + 1,
              search: _searchTerm,
            );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        child: ListView(
          children: [
            MistSearchField(
              label: "Search Transfer Orders",
              controller: _searchController,
            ),
            10.gapHeight,
            Obx(() {
              if (_iventoryController.transferOrders.isEmpty &&
                  _iventoryController.loadingTransferOrders.value) {
                return MistLoader1().center();
              }
              if (_iventoryController.transferOrders.isEmpty &&
                  !_iventoryController.loadingTransferOrders.value) {
                return "No Transfer Orders Found ".text().center();
              }
              
              final groupedTransfers = _groupTransfersByDate(_iventoryController.transferOrders);
              final dateKeys = groupedTransfers.keys.toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: dateKeys.length,
                itemBuilder: (context, dateIndex) {
                  final dateHeader = dateKeys[dateIndex];
                  final transfers = groupedTransfers[dateHeader]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateHeader(dateHeader, transfers.length),
                      ...transfers.map((transfer) => _buildModernCard(transfer)),
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
        _iventoryController.loadTransferOrders(page: 1, search: _searchTerm);
        _refreshController.loadComplete();
      }
    });
  }
}
