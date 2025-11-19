import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/widgets/layouts/receits_layout_view.dart';

class NavReceits extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const NavReceits({super.key, this.scaffoldKey});

  @override
  State<NavReceits> createState() => _NavReceitsState();
}

class _NavReceitsState extends State<NavReceits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
        ),
        title: Text('Receipts'),
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
      ),
      body: ReceitsLayoutView(),
    );
  }
}
