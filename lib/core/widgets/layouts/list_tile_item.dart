import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/utils/avatars.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';

class MistListTileItem extends StatefulWidget {
  final ItemModel item;
  const MistListTileItem({super.key, required this.item});

  @override
  State<MistListTileItem> createState() => _MistListTileItemState();
}

class _MistListTileItemState extends State<MistListTileItem> {
  final _userController = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();
  @override
  Widget build(BuildContext context) {
    return [
          MistAvatar.getAvatar(widget.item),
          16.gapWidth,
          [
                widget.item.name.text(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                if (widget.item.trackStock)
                  Obx(() {
                    bool showCount =
                        _invController.company.value?.showSalesCount == true;
                    if (!showCount) return SizedBox();
                    return Text(
                      "${widget.item.stockQuantity} in stock",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            widget.item.stockQuantity <
                                widget.item.lowStockThreshold
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ).visibleIfNot(
                      widget.item.isCompositeItem && !widget.item.useProduction,
                    );
                  }),
              ]
              .column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
              )
              .expanded1,
          CurrenceConverter.getCurrenceFloatInStrings(
            widget.item.price,
            _userController.user.value?.baseCurrence ?? '',
          ).text(
            style: TextStyle(
              fontWeight: FontWeight.w800, 
              color: Get.theme.colorScheme.primary,
              fontSize: 16
            )
          ),
        ]
        .row()
        .padding(EdgeInsets.all(16))
        .sizedBox(height: 90)
        .decoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
        )
        .padding(EdgeInsets.symmetric(vertical: 8, horizontal: 4));
  }
}
