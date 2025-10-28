import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

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
          ListTile(
            leading: Iconify(Carbon.user_avatar),
            title: widget.userName.text(),
            subtitle: widget.userEmail.text(style: TextStyle(fontSize: 12)),
          ),
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
            leading: Iconify(Carbon.user_multiple, color: Colors.green),
            title: "Suppliers".text(),
            onTap: () => widget.onTap("Suppliers"),
            tileColor: widget.selectedTile == "Suppliers"
                ? Colors.grey.withAlpha(50)
                : null,
          ),
        ],
      ),
    );
  }
}
