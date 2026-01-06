import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/inventory/screem_edit_supplier.dart';

class NavInventorySuppliersList extends StatefulWidget {
  const NavInventorySuppliersList({super.key});

  @override
  State<NavInventorySuppliersList> createState() =>
      _NavInventorySuppliersListState();
}

class _NavInventorySuppliersListState extends State<NavInventorySuppliersList> {
  final _refreshController = RefreshController();
  final _iventoryController = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounce;
  @override
  void initState() {
    if (_iventoryController.company.value != null &&
        MistDateUtils.getDaysDifference(
              _iventoryController.company.value!.subscriptionType.validUntil!,
            ) >=
            0 &&
        !(MistSubscriptionUtils.proList.contains(
          _iventoryController.company.value!.subscriptionType.type,
        ))) {
      _iventoryController.loadSuppliers();
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
        onLoading: () async {
          if (_iventoryController.supplierPage.value <
              _iventoryController.supplierTotalPages.value) {
            await _iventoryController.loadSuppliers(
              page: _iventoryController.supplierPage.value + 1,
              search: _searchTerm,
            );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        onRefresh: () async {
          _iventoryController.loadSuppliers(page: 1, search: _searchTerm);
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
        },
        child: ListView(
          children: [
            MistSearchField(
              label: "Search Suppliers",
              controller: _searchController,
            ),
            Obx(() {
              if (_iventoryController.suppliers.isEmpty &&
                  _iventoryController.suppliersLoading.value) {
                return MistLoader1().center();
              }
              if (_iventoryController.suppliers.isEmpty &&
                  !_iventoryController.suppliersLoading.value) {
                return "No Suppliers Found ".text().center();
              }
              return ListView.builder(
                shrinkWrap: true, // IMPORTANT
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildTile(_iventoryController.suppliers[index]);
                },
                itemCount: _iventoryController.suppliers.length,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTile(SupplierModel model) {
    return ListTile(
      onTap: () => Get.to(() => ScreenEditSupplier(supplierModel: model)),
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(child: Iconify(Bx.user, color: Colors.white)),
      title: model.name.text(),
      subtitle: model.email?.text(),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        _iventoryController.loadSuppliers(search: _searchTerm, page: 1);
        _refreshController.loadComplete();
      }
    });
  }
}
