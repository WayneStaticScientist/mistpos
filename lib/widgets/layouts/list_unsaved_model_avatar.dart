import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/item_unsaved_model.dart';

class MistAvatarUnsaved {
  static Widget getAvatar(ItemUnsavedModel item) {
    if (item.shape == null || item.shape!.isEmpty) {
      if (item.avatar != null && item.avatar!.isNotEmpty) {
        return _getImage();
      }
    }
    if (item.shape != null && item.shape!.isNotEmpty) {
      return Iconify(
        item.shape!,
        size: 48,
        color: item.color != null
            ? Color(int.parse('${item.color!}'))
            : Get.theme.colorScheme.primary,
      );
    }
    return SizedBox();
  }

  static Widget _getImage() {
    return const SizedBox();
  }
}
