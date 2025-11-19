import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/navs/nav_admin.dart';
import 'package:mistpos/navs/nav_items.dart';
import 'package:mistpos/navs/nav_sales.dart';
import 'package:mistpos/navs/nav_receits.dart';
import 'package:mistpos/screens/auth/screen_login.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/items_unsaved_controller.dart';
import 'package:mistpos/widgets/layouts/mist_navigation_drawer.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  Timer? _validationTimer;
  final _userController = Get.find<UserController>();
  final _itemsController = Get.find<ItemsController>();
  final _itemsSavedController = Get.find<ItemsUnsavedController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _itemsInialized = false;
  late final _listNavs = {
    'sales': NavSale(),
    "receipts": NavReceits(scaffoldKey: _scaffoldKey),
    "admin": NavAdmin(scaffoldKey: _scaffoldKey),
    "items": NavItems(scaffoldKey: _scaffoldKey),
  };
  @override
  void initState() {
    super.initState();
    _startValidationTimer();
  }

  void _startValidationTimer() {
    _validationTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_userController.user.value == null &&
          _userController.loading.value == false) {
        Get.offAll(() => ScreenLogin());
        return;
      }
      if (_userController.user.value != null &&
          _userController.loading.value == false &&
          !_itemsInialized) {
        _itemsController.loadTaxes();
        _itemsController.loadMofiers();
        _itemsController.loadReceits();
        _itemsController.loadDiscounts();
        _itemsController.syncAllShifts();
        _itemsController.loadSavedItems();
        _itemsController.syncCartItemsOnBackground();
        _itemsSavedController.syncCartItemsOnBackground();
        _itemsInialized = true;
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
      bottomNavigationBar: Obx(
        () => _itemsController.salesTaxes.isNotEmpty && _currentNav == 'sales'
            ? [
                    "${_itemsController.salesTaxes.length} Taxes affecting"
                        .text(
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                  ]
                  .row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )
                  .padding(EdgeInsets.all(12))
                  .decoratedBox(decoration: BoxDecoration(color: Colors.red))
            : SizedBox(),
      ),
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
