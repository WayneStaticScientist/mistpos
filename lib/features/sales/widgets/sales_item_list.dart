import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/widgets/layouts/list_tile_item.dart';
import 'package:mistpos/features/settings/screens/screen_manual_cart.dart';

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
              itemBuilder: (context, index) {
                final item = _itemsListController.cartItems[index];
                final isLast = index == _itemsListController.cartItems.length - 1;
                return GestureDetector(
                  onTapUp: (e) => widget.onTap(e, item),
                  onLongPress: () => Get.to(() => ScreenManualCart(item: item)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 110 : 0),
                    child: MistListTileItem(item: item),
                  ),
                );
              },
              itemCount: _itemsListController.cartItems.length,
            )
          : SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Iconify(
                    Bx.cart_alt,
                    color: AppTheme.color(context).withAlpha(80),
                    size: 52,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "No items found",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
