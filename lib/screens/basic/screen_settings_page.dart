import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/screens/auth/screen_user_profile.dart';

class ScreenSettingsPage extends StatefulWidget {
  const ScreenSettingsPage({super.key});

  @override
  State<ScreenSettingsPage> createState() => _ScreenSettingsPageState();
}

class _ScreenSettingsPageState extends State<ScreenSettingsPage> {
  @override
  Widget build(BuildContext context) {
    GetStorage storage = GetStorage();
    final model = AppSettingsModel.fromStorage();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          24.gapColumn,
          MistMordernLayout(
            label: "User",
            children: [
              ListTile(
                onTap: () => Get.to(() => ScreenUserProfile()),
                contentPadding: EdgeInsets.all(0),
                title: Text("My Profile"),
                subtitle: "view your profile".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                leading: Iconify(Bx.user, color: AppTheme.color(context)),
              ),
            ],
          ),
          24.gapColumn,
          MistMordernLayout(
            label: "Theme Settings",
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
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
                contentPadding: EdgeInsets.all(0),
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
            ],
          ),
          24.gapColumn,
          MistMordernLayout(
            label: "Receits",
            children: [
              ListTile(
                onTap: () => _changeSize(storage.read("receitWidth") ?? 42),
                contentPadding: EdgeInsets.all(0),
                title: Text("Printer Receit Length"),
                subtitle: "${storage.read("receitWidth") ?? 42} units".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                leading: Iconify(Bx.receipt, color: AppTheme.color(context)),
              ),
            ],
          ),
          24.gapColumn,
          MistMordernLayout(
            label: "Numbers",
            children: [
              ListTile(
                onTap: () =>
                    _changeDecimalPlaces(storage.read("decimalPlaces") ?? 2),
                contentPadding: EdgeInsets.all(0),
                title: Text("Decimal Places"),
                subtitle: "${storage.read("decimalPlaces") ?? 2} places".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                leading: Iconify(Bx.font_size, color: AppTheme.color(context)),
              ),
            ],
          ),
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

  _changeSize(int size) {
    final sizeController = TextEditingController(text: size.toString());
    Get.defaultDialog(
      title: "Printer Receit Length",
      content: MistFormInput(
        label: "size",
        controller: sizeController,
        isNumberInput: true,
      ),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "save".text().textButton(
          onPressed: () {
            if (sizeController.text.trim().isEmpty) {
              Toaster.showError("Size is required");
              return;
            }
            int? value = int.tryParse(sizeController.text.trim());
            if (value == null) {
              Toaster.showError("invalid number input");
              return;
            }
            Get.back();
            GetStorage storage = GetStorage();
            storage.write("receitWidth", value);
            setState(() {});
          },
        ),
      ],
    );
  }

  void _changeDecimalPlaces(int size) {
    final decimalPlacesController = TextEditingController(
      text: size.toString(),
    );
    Get.defaultDialog(
      title: "Decimal Places",
      content: MistFormInput(
        label: "size",
        controller: decimalPlacesController,
        isNumberInput: true,
      ),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "save".text().textButton(
          onPressed: () {
            if (decimalPlacesController.text.trim().isEmpty) {
              Toaster.showError("Size is required");
              return;
            }
            int? value = int.tryParse(decimalPlacesController.text.trim());
            if (value == null) {
              Toaster.showError("invalid number input");
              return;
            }
            Get.back();
            GetStorage storage = GetStorage();
            storage.write("decimalPlaces", value);
            setState(() {});
          },
        ),
      ],
    );
  }
}
