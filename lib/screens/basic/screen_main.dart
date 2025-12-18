import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/navs/nav_admin.dart';
import 'package:mistpos/navs/nav_items.dart';
import 'package:mistpos/navs/nav_sales.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/navs/nav_receits.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/screens/auth/screen_login.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_subscription.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
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
  final _invController = Get.find<InventoryController>();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final company = CompanyModel.fromStorage();
      if (company != null &&
          company.subscriptionType.type == 'free' &&
          company.subscriptionType.hasExhaustedCredits == false) {
        _showAlertDialog();
      }
      if (company != null &&
          company.subscriptionType.type != 'free' &&
          company.subscriptionType.validUntil != null) {
        _verifySubscriptionValidity(company);
      }
    });
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
      bottomSheet: Obx(() {
        final countedTaxes = _itemsController.salesTaxes
            .where((tax) => tax.activated)
            .toList();
        return [
              "${countedTaxes.length} Taxes affecting".text(
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ]
            .row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            )
            .padding(EdgeInsets.all(4))
            .decoratedBox(decoration: BoxDecoration(color: Colors.red))
            .visibleIf(countedTaxes.isNotEmpty && _currentNav == 'sales');
      }),
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

  void _showAlertDialog() {
    final settings = AppSettingsModel.fromStorage();
    if (settings.hasAlertedAboutFreeVersion) {
      return;
    }
    settings.hasAlertedAboutFreeVersion = true;
    settings.saveToStorage();
    Get.defaultDialog(
      title: "Get trial Version",
      middleText:
          "Get access to premium features by upgrading your plan. Enjoy a 14-day free trial of our Pro version with no commitments!",
      textConfirm: "Upgrade",
      textCancel: "Later",
      onConfirm: () {
        Get.to(() => ScreenSubscription());
      },
    );
  }

  void _verifySubscriptionValidity(CompanyModel company) {
    if (company.subscriptionType.offlineNotified) {
      return;
    }
    final validUntil = company.subscriptionType.validUntil!;
    final currentDate = DateTime.now();
    final difference = validUntil.difference(currentDate).inDays;
    if (difference <= 3 && difference >= 0) {
      Get.defaultDialog(
        title: "Subscription Expiry Notice",
        middleText:
            "Your subscription is set to expire in $difference days on ${MistDateUtils.getInformalShortDate(validUntil)}. "
            "Please consider renewing to continue enjoying uninterrupted access to all features.",
        textConfirm: "Renew Now",
        textCancel: "Later",
        onConfirm: () {
          Get.to(() => ScreenSubscription());
        },
        onCancel: () {
          _invController.closeLocalNotification();
        },
      );
      return;
    }
    if (difference < 0) {
      Get.defaultDialog(
        title: "Subscription Expired",
        middleText:
            "Your subscription expired on ${MistDateUtils.getInformalShortDate(validUntil)}. "
            "Please renew your subscription to regain access to all features.",
        textConfirm: "Renew Now",
        onConfirm: () {
          Get.to(() => ScreenSubscription());
        },
        onCancel: () {
          _invController.closeLocalNotification();
        },
        textCancel: "Later",
      );
    }
  }
}
