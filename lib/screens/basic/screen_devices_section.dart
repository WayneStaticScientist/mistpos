import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/screens/basic/screen_connected_printers.dart';
import 'package:mistpos/themes/app_theme.dart';

class ScreenDevicesSection extends StatefulWidget {
  const ScreenDevicesSection({super.key});

  @override
  State<ScreenDevicesSection> createState() => _ScreenDevicesSectionState();
}

class _ScreenDevicesSectionState extends State<ScreenDevicesSection> {
  @override
  Widget build(BuildContext context) {
    final model = AppSettingsModel.fromStorage();
    return Scaffold(
      appBar: AppBar(title: Text("Connected Devices")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          18.gapHeight,
          [
                "Systematic Devices"
                    .text(style: TextStyle(fontWeight: FontWeight.bold))
                    .padding(EdgeInsets.all(14)),
                ListTile(
                  onTap: () => Get.to(() => ScreenConnectedPrinters()),
                  leading: Iconify(Bx.printer, color: AppTheme.color(context)),
                  title: "Printers".text(),
                  subtitle: "bluetooth , wifi , ethernet printers".text(
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
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
              .padding(EdgeInsets.all(8)),
          18.gapHeight,
          [
                "Autonomous Communications"
                    .text(style: TextStyle(fontWeight: FontWeight.bold))
                    .padding(EdgeInsets.all(14)),
                ListTile(
                  onTap: () {
                    model.externalBarCodeEnabled =
                        !model.externalBarCodeEnabled;
                    model.saveToStorage();
                    setState(() {});
                  },
                  leading: Iconify(Bx.scan, color: AppTheme.color(context)),
                  title: "External Barcode Scanner".text(),
                  trailing: Switch(
                    value: model.externalBarCodeEnabled,
                    onChanged: (stat) {
                      model.externalBarCodeEnabled = stat;
                      model.saveToStorage();
                      setState(() {});
                    },
                  ),
                  subtitle: "enable external barcode scanners (experimental)"
                      .text(style: TextStyle(color: Colors.grey, fontSize: 12)),
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
}
