import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/layouts/profile_tile.dart';

class MistInventoryNavBar extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String selectedTile;
  final Function(String label) onTap;
  const MistInventoryNavBar({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.selectedTile,
    required this.onTap,
  });

  @override
  State<MistInventoryNavBar> createState() => _MistInventoryNavBarState();
}

class _MistInventoryNavBarState extends State<MistInventoryNavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ProfileTile(),
          Divider(color: Colors.grey.withAlpha(100), thickness: 1),
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
            leading: Iconify(Carbon.study_transfer, color: Colors.orangeAccent),
            title: "Transfer Orders".text(),
            onTap: () => widget.onTap("Transfer Orders"),
            tileColor: widget.selectedTile == "Transfer Orders"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
          ListTile(
            leading: Iconify(Carbon.inventory_management, color: Colors.indigo),
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
        ],
      ),
    );
  }
}
