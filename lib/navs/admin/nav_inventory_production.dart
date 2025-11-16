import 'dart:async';

import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/production_model.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      _inventory.loadProductions(page: 1);
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
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        loadInventoryProductions();
        await Future.delayed(Duration(milliseconds: 800));
        _refreshController.refreshCompleted();
      },
      child: [
        MistSearchField(label: "Search ", controller: _searchController),
        Expanded(
          child: Obx(
            () =>
                _inventory.productions.isEmpty &&
                    !_inventory.productionsLoading.value
                ? "No Productions click + to add new production".text().center()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      if (index < _inventory.productions.length) {
                        return _buildTile(_inventory.productions[index]);
                      }
                      return _buildLoader();
                    },
                    itemCount: _inventory.productions.length + 1,
                  ),
          ),
        ),
      ].column().padding(EdgeInsets.all(14)),
    );
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

  Widget _buildLoader() {
    if (_inventory.productionsPage.value >=
        _inventory.productionsTotalPages.value) {
      return ['No more  Productions'.text()]
          .row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .padding(EdgeInsets.all(14));
    }
    return [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 20,
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
        _inventory.loadProductions(search: _searchTerm, page: 1);
      }
    });
  }

  void loadInventoryProductions() {
    Future.microtask(() {
      _inventory.loadProductions(page: 1, search: _searchTerm);
    });
  }
}
