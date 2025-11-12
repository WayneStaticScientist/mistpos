import 'dart:async';

import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/models/transfer_order_model.dart';
import 'package:mistpos/screens/inventory/screen_view_transfer_order.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    _initializeTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        _iventoryController.loadTransferOrders(page: 1, search: _searchTerm);
        _refreshController.refreshCompleted();
      },
      child: [
        MistSearchField(
          label: "Search Transfer Orders",
          controller: _searchController,
        ),
        10.gapHeight,
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, index) {
                if (index < _iventoryController.transferOrders.length) {
                  return _buildTile(_iventoryController.transferOrders[index]);
                }
                return _buildLoader();
              },
              itemCount: _iventoryController.transferOrders.length + 1,
            ),
          ),
        ),
      ].column().padding(EdgeInsets.all(14)),
    );
  }

  Widget _buildTile(TransferOrderModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Get.to(() => ScreenViewTransferOrder(model: model)),
      leading: CircleAvatar(child: Iconify(Bx.transfer, color: Colors.white)),
      subtitle: model.createdAt != null
          ? MistDateUtils.getInformalDate(model.createdAt!).text()
          : null,
      title: model.label.text(),
    );
  }

  Widget _buildLoader() {
    if (_iventoryController.transferOrderPage >=
        _iventoryController.transferOrderTotalPages.value) {
      return ['No more Transfer Orders'.text()]
          .row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .padding(EdgeInsets.all(14));
    }
    return [MistLoader1()]
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
        _iventoryController.loadTransferOrders(page: 1, search: _searchTerm);
      }
    });
  }
}
