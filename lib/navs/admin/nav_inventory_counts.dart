import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/screens/inventory/screen_view_inventory_count.dart';

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
          await Future.delayed(Duration(milliseconds: 800));
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
          children: [
            MistSearchField(
              label: "Search Inventory Counts",
              controller: _searchController,
            ),
            Wrap(
              alignment: WrapAlignment.start,
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
            ).sizedBox(width: double.infinity),
            Obx(() {
              if (_iventoryController.inventoryCounts.isEmpty &&
                  _iventoryController.inventoryCountsLoading.value) {
                return MistLoader1().center();
              }
              if (_iventoryController.inventoryCounts.isEmpty &&
                  !_iventoryController.inventoryCountsLoading.value) {
                return "No Inventory Counts found".text().center();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildTile(_iventoryController.inventoryCounts[index]);
                },
                itemCount: _iventoryController.inventoryCounts.length,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTile(InventoryCountModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Get.to(() => ScreenViewInventoryCount(model: model)),
      title:
          [
            model.label.text(),
            "Created At ${MistDateUtils.getInformalDate(model.createdAt!)}"
                .text(style: TextStyle(fontSize: 12)),
            "Completed At ${MistDateUtils.getInformalDate(model.updatedAt!)}"
                .text(style: TextStyle(fontSize: 12, color: Colors.green))
                .visibleIfNot(model.status == "pending"),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),

      leading: CircleAvatar(child: Iconify(Bx.cart, color: Colors.white)),
      trailing: _getTrailing(model.status),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        _iventoryController.loadSuppliers(search: _searchTerm, page: 1);
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

  Widget _getTrailing(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.red);
    }
    return Iconify(Bx.check_circle, color: Colors.green);
  }
}
