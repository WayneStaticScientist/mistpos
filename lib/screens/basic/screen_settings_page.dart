import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/themes/app_theme.dart';

class ScreenSettingsPage extends StatefulWidget {
  const ScreenSettingsPage({super.key});

  @override
  State<ScreenSettingsPage> createState() => _ScreenSettingsPageState();
}

class _ScreenSettingsPageState extends State<ScreenSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final model = AppSettingsModel.fromStorage();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          [
                "Theme Settings"
                    .text(style: TextStyle(fontWeight: FontWeight.bold))
                    .padding(EdgeInsets.all(14)),
                ListTile(
                  trailing: Switch(
                    value: model.useSystemDarkMode,
                    onChanged: (c) {
                      model.useSystemDarkMode = c;
                      model.saveToStorage();
                      setState(() {});
                      _changeTheme();
                    },
                  ),
                  leading: Iconify(Bx.adjust, color: AppTheme.color(context)),
                  title: "System Theme Mode".text(),
                  subtitle: "select type of theme mode you want".text(
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                ListTile(
                  onTap: () {
                    model.darkMode = !model.darkMode;
                    model.saveToStorage();
                    setState(() {});
                    _changeTheme();
                  },
                  enabled: !model.useSystemDarkMode,
                  trailing: Switch(
                    activeThumbColor: !model.useSystemDarkMode
                        ? null
                        : Colors.grey,
                    inactiveThumbColor: !model.useSystemDarkMode
                        ? null
                        : Colors.grey,
                    value: model.darkMode,
                    onChanged: (c) {
                      if (model.useSystemDarkMode) return;
                      model.darkMode = c;
                      model.saveToStorage();
                      setState(() {});
                      _changeTheme();
                    },
                  ),
                  leading: Iconify(
                    Bx.moon,
                    color: !model.useSystemDarkMode
                        ? AppTheme.color(context)
                        : Colors.grey,
                  ),
                  title: "Enable dark mode".text(),
                ),
              ]
              .column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              .decoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
              .padding(EdgeInsets.all(8)),
        ],
      ),
    );
  }

  void _changeTheme() {
    final model = AppSettingsModel.fromStorage();
    if (model.useSystemDarkMode) {
      Get.changeThemeMode(ThemeMode.system);
      return;
    }
    Get.changeThemeMode(model.darkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
