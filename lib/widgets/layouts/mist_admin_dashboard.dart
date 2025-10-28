import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/screens/basic/screen_inventory_management.dart';

class MistAdminDashboard extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String selectedTile;
  final Function(String label) onTap;
  const MistAdminDashboard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.selectedTile,
    required this.onTap,
  });

  @override
  State<MistAdminDashboard> createState() => _MistAdminDashboardState();
}

class _MistAdminDashboardState extends State<MistAdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Iconify(Carbon.user_avatar),
            title: widget.userName.text(),
            subtitle: widget.userEmail.text(style: TextStyle(fontSize: 12)),
          ),
          Divider(color: Colors.grey.withAlpha(100), thickness: 1),
          ListTile(
            leading: Iconify(Carbon.dashboard, color: Colors.blueAccent),
            title: "Overview".text(),
            onTap: () => widget.onTap("Overview"),
            tileColor: widget.selectedTile == "Overview"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ListTile(
            leading: Iconify(Carbon.receipt, color: Colors.red),
            title: "Receits".text(),
            onTap: () => widget.onTap("Receits"),
            tileColor: widget.selectedTile == "Receits"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ExpansionTile(
            title: "Items".text(),
            leading: Iconify(Carbon.shopping_cart, color: Colors.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            childrenPadding: EdgeInsets.all(15),
            collapsedBackgroundColor:
                [
                  "Items",
                  "Categories",
                  "Modifiers",
                  "Discounts",
                ].contains(widget.selectedTile)
                ? Colors.grey.withAlpha(50)
                : null,
            children: [
              ListTile(
                title: "Items".text(),
                leading: Iconify(Carbon.shopping_cart, color: Colors.green),
                onTap: () => widget.onTap("Items"),
                tileColor: widget.selectedTile == "Items"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                title: "Categories".text(),
                leading: Iconify(Carbon.shopping_catalog, color: Colors.orange),
                onTap: () => widget.onTap("Categories"),
                tileColor: widget.selectedTile == "Categories"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                title: "Modifiers".text(),
                leading: Iconify(Carbon.model_builder, color: Colors.purple),
                onTap: () => widget.onTap("Modifiers"),
                tileColor: widget.selectedTile == "Modifiers"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                title: "Discounts".text(),
                leading: Iconify(Carbon.tag, color: Colors.pink),
                onTap: () => widget.onTap("Discounts"),
                tileColor: widget.selectedTile == "Discounts"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
            ],
          ),
          ListTile(
            onTap: () => Get.to(() => ScreenInventoryManagement()),
            leading: Iconify(Carbon.workspace, color: Colors.grey),
            title: "Inventory Management".text(),
          ),
          ListTile(
            leading: Iconify(Carbon.two_person_lift, color: Colors.cyan),
            title: "Employees".text(),
            onTap: () => widget.onTap("Employees"),
            tileColor: widget.selectedTile == "Employees"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ListTile(
            leading: Iconify(Carbon.person_favorite, color: Colors.teal),
            title: "Customers".text(),
          ),
        ],
      ),
    );
  }
}
