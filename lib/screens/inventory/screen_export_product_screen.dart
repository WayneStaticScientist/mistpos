import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/avatars.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';

class ScreenExportProductScreen extends StatefulWidget {
  const ScreenExportProductScreen({super.key});

  @override
  State<ScreenExportProductScreen> createState() =>
      _ScreenExportProductScreenState();
}

class _ScreenExportProductScreenState extends State<ScreenExportProductScreen> {
  final _invController = Get.find<InventoryController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invController.loadItems();
    });
  }

  @override
  void dispose() {
    _invController.items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Export Products".text(),
        actions: [
          Obx(
            () => IconButton(
              onPressed: _initiateExport,
              icon: _invController.exporting.value
                  ? MistLoader1()
                  : Iconify(Bx.i_export, color: AppTheme.color(context)),
            ).visibleIfNot(_invController.loadingItems.value),
          ),
        ],
      ),
      body: Obx(() {
        if (_invController.loadingItems.value) {
          return MistLoader1().center();
        }
        if (_invController.itemsError.value.isNotEmpty) {
          return _invController.itemsError.value.text().center();
        }
        return ListView.builder(
          itemBuilder: (context, index) =>
              _buildItem(_invController.items[index]),
          itemCount: _invController.items.length,
        );
      }),
    );
  }

  Widget _buildItem(ItemModel item) {
    return ListTile(
      title: item.name.text(),
      trailing: IconButton(
        onPressed: () => _invController.items.remove(item),
        icon: Icon(Icons.close),
      ),
      subtitle: CurrenceConverter.selectedCurrencyInString(
        item.price,
      ).text(style: TextStyle(color: Colors.grey)),
      leading: MistAvatar.getAvatar(item),
    );
  }

  void _initiateExport() {
    _invController.exportItems();
  }
}
