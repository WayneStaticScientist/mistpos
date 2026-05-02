import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/item_unsaved_model.dart';

import 'package:iconify_flutter/icons/bx.dart';

class MistAvatarUnsaved {
  static Widget getAvatar(ItemUnsavedModel item) {
    if (item.avatar != null && item.avatar!.isNotEmpty) {
      return _getImage(item.avatar!);
    }
    
    // Fallback to shape or default cube icon
    String shapeToUse = (item.shape != null && item.shape!.isNotEmpty) ? item.shape! : Bx.cube;
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: item.color != null ? Color(int.parse('${item.color!}')).withAlpha(50) : Get.theme.colorScheme.primary.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Iconify(
          shapeToUse,
          size: 32,
          color: item.color != null
              ? Color(int.parse('${item.color!}'))
              : Get.theme.colorScheme.primary,
        ),
      ),
    );
  }

  static Widget _getImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 48,
          height: 48,
          color: Colors.grey.withAlpha(50),
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}
