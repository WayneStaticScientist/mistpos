import 'dart:async';

import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/constants/constants.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/widgets/layouts/chips.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/data/models/stock_adjustment_model.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/inventory/screens/screen_view_stock_adjustment.dart';
import 'package:mistpos/core/themes/app_theme.dart';

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
          MistDateUtils.getDaysDifference(
                _inventory.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
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

  Map<String, List<StockAdjustmentModel>> _groupAdjustmentsByDate(List<StockAdjustmentModel> list) {
    final Map<String, List<StockAdjustmentModel>> groups = {};
    for (var adjust in list) {
      final header = MistDateUtils.formatDayHeader(adjust.createdAt);
      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(adjust);
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

  Widget _buildModernCard(StockAdjustmentModel model) {
    final themeColor = AppTheme.color(context);
    final surfaceColor = AppTheme.surface(context);
    
    Color badgeBg;
    Color badgeText;
    IconData reasonIcon;
    String reasonLabel;

    switch (model.reason) {
      case 'add':
        badgeBg = Colors.green.withAlpha(25);
        badgeText = Colors.green.shade700;
        reasonIcon = Icons.add_circle_outline;
        reasonLabel = "Receive Items";
        break;
      case 'count':
        badgeBg = Colors.blue.withAlpha(25);
        badgeText = Colors.blue.shade700;
        reasonIcon = Icons.rule;
        reasonLabel = "Inventory Count";
        break;
      case 'loss':
        badgeBg = Colors.red.withAlpha(25);
        badgeText = Colors.red.shade700;
        reasonIcon = Icons.remove_circle_outline;
        reasonLabel = "Loss / Theft";
        break;
      case 'damaged':
        badgeBg = Colors.orange.withAlpha(25);
        badgeText = Colors.orange.shade700;
        reasonIcon = Icons.broken_image_outlined;
        reasonLabel = "Damaged";
        break;
      default:
        badgeBg = Colors.grey.withAlpha(25);
        badgeText = Colors.grey.shade700;
        reasonIcon = Icons.help_outline;
        reasonLabel = model.reason;
    }

    final totalItems = model.inventoryItems.length;
    final totalQty = model.inventoryItems.map((e) => e.quantity).fold(0.0, (val, el) => val + el);

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
          onTap: () => Get.to(() => ScreenViewStockAdjustment(model: model)),
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
                          child: Icon(Icons.assignment_outlined, color: themeColor.withAlpha(200), size: 20),
                        ),
                        12.gapWidth,
                        Text(
                          model.label.isEmpty || model.label == '--' ? "Stock Adjustment" : model.label,
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
                          Icon(reasonIcon, size: 12, color: badgeText),
                          4.gapWidth,
                          Text(
                            reasonLabel,
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
                      "Original Stock",
                      "${model.inventoryItems.map((e) => e.inStock).fold(0.0, (val, el) => val + el).toInt()}",
                      themeColor,
                    ),
                    _buildStatColumn(
                      "Adjusted Quantity",
                      "${model.reason == 'loss' || model.reason == 'damaged' ? '-' : '+'}${totalQty.toInt()}",
                      model.reason == 'loss' || model.reason == 'damaged' ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                    _buildStatColumn(
                      "Total After Adj",
                      "${model.inventoryItems.map((e) {
                        final stockAfter = model.reason == 'add'
                            ? e.inStock + e.quantity
                            : (model.reason == 'count' ? e.quantity : e.inStock - e.quantity);
                        return stockAfter;
                      }).fold(0.0, (val, el) => val + el).toInt()}",
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
              
              final groupedAdjustments = _groupAdjustmentsByDate(_inventory.stockerOrders);
              final dateKeys = groupedAdjustments.keys.toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dateKeys.length,
                itemBuilder: (context, dateIndex) {
                  final dateHeader = dateKeys[dateIndex];
                  final adjusts = groupedAdjustments[dateHeader]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateHeader(dateHeader, adjusts.length),
                      ...adjusts.map((adjust) => _buildModernCard(adjust)),
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
