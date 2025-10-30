import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/widgets/layouts/list_tile_item.dart';
import 'package:mistpos/screens/basic/screen_edit_item.dart';

class NavItemsList extends StatefulWidget {
  const NavItemsList({super.key});

  @override
  State<NavItemsList> createState() => _NavItemsListState();
}

class _NavItemsListState extends State<NavItemsList> {
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsController.cartItems.isEmpty
          ? _emptyWidget()
          : ListView.builder(
              itemBuilder: (context, index) => InkWell(
                onTap: () => _openEditor(_itemsController.cartItems[index]),
                onLongPress: () =>
                    _openDeleteDialog(_itemsController.cartItems[index]),
                child: MistListTileItem(
                  item: _itemsController.cartItems[index],
                ),
              ),
              itemCount: _itemsController.cartItems.length,
            ),
    );
  }

  _openEditor(ItemModel model) {
    Get.bottomSheet(
      [
        CardButtons(
          onTap: () => _openEditDialog(model),
          icon: Iconify(Bx.cart_add, color: AppTheme.color),
          label: "Add Stock",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          icon: Iconify(Bx.bxs_edit, color: AppTheme.color),
          label: "Edit Item",
          color: Get.theme.colorScheme.secondary.withAlpha(50),
          onTap: () {
            Get.back();
            Get.to(() => ScreenEditItem(model: model));
          },
        ).expanded1,
      ].row().padding(EdgeInsets.only(top: 18)).safeArea(),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  _openEditDialog(ItemModel model) {
    Get.back();
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("Add Stock Amount"),
        content: MistFormInput(
          label: "stock amount ",
          controller: textController,
          icon: Iconify(Bx.add_to_queue),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("close")),
          TextButton(
            onPressed: () async {
              if (textController.text.trim().isEmpty) {
                Toaster.showError("cant be empty");
                return;
              }
              int? amount = int.tryParse(textController.text);
              if (amount == null) {
                Toaster.showError("invalid number used");
                return;
              }
              model.stockQuantity = model.stockQuantity + amount;
              model.syncOnline = false;
              Get.back();
              await _itemsController.createItem(model);
              Toaster.showSuccess("stock updated");
            },
            child: Text("save"),
          ),
        ],
      ),
    );
  }

  void _openDeleteDialog(ItemModel cartItem) {
    Get.dialog(
      AlertDialog(
        title: "Delete ${cartItem.name}".text(),
        content: 'are you sure to delete an item'.text(),
        actions: [
          'close'.text().textButton(onPressed: () => Get.back()),
          'delete'.text().textButton(
            onPressed: () {
              Get.back();
              _itemsController.deleteItem(cartItem.hexId);
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyWidget() {
    return [
          Iconify(Bx.no_entry, size: 60, color: Get.theme.colorScheme.primary),
          18.gapHeight,
          "No Items click new to add one".text(),
        ]
        .column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .center();
  }
}
