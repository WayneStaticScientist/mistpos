import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/screens/basic/screen_dashboard.dart';
import 'package:mistpos/screens/basic/screen_devices_section.dart';
import 'package:mistpos/screens/basic/screen_settings_page.dart';
import 'package:mistpos/themes/app_theme.dart';

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
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(border: Border.all(width: 0)),
            child: ListTile(
              title: ((user != null) ? user!.fullName.split(" ").first : "User")
                  .text(style: TextStyle(color: Colors.white)),
              subtitle: (user != null ? user!.company : "Company").text(
                style: TextStyle(fontSize: 9, color: Colors.white),
              ),
              trailing: "Till ${user?.till ?? 1}".text(
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              leading: CircleAvatar(
                child: Iconify(Bx.user, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: Iconify(Bx.cart, color: AppTheme.color),
            title: Text('Sales'),
            onTap: () => onTap('sales'),
            tileColor: selectedNav == 'sales'
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ListTile(
            leading: Iconify(Bx.receipt, color: AppTheme.color),
            title: Text('Receipts'),
            tileColor: selectedNav == 'receipts'
                ? Colors.grey.withAlpha(50)
                : null,
            onTap: () => onTap('receipts'),
          ),
          ListTile(
            leading: Iconify(Bx.category, color: AppTheme.color),
            title: Text('Items'),
            onTap: () => onTap('items'),
            tileColor: selectedNav == 'items'
                ? Colors.grey.withAlpha(30)
                : null,
          ),
          ListTile(
            leading: Iconify(Bx.devices, color: AppTheme.color),
            title: Text('Devices'),
            onTap: () => Get.to(() => ScreenDevicesSection()),
          ),
          ListTile(
            leading: Iconify(Bx.cog, color: AppTheme.color),
            title: Text('Settings'),
            onTap: () => Get.to(() => ScreenSettingsPage()),
          ),
          Dialog(),
          ListTile(
            leading: Iconify(Bx.bar_chart, color: AppTheme.color),
            title: Text('Dashboard'),
            onTap: () {
              Get.back();
              Get.to(() => ScreenDashboard());
            },
          ),
          ListTile(
            leading: Iconify(Bx.help_circle, color: AppTheme.color),
            title: Text('Help & Support'),
            onTap: () => onTap('help'),
          ),
        ],
      ),
    );
  }
}
