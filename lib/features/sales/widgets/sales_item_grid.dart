import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens/screen_manual_cart.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';

class SalesItemGrid extends StatefulWidget {
  final void Function(TapUpDetails, ItemModel) onTap;
  const SalesItemGrid({super.key, required this.onTap});

  @override
  State<SalesItemGrid> createState() => _SalesItemGridState();
}

class _SalesItemGridState extends State<SalesItemGrid> {
  final _itemsListController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsListController.cartItems.isNotEmpty
          ? SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180.0,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = _itemsListController.cartItems[index];
                  return InkWell(
                    child: _buildGridItem(context, item),
                    onTapUp: (e) => widget.onTap(e, item),
                    onLongPress: () =>
                        Get.to(() => ScreenManualCart(item: item)),
                  );
                }, childCount: _itemsListController.cartItems.length),
              ),
            )
          : SliverFillRemaining(
              child:
                  [
                        Iconify(
                          Bx.cart_alt,
                          color: AppTheme.color(context),
                          size: 48,
                        ),
                        16.gapHeight,
                        "no items".text(
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ]
                      .column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                      .center(),
            ),
    );
  }

  Widget _buildGridItem(BuildContext context, ItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  (item.avatar != null && item.avatar!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: item.avatar!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.withAlpha(50),
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.withAlpha(50),
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        )
                      : _fallbackIcon(item),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  4.gapHeight,
                  Text(
                    CurrenceConverter.getCurrenceFloatInStrings(
                      item.price,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                    style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(ItemModel item) {
    return Container(
      color: item.color != null
          ? Color(item.color!).withAlpha(50)
          : Colors.grey.withAlpha(20),
      child: Center(
        child: Iconify(
          item.shape ?? Bx.cube,
          size: 40,
          color: item.color != null ? Color(item.color!) : Colors.grey,
        ),
      ),
    );
  }
}
