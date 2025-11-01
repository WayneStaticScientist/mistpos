import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/screen_bluetooth_scan.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenConnectedPrinters extends StatefulWidget {
  const ScreenConnectedPrinters({super.key});

  @override
  State<ScreenConnectedPrinters> createState() =>
      _ScreenConnectedPrintersState();
}

class _ScreenConnectedPrintersState extends State<ScreenConnectedPrinters> {
  final _devicesController = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connected Printers")),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _addDevice,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addDevice() {
    Get.bottomSheet(
      [
        CardButtons(
          onTap: _connectWithNetwork,
          icon: Iconify(Bx.wifi, color: AppTheme.color),
          label: "On Network",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          onTap: () => {Get.back(), Get.to(() => ScreenBluetoothScan())},
          icon: Iconify(Bx.bluetooth, color: AppTheme.color),
          label: "BlueTooth",
          color: Get.theme.colorScheme.secondary.withAlpha(50),
        ).expanded1,
      ].row().padding(EdgeInsets.only(top: 18)).safeArea(),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  _connectWithNetwork() {
    Get.back();
    final ipAddress = TextEditingController();
    final port = TextEditingController(text: "9100");
    Get.defaultDialog(
      title: "Connect to Device",
      content: Obx(
        () => _devicesController.connectingToDevice.value
            ? MistLoader1()
            : (_devicesController.cashierConnected.value
                  ? "The device was succefully connected ".text()
                  : [
                      "Enter Device Ip Address".text(),
                      18.gapHeight,
                      MistFormInput(label: "Ip Address", controller: ipAddress),
                      18.gapHeight,
                      MistFormInput(label: "Port", controller: port),
                    ].column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )),
      ),
      actions: [
        "close".text().textButton(
          onPressed: () {
            Get.back();
          },
        ),
        Obx(
          () => "ok"
              .text()
              .textButton(
                onPressed: () {
                  _devicesController.connectToNetwork(
                    ipAddress.text,
                    int.tryParse(port.text) ?? 9100,
                    _userController.user.value,
                  );
                },
              )
              .visibleIf(
                !_devicesController.cashierConnected.value &&
                    !_devicesController.connectingToDevice.value,
              ),
        ),
      ],
    );
  }
}
