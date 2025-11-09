import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
    loadInventoryCounts();
    _initializeTimer();
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
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        loadInventoryCounts();
        await Future.delayed(Duration(milliseconds: 800));
        _refreshController.refreshCompleted();
      },
      child: [
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
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, index) {
                if (index < _iventoryController.inventoryCounts.length) {
                  return _buildTile(_iventoryController.inventoryCounts[index]);
                }
                return _buildLoader();
              },
              itemCount: _iventoryController.inventoryCounts.length + 1,
            ),
          ),
        ),
      ].column().padding(EdgeInsets.all(14)),
    );
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

  Widget _buildLoader() {
    if (_iventoryController.inventoryCountsPage >=
        _iventoryController.inventoryCountsPage.value) {
      return ['No more Inventory Counts'.text()]
          .row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .padding(EdgeInsets.all(14));
    }
    return [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 200,
          ),
        ]
        .row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .padding(EdgeInsets.all(14));
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

  void loadInventoryCounts() {
    _iventoryController.loadInventoriesCounts(
      page: 1,
      search: _searchTerm,
      status: _statusFilter,
    );
  }

  Widget _getTrailing(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.red);
    }
    return Iconify(Bx.check_circle, color: Colors.green);
  }
}
