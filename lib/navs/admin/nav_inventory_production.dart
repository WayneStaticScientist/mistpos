import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/models/production_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/screens/inventory/screen_view_productions.dart';

class NavInventoryProduction extends StatefulWidget {
  const NavInventoryProduction({super.key});

  @override
  State<NavInventoryProduction> createState() => _NavInventoryProductionState();
}

class _NavInventoryProductionState extends State<NavInventoryProduction> {
  final _refreshController = RefreshController();
  final _inventory = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inventory.company.value == null ||
          !(MistSubscriptionUtils.enterpriseList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _inventory.loadProductions(page: 1);
      _initializeTimer();
    });
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
      if (_inventory.company.value == null ||
          !(MistSubscriptionUtils.enterpriseList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          loadInventoryProductions();
          await Future.delayed(Duration(milliseconds: 800));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          if (_inventory.productionsPage.value <
              _inventory.productionsTotalPages.value) {
            await _inventory.loadProductions(
              page: _inventory.productionsPage.value + 1,
              search: _searchTerm,
            );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        child: ListView(
          children: [
            MistSearchField(label: "Search ", controller: _searchController),
            Obx(() {
              if (_inventory.productions.isEmpty &&
                  _inventory.productionsLoading.value) {
                return MistLoader1().center();
              }
              if (_inventory.productions.isEmpty &&
                  !_inventory.productionsLoading.value) {
                "No Productions click + to add new production".text().center();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildTile(_inventory.productions[index]);
                },
                itemCount: _inventory.productions.length,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTile(ProductionModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Get.to(() => ScreenViewProductions(model: model)),
      leading: Iconify(Bx.food_menu, color: AppTheme.color(context)),
      subtitle: MistDateUtils.getInformalDate(model.createdAt!).text(),
      title: (model.label).text(),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        _inventory.loadProductions(search: _searchTerm, page: 1);
      }
    });
  }

  void loadInventoryProductions() {
    _inventory.loadProductions(page: 1, search: _searchTerm);
    _refreshController.loadComplete();
  }
}
