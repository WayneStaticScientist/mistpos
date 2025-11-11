import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mistpos/widgets/layouts/profile_tile.dart';
import 'package:mistpos/screens/basic/screen_dashboard.dart';
import 'package:mistpos/screens/currence/screen_currency.dart';
import 'package:mistpos/screens/gateways/payment_gateway.dart';
import 'package:mistpos/screens/basic/screen_settings_page.dart';
import 'package:mistpos/screens/basic/screen_devices_section.dart';

class MistMainNavigationView extends StatelessWidget {
  final Function(String value) onTap;
  final User? user;
  final String selectedNav;
  const MistMainNavigationView({
    super.key,
    required this.onTap,
    required this.selectedNav,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ProfileTile(),
            "Basic".text(style: TextStyle(fontSize: 12)).paddingLeft(12),
            ListTile(
              leading: Iconify(Bx.cart, color: AppTheme.color(context)),
              title: Text('Sales'),
              onTap: () => onTap('sales'),
              tileColor: selectedNav == 'sales'
                  ? Colors.grey.withAlpha(50)
                  : null,
            ),
            ListTile(
              leading: Iconify(Bx.receipt, color: AppTheme.color(context)),
              title: Text('Receipts'),
              tileColor: selectedNav == 'receipts'
                  ? Colors.grey.withAlpha(50)
                  : null,
              onTap: () => onTap('receipts'),
            ),
            ListTile(
              leading: Iconify(Bx.category, color: AppTheme.color(context)),
              title: Text('Items'),
              onTap: () => onTap('items'),
              tileColor: selectedNav == 'items'
                  ? Colors.grey.withAlpha(30)
                  : null,
            ),
            ListTile(
              leading: Iconify(Bx.devices, color: AppTheme.color(context)),
              title: Text('Devices'),
              onTap: () => Get.to(() => ScreenDevicesSection()),
            ),
            ListTile(
              leading: Iconify(Bx.cog, color: AppTheme.color(context)),
              title: Text('Settings'),
              onTap: () => Get.to(() => ScreenSettingsPage()),
            ),
            Divider(color: Colors.grey.withAlpha(50)),
            "Payment Methods"
                .text(style: TextStyle(fontSize: 12))
                .paddingLeft(12),
            ListTile(
              leading: Iconify(Bx.bxl_visa, color: AppTheme.color(context)),
              title: Text('Payment Getways'),
              onTap: () => Get.to(() => ScreenPaymentGetway()),
            ),
            Divider(color: Colors.grey.withAlpha(50)),
            "System".text(style: TextStyle(fontSize: 12)).paddingLeft(12),
            ListTile(
              leading: Iconify(Bx.money, color: AppTheme.color(context)),
              title: Text('Currencies'),
              onTap: () => Get.to(() => ScreenCurrency()),
            ),
            ListTile(
              leading: Iconify(Bx.bar_chart, color: AppTheme.color(context)),
              title: Text('Dashboard'),
              onTap: () {
                Get.back();
                Get.to(() => ScreenDashboard());
              },
            ),
            ListTile(
              leading: Iconify(Bx.help_circle, color: AppTheme.color(context)),
              title: Text('Help & Support'),
              onTap: () => onTap('help'),
            ),
          ],
        ),
      ),
    );
  }
}
