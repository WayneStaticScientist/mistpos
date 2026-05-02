import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/utils/avatars.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';

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
          12.gapWidth,
          [
                widget.item.name.text(),
                if (widget.item.trackStock)
                  Obx(() {
                    bool showCount =
                        _invController.company.value?.showSalesCount == true;
                    if (!showCount) return SizedBox();
                    return Text(
                      "${widget.item.stockQuantity} in stock",
                      style: TextStyle(
                        color:
                            widget.item.stockQuantity <
                                widget.item.lowStockThreshold
                            ? Colors.red
                            : null,
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
          ).text(style: TextStyle(fontWeight: FontWeight.bold)),
        ]
        .row()
        .padding(EdgeInsets.all(12))
        .sizedBox(height: 80)
        .decoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        )
        .padding(EdgeInsets.symmetric(vertical: 6, horizontal: 4));
  }
}
