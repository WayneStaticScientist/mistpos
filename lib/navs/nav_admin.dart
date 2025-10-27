import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';

class NavAdmin extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavAdmin({super.key, this.scaffoldKey});

  @override
  State<NavAdmin> createState() => _NavAdminState();
}

class _NavAdminState extends State<NavAdmin> {
  final _adminController = Get.find<AdminController>();
  @override
  void initState() {
    super.initState();
    _adminController.getAdminStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
        ),
        centerTitle: true,
      ),
    );
  }
}
