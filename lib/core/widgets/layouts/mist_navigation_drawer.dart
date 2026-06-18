import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/auth/screens/screen_user_profile.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/settings/screens/screen_dashboard.dart';
import 'package:mistpos/features/settings/screens/screen_devices_section.dart';
import 'package:mistpos/features/settings/screens/screen_settings_page.dart';
import 'package:mistpos/features/settings/screens/screen_shifts_screen.dart';
import 'package:mistpos/features/settings/screens/screen_subscription.dart';
import 'package:mistpos/features/settings/screens/tax_list_screens.dart';
import 'package:mistpos/features/settings/screens_currency/screen_currency.dart';
import 'package:mistpos/features/settings/screens_gateways/automated_screen.dart';
import 'package:mistpos/features/settings/screens_gateways/payment_gateway.dart';
import 'package:mistpos/features/support/screens/sales_help.dart';
import 'package:mistpos/features/inventory/navs/nav_items.dart';
import 'package:mistpos/features/support/screens/screen_about.dart';

class MistMainNavigationView extends StatefulWidget {
  final Function(String value) onTap;
  final User? user;
  final String selectedNav;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const MistMainNavigationView({
    super.key,
    required this.onTap,
    required this.selectedNav,
    this.user,
    this.scaffoldKey,
  });

  @override
  State<MistMainNavigationView> createState() => _MistMainNavigationViewState();
}

