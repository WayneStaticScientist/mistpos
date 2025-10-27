import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/navs/nav_admin.dart';
import 'package:mistpos/navs/nav_items.dart';
import 'package:mistpos/navs/nav_receits.dart';
import 'package:mistpos/navs/nav_sales.dart';
import 'package:mistpos/screens/auth/screen_login.dart';
import 'package:mistpos/widgets/layouts/mist_navigation_drawer.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  Timer? _validationTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _userController = Get.find<UserController>();
  late final _listNavs = {
    'sales': NavSale(),
    "receipts": NavReceits(),
    "admin": NavAdmin(scaffoldKey: _scaffoldKey),
    "items": NavItems(scaffoldKey: _scaffoldKey),
  };
  @override
  void initState() {
    super.initState();
    _startValidationTimer();
  }

  void _startValidationTimer() {
    _validationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      final user = User.fromStorage();
      if (user == null) {
        Get.offAll(() => ScreenLogin());
      }
    });
  }

  @override
  void dispose() {
    _validationTimer?.cancel();
    super.dispose();
  }

  String _currentNav = 'sales';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _listNavs[_currentNav] ?? SizedBox.shrink(),
      drawer: Obx(
        () => MistMainNavigationView(
          selectedNav: _currentNav,
          user: _userController.user.value,
          onTap: (value) {
            setState(() {
              _currentNav = value;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
