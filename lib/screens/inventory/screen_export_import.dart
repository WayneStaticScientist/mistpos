import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/avatars.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/inventory/screen_export_product_screen.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenExportImport extends StatefulWidget {
  const ScreenExportImport({super.key});

  @override
  State<ScreenExportImport> createState() => _ScreenExportImportState();
}

class _ScreenExportImportState extends State<ScreenExportImport> {
  final _invController = Get.find<InventoryController>();
  @override
  void dispose() {
    _invController.items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Export/Import Products".text(),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {},
              icon: MistLoader1(),
            ).visibleIf(_invController.uploadingItems.value),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:
            [
              MistFormButton(
                fillColor: Get.theme.colorScheme.primary,
                label: "Export Products",
                onTap: () => Get.to(() => ScreenExportProductScreen()),
                icon: Iconify(Bx.i_export, color: AppTheme.color(context)),
              ),
              18.gapHeight,
              Obx(
                () => MistFormButton(
                  label: "Import Products",
                  fillColor: Get.theme.colorScheme.primary,
                  onTap: _importItems,
                  isLoading:
                      _invController.importing.value ||
                      _invController.uploadingItems.value,
                  icon: Iconify(Bx.i_import, color: AppTheme.color(context)),
                ),
              ),
            ].column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
      ).center(),
    );
  }

  Future<void> _importItems() async {
    final value = await _invController.importItems();
    if (!value || !mounted) {
      return;
    }
    Get.defaultDialog(
      title: "Items",
      content: ListView.builder(
        itemBuilder: (context, index) =>
            _buildItem(_invController.items[index]),
        itemCount: _invController.items.length,
      ).sizedBox(height: MediaQuery.of(context).size.height * 0.5),
      textConfirm: "upload",
      textCancel: "close",
      onConfirm: () {
        Get.back();
        _invController.uploadItems();
      },
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
}
