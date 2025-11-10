import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_settings_page.dart';
import 'package:mistpos/screens/basic/screens_select_customers.dart';
import 'package:mistpos/screens/basic/screen_view_selected_customer.dart';

class SalesAppBar extends StatefulWidget {
  const SalesAppBar({super.key});

  @override
  State<SalesAppBar> createState() => _SalesAppBarState();
}

class _SalesAppBarState extends State<SalesAppBar> {
  final _itemsListController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      floating: true,
      title: "MistPos".text(),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      actions: [
        Obx(
          () => (_itemsListController.syncingItems.value)
              ? IconButton(
                  onPressed: () {},
                  icon: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ).sizedBox(height: 16, width: 16),
                )
              : SizedBox.shrink(),
        ),
        Obx(
          () => (_itemsListController.syncingItemsFailed.value.isNotEmpty)
              ? IconButton(
                  onPressed: _displayError,
                  icon: Iconify(Bx.error, color: Colors.red),
                )
              : SizedBox.shrink(),
        ),
        Obx(() {
          bool selected = _itemsListController.selectedCustomer.value != null;
          return IconButton(
            onPressed: () => selected
                ? Get.to(() => ScreenViewSelectedCustomer())
                : Get.to(() => ScreensListCustomers()),
            icon: Iconify(
              selected ? Bx.user_check : Bx.user_plus,
              color: selected ? Colors.green : AppTheme.color(context),
            ),
          );
        }),
        IconButton(
          onPressed: () => Get.to(() => ScreenSettingsPage()),
          icon: Iconify(Bx.cog, color: AppTheme.color(context)),
        ),
      ],
    );
  }

  void _displayError() {
    Toaster.showError(_itemsListController.syncingItemsFailed.value);
  }
}
