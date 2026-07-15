import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/constants/constants.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/widgets/layouts/chips.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/data/models/inventory_count_model.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/features/inventory/screens/screen_view_inventory_count.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/themes/app_theme.dart';

class NavInventoryCounts extends StatefulWidget {
  const NavInventoryCounts({super.key});

  @override
  State<NavInventoryCounts> createState() => _NavInventoryCountsState();
}

class _NavInventoryCountsState extends State<NavInventoryCounts> {
  final _refreshController = RefreshController();
  final _iventoryController = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  String _statusFilter = "";
  Timer? _debounce;

  @override
  void initState() {
    if (_iventoryController.company.value != null &&
        MistDateUtils.getDaysDifference(
              _iventoryController.company.value!.subscriptionType.validUntil!,
            ) >=
            0 &&
        (MistSubscriptionUtils.proList.contains(
          _iventoryController.company.value!.subscriptionType.type,
        ))) {
      loadInventoryCounts();
      _initializeTimer();
    }
    super.initState();
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
          loadInventoryCounts();
          await Future.delayed(const Duration(milliseconds: 800));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          if (_iventoryController.inventoryCountsPage.value <
              _iventoryController.inventoryCountsTotalPages.value) {
            await _iventoryController.loadInventoriesCounts(
              page: _iventoryController.inventoryCountsPage.value + 1,
              search: _searchTerm,
              status: _statusFilter,
            );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              child: MistSearchField(
                label: "Search Inventory Counts",
                controller: _searchController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 8.0,
                children: Inventory.inventoryCountStatus
                    .map(
                      (e) =>
                          MistChip(
                            label: e['label'] ?? '',
                            selected: _statusFilter == e['value'],
                          ).onTap(() {
                            setState(() {
                              _statusFilter = e['value'] ?? '';
                            });
                            loadInventoryCounts();
                          }),
                    )
                    .toList(),
              ),
            ),
            Obx(() {
              if (_iventoryController.inventoryCounts.isEmpty &&
                  _iventoryController.inventoryCountsLoading.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: MistLoader1().center(),
                );
              }
              if (_iventoryController.inventoryCounts.isEmpty &&
                  !_iventoryController.inventoryCountsLoading.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: "No Inventory Counts found".text().center(),
                );
              }

              // Group the counts by date
              final groupedCounts = <String, List<InventoryCountModel>>{};
              for (var count in _iventoryController.inventoryCounts) {
                final date = count.createdAt;
                final dateHeader = date != null
                    ? MistDateUtils.formatDayHeader(date)
                    : "Unknown Date";
                groupedCounts.putIfAbsent(dateHeader, () => []).add(count);
              }

              final listItems = <Widget>[];
              groupedCounts.forEach((dateHeader, counts) {
                listItems.add(_buildDateHeader(dateHeader, counts.length));
                for (var count in counts) {
                  listItems.add(_buildModernCard(count));
                }
              });

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listItems,
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildDateHeader(String dateHeader, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dateHeader,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$count count${count > 1 ? 's' : ''}",
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.color(context).withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.color(context).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(InventoryCountModel model) {
    final isPending = model.status.toLowerCase() == "pending";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Status color configurations
    final statusColor = isPending ? Colors.amber[800]! : Colors.green[700]!;
    final statusBgColor = isPending
        ? Colors.amber.withValues(alpha: isDark ? 0.15 : 0.08)
        : Colors.green.withValues(alpha: isDark ? 0.15 : 0.08);

    // Items badge color configurations
    final itemsColor = Get.theme.colorScheme.primary;
    final itemsBgColor = Get.theme.colorScheme.primary.withValues(
      alpha: isDark ? 0.15 : 0.06,
    );

    // Currency representation
    final userController = Get.find<UserController>();
    final currency = userController.user.value?.baseCurrence ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => ScreenViewInventoryCount(model: model)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Label, Status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        model.label.isEmpty ? "Inventory Count" : model.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.color(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Iconify(
                            isPending ? Bx.timer : Bx.check_circle,
                            color: statusColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            model.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Details row: Created/Completed info & Type badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time information
                    Row(
                      children: [
                        Iconify(
                          Bx.time,
                          color: AppTheme.color(context).withOpacity(0.4),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isPending
                              ? "Created at ${model.createdAt != null ? MistDateUtils.formatTime(model.createdAt!) : ''}"
                              : "Completed at ${model.updatedAt != null ? MistDateUtils.formatTime(model.updatedAt!) : ''}",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.color(context).withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Scope badge (All Items vs Selected Items)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: itemsBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        model.countBasedOn == '*'
                            ? "All Items"
                            : "Selected Items",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: itemsColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: AppTheme.color(context).withOpacity(0.08),
                ),
                const SizedBox(height: 12),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stat 1: Total Items
                    _buildStatCol(
                      "Items",
                      "${model.inventoryItems.length}",
                      AppTheme.color(context).withOpacity(0.7),
                    ),

                    // Stat 2: Differences (if completed)
                    if (!isPending) ...[
                      _buildStatCol(
                        "Diff Qty",
                        "${model.totalDifference > 0 ? '+' : ''}${model.totalDifference.toInt()}",
                        model.totalDifference == 0
                            ? AppTheme.color(context).withOpacity(0.7)
                            : (model.totalDifference > 0
                                  ? Colors.green[700]!
                                  : Colors.red[700]!),
                      ),
                      _buildStatCol(
                        "Cost Diff",
                        CurrenceConverter.getCurrenceFloatInStrings(
                          model.totalCostDifference,
                          currency,
                        ),
                        model.totalCostDifference == 0
                            ? AppTheme.color(context).withOpacity(0.7)
                            : (model.totalCostDifference > 0
                                  ? Colors.green[700]!
                                  : Colors.red[700]!),
                      ),
                    ] else ...[
                      // If pending, just show filler details or notes indicator
                      Expanded(
                        child: Text(
                          model.notes.isEmpty ? "No notes added" : model.notes,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.color(context).withOpacity(0.4),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: AppTheme.color(context).withOpacity(0.4),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        loadInventoryCounts();
      }
    });
  }

  Future<void> loadInventoryCounts() async {
    await _iventoryController.loadInventoriesCounts(
      page: 1,
      search: _searchTerm,
      status: _statusFilter,
    );
    _refreshController.loadComplete();
  }
}
