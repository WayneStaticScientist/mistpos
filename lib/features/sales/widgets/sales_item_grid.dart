import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
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
  final _invController = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsListController.cartItems.isNotEmpty
          ? SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 185.0,
                  mainAxisSpacing: 14.0,
                  crossAxisSpacing: 14.0,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _itemsListController.cartItems[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTapUp: (e) => widget.onTap(e, item),
                      onLongPress: () =>
                          Get.to(() => ScreenManualCart(item: item)),
                      child: _buildGridItem(context, item),
                    );
                  },
                  childCount: _itemsListController.cartItems.length,
                ),
              ),
            )
          : SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildGridItem(BuildContext context, ItemModel item) {
    final primary = Get.theme.colorScheme.primary;
    final bool hasLowStock =
        item.trackStock && item.stockQuantity < item.lowStockThreshold;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image / icon area
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  (item.avatar != null && item.avatar!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: item.avatar!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _fallbackIcon(item),
                          errorWidget: (context, url, error) =>
                              _fallbackIcon(item),
                        )
                      : _fallbackIcon(item),
                  // Subtle bottom fade
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Stock badge (top-right corner)
                  if (item.trackStock)
                    Obx(() {
                      final showCount =
                          _invController.company.value?.showSalesCount == true;
                      if (!showCount) return const SizedBox.shrink();
                      if (item.isCompositeItem && !item.useProduction) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: hasLowStock
                                ? Colors.redAccent
                                : Colors.black.withAlpha(130),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${item.stockQuantity}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          // Name + price
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        CurrenceConverter.getCurrenceFloatInStrings(
                          item.price,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      if (item.trackStock)
                        Obx(() {
                          final showCount =
                              _invController.company.value?.showSalesCount ==
                              true;
                          if (!showCount) return const SizedBox.shrink();
                          if (item.isCompositeItem && !item.useProduction) {
                            return const SizedBox.shrink();
                          }
                          return Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hasLowStock
                                      ? Colors.redAccent
                                      : Colors.green,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "stk",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          );
                        }),
                    ],
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
          ? Color(item.color!).withAlpha(40)
          : Colors.grey.withAlpha(18),
      child: Center(
        child: Iconify(
          item.shape ?? Bx.cube,
          size: 44,
          color: item.color != null
              ? Color(item.color!).withAlpha(200)
              : Colors.grey.withAlpha(120),
        ),
      ),
    );
  }
}
