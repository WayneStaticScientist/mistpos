import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class MistMainNavigationView extends StatelessWidget {
  final Function(String value) onTap;
  final String selectedNav;
  const MistMainNavigationView({
    super.key,
    required this.onTap,
    required this.selectedNav,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Get.theme.colorScheme.primary),
            child: 'MistPos'.text(
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Iconify(Bx.cart),
            title: Text('Sales'),
            onTap: () => onTap('sales'),
            tileColor: selectedNav == 'sales'
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ListTile(
            leading: Iconify(Bx.receipt),
            title: Text('Receipts'),
            tileColor: selectedNav == 'receipts'
                ? Colors.grey.withAlpha(50)
                : null,
            onTap: () => onTap('receipts'),
          ),
          ListTile(
            leading: Iconify(Bx.category),
            title: Text('Items'),
            onTap: () => onTap('items'),
            tileColor: selectedNav == 'items'
                ? Colors.grey.withAlpha(30)
                : null,
          ),
          ListTile(
            leading: Iconify(Bx.cog),
            title: Text('Settings'),
            onTap: () => onTap('settings'),
          ),
          Dialog(),
          ListTile(
            leading: Iconify(Bx.bar_chart),
            title: Text('Dashboard'),
            onTap: () => onTap('dashboard'),
          ),
          ListTile(
            leading: Iconify(Bx.help_circle),
            title: Text('Help & Support'),
            onTap: () => onTap('help'),
          ),
        ],
      ),
    );
  }
}
