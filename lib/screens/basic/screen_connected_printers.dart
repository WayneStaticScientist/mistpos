import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/printer_device_model.dart';
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
  void initState() {
    super.initState();
    _devicesController.getConnectedDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connected Printers")),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _addDevice,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => [
          [
                Iconify(Bx.wifi, color: AppTheme.color(context)),
                18.gapWidth,
                "No connected devices , click + to add one".text(
                  textAlign: TextAlign.center,
                ),
              ]
              .column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              )
              .expanded1
              .visibleIf(
                !_devicesController.connectingToDevice.value &&
                    _devicesController.printerDevices.isEmpty,
              ),
          MistLoader1().center().expanded1.visibleIf(
            _devicesController.connectingToDevice.value,
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () =>
                  _forgetDevice(_devicesController.printerDevices[index]),
              title: _devicesController.printerDevices[index].name.text(),
              subtitle: _devicesController.printerDevices[index].address.text(),
              trailing: Iconify(Bx.bx_devices, color: Colors.blue),
            ),
            itemCount: _devicesController.printerDevices.length,
          ).expanded1,
        ].column().sizedBox(width: double.infinity),
      ),
    );
  }

  void _addDevice() {
    Get.bottomSheet(
      [
        CardButtons(
          onTap: _connectWithNetwork,
          icon: Iconify(Bx.wifi, color: AppTheme.color(context)),
          label: "On Network",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          onTap: () => {Get.back(), Get.to(() => ScreenBluetoothScan())},
          icon: Iconify(Bx.bluetooth, color: AppTheme.color(context)),
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

  void _forgetDevice(PrinterDeviceModel printerDevic) {
    Get.defaultDialog(
      title: "Forget Device",
      content: "do you want to forget this device ?".text(),
      actions: [
        "close".text().textButton(
          onPressed: () {
            Get.back();
          },
        ),
        'forget'.text().textButton(
          onPressed: () {
            _devicesController.forgetDevice(printerDevic);
            Get.back();
          },
        ),
      ],
    );
  }
}
