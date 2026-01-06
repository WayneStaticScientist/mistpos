import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/models/transfer_order_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/inventory/screen_view_transfer_order.dart';

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
              return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildTile(_iventoryController.transferOrders[index]);
                },
                itemCount: _iventoryController.transferOrders.length,
              );
            }),
          ],
        ),
      );
    });
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
