import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/screens/basic/screen_edit_modifier.dart';

class NavModifiersList extends StatefulWidget {
  const NavModifiersList({super.key});

  @override
  State<NavModifiersList> createState() => _NavModifiersListState();
}

class _NavModifiersListState extends State<NavModifiersList> {
  final _itemListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverList.builder(
        itemBuilder: (context, index) =>
            Card(
                  child: ListTile(
                    title: Text(_itemListController.modifiers[index].name),
                    trailing: Iconify(Bx.chevron_right),
                    subtitle: Text(
                      "${_itemListController.modifiers[index].list.length} options",
                    ),
                  ),
                )
                .onTap(
                  () => _editModifier(_itemListController.modifiers[index]),
                )
                .padding(EdgeInsets.all(10)),
        itemCount: _itemListController.modifiers.length,
      ),
    );
  }

  void _editModifier(ItemModifier modifier) {
    Get.to(() => ScreenEditModifier(modifier: modifier));
  }
}
