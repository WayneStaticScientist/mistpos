import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/item_unsaved_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/layouts/list_unsaved_model_avatar.dart';

class ListMistUnsavedListTile extends StatefulWidget {
  final ItemUnsavedModel item;
  const ListMistUnsavedListTile({super.key, required this.item});

  @override
  State<ListMistUnsavedListTile> createState() =>
      _ListMistUnsavedListTileState();
}

class _ListMistUnsavedListTileState extends State<ListMistUnsavedListTile> {
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return [
          MistAvatarUnsaved.getAvatar(widget.item),
          12.gapWidth,
          [
                widget.item.name.text(),
                if (widget.item.trackStock)
                  Text(
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
                  ),
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
            border: Border(
              top: BorderSide(color: Colors.grey.withAlpha(40), width: 1),
              bottom: BorderSide(color: Colors.grey.withAlpha(40), width: 1),
            ),
          ),
        )
        .padding(EdgeInsets.symmetric(vertical: 5));
  }
}
