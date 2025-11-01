import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';

class ScreenBluetoothScan extends StatefulWidget {
  const ScreenBluetoothScan({super.key});

  @override
  State<ScreenBluetoothScan> createState() => _ScreenBluetoothScanState();
}

class _ScreenBluetoothScanState extends State<ScreenBluetoothScan> {
  final PosUniversalPrinter printer = PosUniversalPrinter.instance;
  final _devicesController = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();
  bool _isScanning = true;
  final List<PrinterDevice> _bluetoothDevices = [];
  late StreamSubscription<PrinterDevice>? _scanSubscription;
  void _resetScanningState() {
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _scanBluetoothDevices() async {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _bluetoothDevices.clear();
    });

    try {
      final scanStream = printer.scanBluetooth();

      _scanSubscription = scanStream.listen(
        (device) {
          // Device found: Add one device at a time, updating the UI
          if (device.type == PrinterType.bluetooth) {
            if (!_bluetoothDevices.any((d) => d.address == device.address)) {
              if (mounted) {
                setState(() {
                  _bluetoothDevices.add(device);
                });
              }
            }
          }
        },
        onDone: () {
          Toaster.showSuccess("Bluetooth devices scanning completed");
          _resetScanningState(); // Use a helper function for cleanup
        },
        onError: (e) {
          Toaster.showSuccess('Bluetooth Scan Stream Error: $e');
          _resetScanningState();
        },
        cancelOnError: true, // Stop listening if an error occurs
      );

      await Future.delayed(const Duration(seconds: 10));
      await _scanSubscription?.cancel();
      if (_isScanning) {
        _resetScanningState();
      }
    } catch (e) {
      Toaster.showError("Error : $e");
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeBluetooth();
      await _scanBluetoothDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Scan")),
      body: [
        MistLoader1().center().expanded1.visibleIf(_isScanning),
        ListView.builder(
          itemCount: _bluetoothDevices.length,
          itemBuilder: (BuildContext context, int index) {
            final device = _bluetoothDevices[index];
            return ListTile(
              title: device.name.text(),
              onTap: () async {
                final result = await _devicesController.connectToBluetooth(
                  device.name,
                  device.address ?? '',
                  _userController.user.value,
                );
                if (result) {
                  Toaster.showSuccess("device connected");
                  Get.back();
                }
              },
              subtitle: device.address?.text(),
              leading: Iconify(Bx.bluetooth, color: Colors.blue),
            );
          },
        ).expanded1.visibleIf(!_isScanning && _bluetoothDevices.isNotEmpty),
        [Iconify(Bx.bluetooth, color: Colors.blue)]
            .column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            )
            .center()
            .visibleIf(!_isScanning && _bluetoothDevices.isEmpty),
      ].column(),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBluetoothDevices,
        child: Iconify(Bx.refresh, color: Colors.white),
      ),
    );
  }

  Future<void> _initializeBluetooth() async {
    try {
      if (await FlutterBluePlus.isSupported == false) {
        Toaster.showError(
          "Bluetooth failed to turn on, May you turn on manually",
        );
        return;
      }
      var subscription = FlutterBluePlus.adapterState.listen((
        BluetoothAdapterState state,
      ) {
        if (state != BluetoothAdapterState.on) {
          Toaster.showError(
            "Bluetooth failed to turn on, May you turn on manually",
          );
        }
      });
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
        subscription.cancel();
      }
    } catch (e) {
      Toaster.showError("Error : $e");
    }
  }
}
