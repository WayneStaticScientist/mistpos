import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class ScreenSettingsPage extends StatefulWidget {
  const ScreenSettingsPage({super.key});

  @override
  State<ScreenSettingsPage> createState() => _ScreenSettingsPageState();
}

class _ScreenSettingsPageState extends State<ScreenSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          [
                "Theme Settings"
                    .text(style: TextStyle(fontWeight: FontWeight.bold))
                    .padding(EdgeInsets.all(14)),
                ListTile(
                  trailing: Switch(value: true, onChanged: (c) {}),
                  leading: Iconify(Bx.moon, color: Colors.white),
                  title: "System Theme Mode".text(),
                  subtitle: "select type of theme mode you want".text(
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ]
              .column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              .decoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(10),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
              .padding(EdgeInsets.all(8)),
        ],
      ),
    );
  }
}
