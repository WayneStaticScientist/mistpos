import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/admin/navs/nav_admin.dart';
import 'package:mistpos/features/inventory/navs/nav_items.dart';
import 'package:mistpos/features/sales/navs/nav_sales.dart';
import 'package:mistpos/features/inventory/navs/nav_expenses.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/features/sales/navs/nav_receits.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/auth/screens/screen_login.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens/screen_subscription.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_unsaved_controller.dart';
import 'package:mistpos/core/widgets/layouts/mist_navigation_drawer.dart';

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
  String _currentNav = 'sales';

  late final Map<String, Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = {
      'sales': NavSale(scaffoldKey: _scaffoldKey),
      'receipts': NavReceits(scaffoldKey: _scaffoldKey),
      'items': NavItems(scaffoldKey: _scaffoldKey),
      'Expenses': NavExpenses(scaffoldKey: _scaffoldKey),
      'admin': NavAdmin(scaffoldKey: _scaffoldKey),
    };
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
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _showNewFeaturesWalkthrough();
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Use IndexedStack so state is preserved when switching sections
      body: IndexedStack(
        index: _navIndex,
        children: _pages.values.toList(),
      ),
      drawer: Obx(
        () => MistMainNavigationView(
          scaffoldKey: _scaffoldKey,
          selectedNav: _currentNav,
          user: _userController.user.value,
          onTap: (value) {
            setState(() => _currentNav = value);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  int get _navIndex {
    final keys = _pages.keys.toList();
    final idx = keys.indexOf(_currentNav);
    return idx < 0 ? 0 : idx;
  }

  void _showAlertDialog() {
    final settings = AppSettingsModel.fromStorage();
    if (settings.hasAlertedAboutFreeVersion) return;
    settings.hasAlertedAboutFreeVersion = true;
    settings.saveToStorage();
    Get.defaultDialog(
      title: "Get trial Version",
      middleText:
          "Get access to premium features by upgrading your plan. Enjoy a 14-day free trial of our Pro version with no commitments!",
      textConfirm: "Upgrade",
      textCancel: "Later",
      onConfirm: () => Get.to(() => ScreenSubscription()),
    );
  }

  void _verifySubscriptionValidity(CompanyModel company) {
    final validUntil = company.subscriptionType.validUntil!;
    final storage = GetStorage();

    final storedExpiryStr = storage.read('last_processed_expiry');
    final currentExpiryStr = validUntil.toIso8601String();

    if (storedExpiryStr != currentExpiryStr) {
      storage.write('last_processed_expiry', currentExpiryStr);
      storage.write('notified_5_days', false);
      storage.write('notified_2_days', false);
      storage.write('notified_expired', false);
    }

    final isExpired = validUntil.isBefore(DateTime.now());
    final difference = validUntil.difference(DateTime.now()).inDays;

    if (isExpired) {
      final hasNotifiedExpired = storage.read('notified_expired') ?? false;
      if (!hasNotifiedExpired) {
        storage.write('notified_expired', true);
        Get.defaultDialog(
          title: "Subscription Expired",
          middleText:
              "Your subscription expired on ${MistDateUtils.getInformalShortDate(validUntil)}. "
              "Please renew to regain access to all features.",
          textConfirm: "Renew Now",
          onConfirm: () => Get.to(() => ScreenSubscription()),
          onCancel: () => _invController.closeLocalNotification(),
          textCancel: "Later",
        );
      }
    } else if (difference <= 2 && difference >= 0) {
      final hasNotified2Days = storage.read('notified_2_days') ?? false;
      if (!hasNotified2Days) {
        storage.write('notified_2_days', true);
        storage.write('notified_5_days', true); // Skip 5 days warning if already at 2 days
        Get.defaultDialog(
          title: "Subscription Expiry Notice",
          middleText:
              "Your subscription is set to expire in ${MistDateUtils.getDifferenxeInApproximate(validUntil)}. "
              "Please consider renewing to continue enjoying uninterrupted access.",
          textConfirm: "Renew Now",
          textCancel: "Later",
          onConfirm: () => Get.to(() => ScreenSubscription()),
          onCancel: () => _invController.closeLocalNotification(),
        );
      }
    } else if (difference <= 5 && difference > 2) {
      final hasNotified5Days = storage.read('notified_5_days') ?? false;
      if (!hasNotified5Days) {
        storage.write('notified_5_days', true);
        Get.defaultDialog(
          title: "Subscription Expiry Notice",
          middleText:
              "Your subscription is set to expire in $difference days on ${MistDateUtils.getInformalShortDate(validUntil)}. "
              "Please consider renewing to continue enjoying uninterrupted access.",
          textConfirm: "Renew Now",
          textCancel: "Later",
          onConfirm: () => Get.to(() => ScreenSubscription()),
          onCancel: () => _invController.closeLocalNotification(),
        );
      }
    }
  }

  void _showNewFeaturesWalkthrough() {
    final storage = GetStorage();
    if (storage.read('hasSeenNewFeaturesWalkthrough') == true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _NewFeaturesWalkthroughDialog(
          onDismiss: () {
            storage.write('hasSeenNewFeaturesWalkthrough', true);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _NewFeaturesWalkthroughDialog extends StatefulWidget {
  final VoidCallback onDismiss;
  const _NewFeaturesWalkthroughDialog({required this.onDismiss});

  @override
  State<_NewFeaturesWalkthroughDialog> createState() => _NewFeaturesWalkthroughDialogState();
}

class _NewFeaturesWalkthroughDialogState extends State<_NewFeaturesWalkthroughDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      const _WalkthroughPage(
        imagePath: 'assets/tutorials/ai.png',
        title: 'Meet MistPOS AI!',
        description: 'Your intelligent operational partner. Ask business questions, plot interactive sales graphs, bulk edit products, predict sales and revenue trends, and get personalized advice to grow your business.',
        color: Color(0xFF7C3AED),
      ),
      const _WalkthroughPage(
        imagePath: 'assets/tutorials/ticket.png',
        title: 'Support & Suggestions',
        description: 'Have an issue or want to request a feature? Submit a support ticket directly from the app. Our team will review and respond to you within 24 hours to help keep your operations smooth.',
        color: Color(0xFF2563EB),
      ),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, idx) => pages[idx],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? pages[_currentPage].color
                              : (isDark ? Colors.white24 : Colors.black12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        widget.onDismiss();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pages[_currentPage].color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: Text(
                      _currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalkthroughPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color color;

  const _WalkthroughPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, color: color, size: 48),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
