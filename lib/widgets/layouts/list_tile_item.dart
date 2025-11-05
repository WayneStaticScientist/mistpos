import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
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
  @override
  Widget build(BuildContext context) {
    return [
          _getAvatar(),
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
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(20),
          ),
        )
        .padding(EdgeInsets.symmetric(vertical: 14));
  }

  Widget _getAvatar() {
    if (widget.item.shape == null || widget.item.shape!.isEmpty) {
      if (widget.item.avatar != null && widget.item.avatar!.isNotEmpty) {
        return _getImage();
      }
    }
    if (widget.item.shape != null && widget.item.shape!.isNotEmpty) {
      return Iconify(
        widget.item.shape!,
        size: 48,
        color: widget.item.color != null
            ? Color(int.parse('${widget.item.color!}'))
            : Get.theme.colorScheme.primary,
      );
    }
    return SizedBox();
  }

  _getImage() {
    return const SizedBox();
  }
}
