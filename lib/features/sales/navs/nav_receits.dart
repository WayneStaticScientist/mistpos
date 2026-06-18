import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/widgets/layouts/receits_layout_view.dart';

class NavReceits extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavReceits({super.key, this.scaffoldKey});

  @override
  State<NavReceits> createState() => _NavReceitsState();
}

class _NavReceitsState extends State<NavReceits> {
  final _receitsController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu_rounded, size: 20, color: AppTheme.color(context)),
          ),
        ),
        title: Text(
          'Receipts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          Obx(
            () => _receitsController.updatingUsyncedReceits.value
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(color: primary, strokeWidth: 2.5),
                      ),
                      SizedBox(width: 6),
                      Text('Syncing', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(width: 12),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Obx(
            () => _receitsController.receitsLoading.value
                ? Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(color: primary, strokeWidth: 2),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      // ReceitsLayoutView is its own full-screen scrollable (SmartRefresher → CustomScrollView)
      // so it must sit directly in the body, NOT inside another scrollable widget.
      body: ReceitsLayoutView(),
    );
  }
}
