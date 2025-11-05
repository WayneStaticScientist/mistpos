import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_add_item.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenSelectPurchaseOrderItems extends StatefulWidget {
  final bool? isCompositeItems;
  const ScreenSelectPurchaseOrderItems({super.key, this.isCompositeItems});

  @override
  State<ScreenSelectPurchaseOrderItems> createState() =>
      _ScreenSelectPurchaseOrderItemsState();
}

class _ScreenSelectPurchaseOrderItemsState
    extends State<ScreenSelectPurchaseOrderItems> {
  final _refreshController = RefreshController();
  final _inventory = Get.find<InventoryController>();
  final _itemController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _itemController.syncCartItemsOnBackground(
        isCompositeItems: widget.isCompositeItems ?? false,
      );
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
    return Scaffold(
      appBar: AppBar(
        title: "Select Items".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showSelectedItems,
            icon: Obx(
              () => Badge.count(
                count: _inventory.selectedInvItems.length,
                child: Iconify(Bx.cart, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          await _itemController.syncCartItemsOnBackground(
            page: 1,
            search: _searchTerm,
            isCompositeItems: widget.isCompositeItems ?? false,
          );
          _refreshController.refreshCompleted();
        },
        child: [
          MistSearchField(
            label: "Search Products",
            controller: _searchController,
          ),
          Expanded(
            child: Obx(
              () => _itemController.cartItems.isEmpty
                  ? "No items found . Click + to add new item".text()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        if (index < _itemController.cartItems.length) {
                          return _buildTile(_itemController.cartItems[index]);
                        }
                        return _buildLoader();
                      },
                      itemCount: _itemController.cartItems.length + 1,
                    ),
            ),
          ),
        ].column().padding(EdgeInsets.all(14)),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => Get.to(() => ScreenAddItem()),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTile(ItemModel model) {
    return Obx(() {
      final isSelected = _inventory.selectedInvItems.any(
        (e) => e.id == model.hexId,
      );
      return ListTile(
        selected: isSelected,
        onTap: () => _inventory.addInvModel(model),
        leading: CircleAvatar(
          child: Iconify(model.shape ?? Bx.cart, color: Colors.white),
        ),
        subtitle: CurrenceConverter.getCurrenceFloatInStrings(
          model.cost,
          _userController.user.value?.baseCurrence ?? '',
        ).text(),
        title: model.name.text(),
      );
    });
  }

  Widget _buildLoader() {
    if (_itemController.itemsPage >= _itemController.totalPages.value) {
      return ['No more Products'.text()]
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
        _itemController.syncCartItemsOnBackground(
          search: _searchTerm,
          page: 1,
          isCompositeItems: widget.isCompositeItems ?? false,
        );
      }
    });
  }

  void _showSelectedItems() {
    Get.bottomSheet(
      Obx(
        () => SingleChildScrollView(
          child: _inventory.selectedInvItems
              .map(
                (e) => ListTile(
                  leading: CircleAvatar(
                    child: Iconify(Bx.cart, color: Colors.white),
                  ),
                  subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                    e.cost,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                  title: e.name.text(),
                  trailing: IconButton(
                    onPressed: () => _inventory.removeodel(e),
                    icon: Icon(Icons.close),
                  ),
                ),
              )
              .toList()
              .column(),
        ),
      ),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }
}
