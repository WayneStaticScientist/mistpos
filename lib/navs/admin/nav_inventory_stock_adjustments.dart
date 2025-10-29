import 'dart:async';

import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/screens/inventory/screen_view_stock_adjustment.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      _inventory.loadStockAdjustments(page: 1);
    });
    _initializeTimer();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      MistSearchField(label: "Search ", controller: _searchController),
      Wrap(
        alignment: WrapAlignment.start,
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
      ).sizedBox(width: double.infinity),
      Expanded(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          onRefresh: () async {
            loadInventoryStockerOrders();
            await Future.delayed(Duration(milliseconds: 800));
            _refreshController.refreshCompleted();
          },
          child: Obx(
            () =>
                _inventory.stockerOrders.isEmpty &&
                    !_inventory.stockAdjustOrdersLoading.value
                ? "No Purchase Orders found . Click + to add new purchaseOrder"
                      .text()
                      .center()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      if (index < _inventory.stockerOrders.length) {
                        return _buildTile(_inventory.stockerOrders[index]);
                      }
                      return _buildLoader();
                    },
                    itemCount: _inventory.stockerOrders.length + 1,
                  ),
          ),
        ),
      ),
    ].column().padding(EdgeInsets.all(14));
  }

  Widget _buildTile(StockAdjustmentModel model) {
    return ListTile(
      onTap: () => Get.to(() => ScreenViewStockAdjustment(model: model)),
      leading: CircleAvatar(child: Iconify(Bx.tag, color: Colors.white)),
      subtitle: Text(model.notes, maxLines: 1, overflow: TextOverflow.ellipsis),
      title: ("${model.inventoryItems.length} Items").text(),
    );
  }

  Widget _buildLoader() {
    if (_inventory.purchaseOrderPage.value >=
        _inventory.purchaseOrderTotalPages.value) {
      return ['No more Purchase Orders'.text()]
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
        _inventory.loadStockAdjustments(
          search: _searchTerm,
          page: 1,
          status: _statusFilter,
        );
      }
    });
  }

  void loadInventoryStockerOrders() {
    Future.microtask(() {
      _inventory.loadStockAdjustments(
        page: 1,
        search: _searchTerm,
        status: _statusFilter,
      );
    });
  }
}
