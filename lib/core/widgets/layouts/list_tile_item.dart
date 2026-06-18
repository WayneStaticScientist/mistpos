import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/utils/avatars.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';

class MistListTileItem extends StatelessWidget {
  final ItemModel item;
  const MistListTileItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final invController = Get.find<InventoryController>();
    final primary = Get.theme.colorScheme.primary;
    final bool hasLowStock =
        item.trackStock && item.stockQuantity < item.lowStockThreshold;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar with subtle shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: MistAvatar.getAvatar(item),
              ),
              const SizedBox(width: 14),
              // Name + stock
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (item.trackStock)
                      Obx(() {
                        final showCount =
                            invController.company.value?.showSalesCount == true;
                        if (!showCount) return const SizedBox.shrink();
                        if (item.isCompositeItem && !item.useProduction) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(
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
                              const SizedBox(width: 5),
                              Text(
                                "${item.stockQuantity} in stock",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: hasLowStock
                                      ? Colors.redAccent
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Price chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    item.price,
                    userController.user.value?.baseCurrence ?? '',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
