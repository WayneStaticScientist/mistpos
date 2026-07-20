import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

class ScreenUsbScan extends StatefulWidget {
  const ScreenUsbScan({super.key});

  @override
  State<ScreenUsbScan> createState() => _ScreenUsbScanState();
}

class _ScreenUsbScanState extends State<ScreenUsbScan> {
  final _printerManager = PrinterManager.instance;
  final _devicesController = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();
  bool _isScanning = false;
  final List<PrinterDevice> _usbDevices = [];
  StreamSubscription<PrinterDevice>? _scanSubscription;

  void _resetScanningState() {
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _scanUsbDevices() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _usbDevices.clear(); // Clear old list
    });

    try {
      final scanStream = _printerManager.discovery(type: PrinterType.usb);

      _scanSubscription = scanStream.listen(
        (device) {
          if (!_usbDevices.any((d) =>
              d.vendorId == device.vendorId && d.productId == device.productId)) {
            if (mounted) {
              setState(() {
                _usbDevices.add(device);
              });
            }
          }
        },
        onDone: () {
          Toaster.showSuccess("USB devices scanning completed");
          _resetScanningState();
        },
        onError: (e) {
          Toaster.showError('USB Scan Stream Error: $e');
          _resetScanningState();
        },
        cancelOnError: true,
      );
    } catch (e) {
      Toaster.showError("Error starting scan: $e");
      _resetScanningState();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scanUsbDevices();
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("USB Scan"),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {},
              icon: CircularProgressIndicator(color: AppTheme.color(context)),
            ).visibleIf(_devicesController.connectingToDevice.value),
          ),
        ],
      ),
      body: [
        MistLoader1().center().expanded1.visibleIf(_isScanning),
        ListView.builder(
          itemCount: _usbDevices.length,
          itemBuilder: (BuildContext context, int index) {
            final device = _usbDevices[index];
            return ListTile(
              title: (device.name != null && device.name!.isNotEmpty
                      ? device.name!
                      : "USB Printer")
                  .text(),
              onTap: () async {
                try {
                  await _scanSubscription?.cancel();
                  _resetScanningState();
                  final address = "${device.vendorId}-${device.productId}";
                  final result = await _devicesController.connectToUsb(
                    device.name ?? "USB Printer",
                    address,
                    _userController.user.value,
                  );
                  if (result) {
                    Get.back();
                    Toaster.showSuccess("USB device connected");
                  }
                } catch (e) {
                  log('🚨 CRASH PREVENTED: USB Connection Error: $e');
                  Toaster.showError(
                    "Connection terminated: ${e.toString().split(':')[0]}",
                  );
                }
              },
              subtitle:
                  "VID: ${device.vendorId} PID: ${device.productId}".text(),
              leading: Icon(Icons.usb, color: Colors.blue),
            );
          },
        ).expanded1.visibleIf(!_isScanning && _usbDevices.isNotEmpty),
        [
          Icon(Icons.usb, color: Colors.blue, size: 48),
          const Text("No devices found.").padding(EdgeInsets.only(top: 16)),
          const Text(
            "If your printer is not listed, ensure it is plugged in and supported.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ).padding(EdgeInsets.only(top: 8)),
        ]
            .column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            )
            .center()
            .visibleIf(!_isScanning && _usbDevices.isEmpty),
      ].column(),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanUsbDevices,
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
