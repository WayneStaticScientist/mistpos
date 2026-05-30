import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/services/firebase/firebase_controller.dart';
import 'package:mistpos/features/settings/screens/screen_notifications.dart';
import 'package:mistpos/features/settings/screens/screens_select_customers.dart';
import 'package:mistpos/features/settings/screens/screen_view_selected_customer.dart';

class SalesAppBar extends StatefulWidget {
  const SalesAppBar({super.key});

  @override
  State<SalesAppBar> createState() => _SalesAppBarState();
}

class _SalesAppBarState extends State<SalesAppBar> {
  final _fireController = Get.find<FirebaseController>();
  final _itemsListController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      floating: true,
      centerTitle: false,
      title: Text("MistPos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1.2)),
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
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.withAlpha(30), shape: BoxShape.circle),
                    child: Iconify(Bx.error, color: Colors.red),
                  ),
                )
              : SizedBox.shrink(),
        ),
        Obx(() {
          bool selected = _itemsListController.selectedCustomer.value != null;
          return IconButton(
            onPressed: () => selected
                ? Get.to(() => ScreenViewSelectedCustomer())
                : Get.to(() => ScreensListCustomers()),
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected ? Colors.green.withAlpha(30) : AppTheme.surface(context),
                shape: BoxShape.circle,
              ),
              child: Iconify(
                selected ? Bx.user_check : Bx.user_plus,
                color: selected ? Colors.green : AppTheme.color(context),
              ),
            ),
          );
        }),
        Obx(
          () => IconButton(
            onPressed: () => Get.to(() => ScreenNotifications()),
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.surface(context), shape: BoxShape.circle),
              child: _fireController.notificationSize.value > 0
                  ? Badge.count(
                      count: _fireController.notificationSize.value,
                      child: Iconify(Bx.bell, color: AppTheme.color(context)),
                    )
                  : Iconify(Bx.bell, color: AppTheme.color(context)),
            ),
          ),
        ),
        12.gapWidth,
      ],
    );
  }

  void _displayError() {
    Toaster.showError(_itemsListController.syncingItemsFailed.value);
  }
}
