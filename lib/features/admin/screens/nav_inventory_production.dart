import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/data/models/production_model.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/features/inventory/screens/screen_view_productions.dart';

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
          MistDateUtils.getDaysDifference(
                _inventory.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
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

  Map<String, List<ProductionModel>> _groupProductionsByDate(List<ProductionModel> list) {
    final Map<String, List<ProductionModel>> groups = {};
    for (var prod in list) {
      if (prod.createdAt == null) continue;
      final header = MistDateUtils.formatDayHeader(prod.createdAt!);
      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(prod);
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

  Widget _buildModernCard(ProductionModel model) {
    final themeColor = AppTheme.color(context);
    final surfaceColor = AppTheme.surface(context);

    final totalItems = model.items.length;
    final totalQty = model.items.fold(0.0, (val, el) => val + el.quantity);
    final totalProcessed = model.items.where((e) => e.updated).length;

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
          onTap: () => Get.to(() => ScreenViewProductions(model: model)),
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
                          child: Icon(Icons.precision_manufacturing_outlined, color: themeColor.withAlpha(200), size: 20),
                        ),
                        12.gapWidth,
                        Text(
                          model.label.isEmpty ? "Production Run" : model.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: themeColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    if (model.createdAt != null)
                      Text(
                        MistDateUtils.formatTime(model.createdAt!),
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
                        color: Colors.teal.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.layers_outlined, size: 12, color: Colors.teal.shade700),
                          4.gapWidth,
                          Text(
                            "Composite Production",
                            style: TextStyle(
                              color: Colors.teal.shade700,
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

                Divider(height: 24, color: themeColor.withAlpha(15)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatColumn(
                      "Ingredients",
                      "$totalItems",
                      themeColor,
                    ),
                    _buildStatColumn(
                      "Total Quantity",
                      "${totalQty.toInt()}",
                      themeColor,
                    ),
                    _buildStatColumn(
                      "Processing",
                      "$totalProcessed / $totalItems Processed",
                      totalProcessed == totalItems ? Colors.green.shade700 : Colors.orange.shade700,
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
                return "No Productions click + to add new production".text().center();
              }
              
              final groupedProductions = _groupProductionsByDate(_inventory.productions);
              final dateKeys = groupedProductions.keys.toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dateKeys.length,
                itemBuilder: (context, dateIndex) {
                  final dateHeader = dateKeys[dateIndex];
                  final prods = groupedProductions[dateHeader]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateHeader(dateHeader, prods.length),
                      ...prods.map((prod) => _buildModernCard(prod)),
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
        _inventory.loadProductions(search: _searchTerm, page: 1);
      }
    });
  }

  void loadInventoryProductions() {
    _inventory.loadProductions(page: 1, search: _searchTerm);
    _refreshController.loadComplete();
  }
}