class _MistMainNavigationViewState extends State<MistMainNavigationView> {
  final _userController = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1117) : Colors.white,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // ── Gradient Header ──
            _DrawerHeader(
              userController: _userController,
              invController: _invController,
            ),

            // ── Scrollable nav items ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 24, top: 8),
                children: [
                  _SectionLabel('Catalogue'),
                  Obx(() {
                    final isAdmin =
                        _userController.user.value?.role.toLowerCase() ==
                            'admin' ||
                        _userController.user.value?.role.toLowerCase() ==
                            'manager';
                    return ExpansionTile(
                      title: 'Catalogue'.text(
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Iconify(Carbon.shopping_catalog, color: primary),
                      shape:
                          const RoundedRectangleBorder(), // Remove borders when expanded
                      childrenPadding: const EdgeInsets.only(left: 16),
                      children: [
                        _DrawerItem(
                          icon: Bx.store_alt,
                          label: 'Point of Sale',
                          onTap: () {
                            widget.onTap('sales'); // Navigate back to sales
                          },
                        ),
                        _DrawerItem(
                          icon: Bx.receipt,
                          label: 'Receipts',
                          onTap: () {
                            widget.onTap(
                              'receipts',
                            ); // Using IndexedStack value
                          },
                        ),
                        _DrawerItem(
                          icon: Carbon.shopping_cart,
                          label: 'Items',
                          onTap: () {
                            widget.onTap('items'); // Using IndexedStack value
                          },
                        ).visibleIf(isAdmin),
                        _DrawerItem(
                          icon: Carbon.category,
                          label: 'Categories',
                          onTap: () {
                            Get.back();
                            Get.to(() => const NavItems(initialIndex: 1));
                          },
                        ).visibleIf(isAdmin),
                        _DrawerItem(
                          icon: Carbon.tag,
                          label: 'Discounts',
                          onTap: () {
                            Get.back();
                            Get.to(() => const NavItems(initialIndex: 3));
                          },
                        ).visibleIf(isAdmin),
                        _DrawerItem(
                          icon: Carbon.model_builder,
                          label: 'Add-ons',
                          onTap: () {
                            Get.back();
                            Get.to(() => const NavItems(initialIndex: 2));
                          },
                        ).visibleIf(isAdmin),
                      ],
                    );
                  }),
                  _SectionDivider(),
                  _SectionLabel('Quick Access'),
                  _DrawerItem(
                    icon: Bx.time,
                    label: 'Shift',
                    onTap: () {
                      Get.back();
                      Get.to(() => ScreenShiftsScreen());
                    },
                  ),
                  _DrawerItem(
                    icon: Bx.wallet,
                    label: 'Expenses',
                    onTap: () {
                      widget.onTap('Expenses');
                    },
                  ),
                  _DrawerItem(
                    icon: Bx.devices,
                    label: 'Devices',
                    onTap: () {
                      Get.back();
                      Get.to(() => ScreenDevicesSection());
                    },
                  ),
                  _DrawerItem(
                    icon: Bx.bxl_whatsapp,
                    label: 'WhatsApp Integration',
                    onTap: () {
                      if (_invController.company.value == null) return;
                      Get.back();
                      Get.to(
                        () => AutomatedSyncScreen(
                          company: _invController.company.value!,
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Bx.cog,
                    label: 'Settings',
                    onTap: () {
                      Get.back();
                      Get.to(() => ScreenSettingsPage());
                    },
                  ),

                  Obx(() {
                    final isAdmin =
                        _userController.user.value?.role.toLowerCase() ==
                            'admin' ||
                        _userController.user.value?.role.toLowerCase() ==
                            'manager';
                    if (!isAdmin) return SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionDivider(),
                        _SectionLabel('Finance & Reports'),
                        _DrawerItem(
                          icon: Bx.calculator,
                          label: 'Tax',
                          onTap: () {
                            Get.back();
                            Get.to(() => TaxListScreens());
                          },
                        ),
                        _DrawerItem(
                          icon: Bx.bar_chart,
                          label: 'Dashboard',
                          onTap: () {
                            Get.back();
                            Get.to(() => ScreenDashboard());
                          },
                        ),
                        _DrawerItem(
                          icon: Bx.network_chart,
                          label: 'Online Dashboard',
                          onTap: () {
                            Get.back();
                            Net.lauchDashboardUrl();
                          },
                        ),
                        _SectionDivider(),
                        _SectionLabel('Billing'),
                        _DrawerItem(
                          icon: Bx.analyse,
                          label: 'Subscriptions',
                          onTap: () {
                            Get.back();
                            Get.to(() => ScreenSubscription());
                          },
                        ),
                        _DrawerItem(
                          icon: Bx.bxl_visa,
                          label: 'Payment Gateways',
                          onTap: () {
                            Get.back();
                            Get.to(() => ScreenPaymentGetway());
                          },
                        ),
                        _DrawerItem(
                          icon: Bx.money,
                          label: 'Currencies',
                          onTap: () {
                            Get.back();
                            Get.to(() => ScreenCurrency());
                          },
                        ),
                      ],
                    );
                  }),

                  _SectionDivider(),
                  _SectionLabel('Help'),
                  _DrawerItem(
                    icon: Carbon.information,
                    label: 'Sales Help',
                    onTap: () {
                      Get.back();
                      Get.to(() => SalesHelp());
                    },
                  ),
                  _DrawerItem(
                    icon: Bx.help_circle,
                    label: 'Help & Support',
                    onTap: () {
                      Get.back();
                      Net.launchSupport();
                    },
                  ),
                  _DrawerItem(
                    icon: Bx.info_circle,
                    label: 'About MistPOS',
                    onTap: () {
                      Get.back();
                      Get.to(() => const ScreenAbout());
                    },
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

// ─────────────────────────────────────────────
// DRAWER GRADIENT HEADER
// ─────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  final UserController userController;
  final InventoryController invController;

  const _DrawerHeader({
    required this.userController,
    required this.invController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = userController.user.value;
      final company = invController.company.value;
      final primary = Theme.of(context).colorScheme.primary;
      if (user == null) return SizedBox(height: 100);

      final daysLeft = company?.subscriptionType.validUntil != null
          ? MistDateUtils.getDaysDifference(
              company!.subscriptionType.validUntil!,
            )
          : null;
      final subType = company?.subscriptionType.type ?? 'free';
      final isFree = subType == 'free';

      return GestureDetector(
        onTap: () {
          Get.back();
          Get.to(() => ScreenUserProfile());
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withAlpha(180), Color(0xFF0A2463)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 24,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar circle
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(40),
                      border: Border.all(
                        color: Colors.white.withAlpha(100),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withAlpha(150),
                    size: 14,
                  ),
                ],
              ),
              SizedBox(height: 18),
              // Company + subscription row
              Row(
                children: [
                  Iconify(
                    Bx.buildings,
                    color: Colors.white.withAlpha(180),
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      user.companyName,
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isFree
                          ? Colors.orange.withAlpha(200)
                          : Colors.green.withAlpha(200),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subType.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
              if (company?.subscriptionType.validUntil != null) ...[
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Iconify(
                        Bx.time,
                        color: Colors.white.withAlpha(180),
                        size: 14,
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        company!.subscriptionType.validUntil!.isAfter(DateTime.now())
                            ? 'Expires: ${DateFormat('yyyy-MM-dd HH:mm').format(company.subscriptionType.validUntil!.toLocal())}\n(${MistDateUtils.getDifferenxeInApproximate(company.subscriptionType.validUntil!)})'
                            : 'Expired: ${DateFormat('yyyy-MM-dd HH:mm').format(company.subscriptionType.validUntil!.toLocal())}',
                        style: TextStyle(
                          color: daysLeft != null && daysLeft <= 7
                              ? Colors.orange.shade200
                              : Colors.white.withAlpha(200),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 16, bottom: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION DIVIDER
// ─────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.withAlpha(40),
      indent: 20,
      endIndent: 20,
      height: 24,
    );
  }
}

// ─────────────────────────────────────────────
// DRAWER ITEM
// ─────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final Widget? trailing;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primary.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Iconify(
              icon,
              size: 22,
              color: isSelected ? primary : AppTheme.color(context),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primary : AppTheme.color(context),
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
