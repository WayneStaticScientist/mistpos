import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/data/models/item_unsaved_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/layouts/list_unsaved_model_avatar.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLowStock = widget.item.trackStock && widget.item.stockQuantity < widget.item.lowStockThreshold;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar / Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 48,
                height: 48,
                child: MistAvatarUnsaved.getAvatar(widget.item),
              ),
            ),
            const SizedBox(width: 14),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.item.trackStock && !(widget.item.isCompositeItem && !widget.item.useProduction))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isLowStock 
                            ? Colors.red.withAlpha(30) 
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${widget.item.stockQuantity} in stock",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLowStock ? Colors.red.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Price Details
            Text(
              CurrenceConverter.getCurrenceFloatInStrings(
                widget.item.price,
                _userController.user.value?.baseCurrence ?? '',
              ),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
