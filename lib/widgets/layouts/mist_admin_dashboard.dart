import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/layouts/profile_tile.dart';

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
          ProfileTile(),
          Divider(color: Colors.grey.withAlpha(50), thickness: 1),
          ExpansionTile(
            title: "Statistics".text(),
            childrenPadding: EdgeInsets.symmetric(horizontal: 14),
            shape: RoundedRectangleBorder(),
            leading: Iconify(Bx.stats, color: Colors.deepPurple),
            collapsedBackgroundColor:
                ["Overview", "Daily Sales"].contains(widget.selectedTile)
                ? Colors.grey.withAlpha(50)
                : null,
            children: [
              ListTile(
                leading: Iconify(Carbon.dashboard, color: Colors.blueAccent),
                title: "Overview".text(),
                onTap: () => widget.onTap("Overview"),
                tileColor: widget.selectedTile == "Overview"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.sun, color: Colors.brown),
                title: "Daily Sales".text(),
                onTap: () => widget.onTap("Daily Sales"),
                tileColor: widget.selectedTile == "Daily Sales"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.user, color: Colors.purpleAccent),
                title: "Sales By Employee".text(),
                onTap: () => widget.onTap("Sales By Employee"),
                tileColor: widget.selectedTile == "Sales By Employee"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.money, color: Colors.deepOrangeAccent),
                title: "Sales By Payments".text(),
                onTap: () => widget.onTap("Sales By Payments"),
                tileColor: widget.selectedTile == "Sales By Payments"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.train_time, color: Colors.deepPurple),
                title: "Shifts".text(),
                onTap: () => widget.onTap("Shifts"),
                tileColor: widget.selectedTile == "Shifts"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
            ],
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
          ExpansionTile(
            title: "Inventory".text(),
            collapsedBackgroundColor:
                [
                  "Transfer Orders",
                  "Productions",
                  "Inventory Counts",
                  "Suppliers",
                  "Purchase Orders",
                  "Stock Adjustments",
                ].contains(widget.selectedTile)
                ? Colors.grey.withAlpha(50)
                : null,
            leading: Iconify(
              Carbon.inventory_management,
              color: Colors.deepOrangeAccent,
            ),
            shape: RoundedRectangleBorder(),
            childrenPadding: EdgeInsets.symmetric(horizontal: 14),
            children: [
              ListTile(
                leading: Iconify(Carbon.purchase, color: Colors.blueAccent),
                title: "Purchase Orders".text(),
                onTap: () => widget.onTap("Purchase Orders"),
                tileColor: widget.selectedTile == "Purchase Orders"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Bx.cart, color: Colors.purpleAccent),
                title: "Stock Adjustments".text(),
                onTap: () => widget.onTap("Stock Adjustments"),
                tileColor: widget.selectedTile == "Stock Adjustments"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.user_multiple, color: Colors.green),
                title: "Suppliers".text(),
                onTap: () => widget.onTap("Suppliers"),
                tileColor: widget.selectedTile == "Suppliers"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(
                  Carbon.study_transfer,
                  color: Colors.orangeAccent,
                ),
                title: "Transfer Orders".text(),
                onTap: () => widget.onTap("Transfer Orders"),
                tileColor: widget.selectedTile == "Transfer Orders"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(
                  Carbon.inventory_management,
                  color: Colors.indigo,
                ),
                title: "Inventory Counts".text(),
                onTap: () => widget.onTap("Inventory Counts"),
                tileColor: widget.selectedTile == "Inventory Counts"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.product, color: Colors.lightBlue),
                title: "Productions".text(),
                onTap: () => widget.onTap("Productions"),
                tileColor: widget.selectedTile == "Productions"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.timer, color: Colors.lightGreenAccent),
                title: "Inventory History".text(),
                onTap: () => widget.onTap("Inventory History"),
                tileColor: widget.selectedTile == "Inventory History"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
              ListTile(
                leading: Iconify(Carbon.math_curve, color: Colors.teal),
                title: "Inventory Valuation".text(),
                onTap: () => widget.onTap("Inventory Valuation"),
                tileColor: widget.selectedTile == "Inventory Valuation"
                    ? Colors.grey.withAlpha(50)
                    : null,
              ),
            ],
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
            onTap: () => widget.onTap("Customers"),
            tileColor: widget.selectedTile == "Customers"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ListTile(
            leading: Iconify(Carbon.shopping_bag, color: Colors.amber),
            title: "Stores".text(),
            onTap: () => widget.onTap("Stores"),
            tileColor: widget.selectedTile == "Stores"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
        ],
      ),
    );
  }
}
