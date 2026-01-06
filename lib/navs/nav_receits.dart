import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/layouts/receits_layout_view.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
        ),
        title: Text('Receipts'),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {},
              icon: CircularProgressIndicator(
                color: Colors.green,
                strokeWidth: 2,
              ).sizedBox(height: 20, width: 20),
            ).visibleIf(_receitsController.updatingUsyncedReceits.value),
          ),
          Obx(
            () => IconButton(
              onPressed: () {},
              icon: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ).sizedBox(height: 20, width: 20),
            ).visibleIf(_receitsController.receitsLoading.value),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
      ),
      body: ReceitsLayoutView(),
    );
  }
}
