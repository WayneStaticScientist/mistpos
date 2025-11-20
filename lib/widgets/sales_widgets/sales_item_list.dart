import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/layouts/list_tile_item.dart';
import 'package:mistpos/screens/basic/screen_manual_cart.dart';

class SalesItemList extends StatefulWidget {
  final Function(TapUpDetails, ItemModel) onTap;
  const SalesItemList({super.key, required this.onTap});

  @override
  State<SalesItemList> createState() => _SalesItemListState();
}

class _SalesItemListState extends State<SalesItemList> {
  final _itemsListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsListController.cartItems.isNotEmpty
          ? SliverList.builder(
              itemBuilder: (context, index) =>
                  MistListTileItem(item: _itemsListController.cartItems[index])
                      .padding(EdgeInsets.symmetric(horizontal: 18))
                      .onTapUp(
                        (e) => widget.onTap(
                          e,
                          _itemsListController.cartItems[index],
                        ),
                      )
                      .paddingZero
                      .onLongPress(
                        () => Get.to(
                          () => ScreenManualCart(
                            item: _itemsListController.cartItems[index],
                          ),
                        ),
                      )
                      .padding(
                        EdgeInsets.only(
                          bottom:
                              index == _itemsListController.cartItems.length - 1
                              ? 100
                              : 0,
                        ),
                      ),
              itemCount: _itemsListController.cartItems.length,
            )
          : SliverFillRemaining(
              child:
                  [
                        Iconify(Bx.cart_alt, color: AppTheme.color(context)),
                        12.gapHeight,
                        "no items".text(),
                      ]
                      .column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                      .center(),
            ),
    );
  }
}
