import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool _isScanning = false;
  final List<PrinterDevice> _bluetoothDevices = [];
  StreamSubscription<PrinterDevice>? _scanSubscription;

  // Timer to enforce a maximum scan duration
  Timer? _scanTimeout;

  void _resetScanningState() {
    _scanTimeout?.cancel();
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
      _bluetoothDevices.clear(); // Clear old list
    });

    try {
      final scanStream = printer.scanBluetooth();
      // 1. Fetch System Paired/Known Devices
      // Using the synchronous getter 'systemDevices' as is common in newer versions.
      final List<BluetoothDevice> systemDevices =
          await FlutterBluePlus.systemDevices([]); // <-- FIX: Removed 'await'

      for (var device in systemDevices) {
        // Create a mock PrinterDevice object from the system device
        final pairedDevice = PrinterDevice(
          id: device.remoteId.str,
          type: PrinterType.bluetooth,
          name: device.platformName,
          address: device.remoteId.str,
        );

        // Add if not already present
        if (!_bluetoothDevices.any((d) => d.address == pairedDevice.address)) {
          _bluetoothDevices.add(pairedDevice);
        }
      }
      if (mounted) setState(() {}); // Update UI with paired devices

      // 2. Start Live Scan for Discoverable Devices (via pos_universal_printer)

      // Start the timeout timer for 10 seconds
      _scanTimeout = Timer(const Duration(seconds: 10), () async {
        if (_isScanning) {
          await FlutterBluePlus.stopScan();
          await _scanSubscription?.cancel();
          Toaster.showError("Bluetooth scanning timed out.");
          _resetScanningState();
        }
      });

      _scanSubscription = scanStream.listen(
        (device) {
          // Add newly discovered device if it's not already in the list
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
          // Stream completed naturally, reset state
          Toaster.showSuccess("Bluetooth devices scanning completed");
          _resetScanningState();
        },
        onError: (e) {
          Toaster.showError('Bluetooth Scan Stream Error: $e');
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
      await _initializeBluetooth();
      await _scanBluetoothDevices();
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _scanTimeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Scan"),
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
        // Show loader while scanning
        MistLoader1().center().expanded1.visibleIf(_isScanning),

        // Show device list when not scanning and devices are found
        ListView.builder(
          itemCount: _bluetoothDevices.length,
          itemBuilder: (BuildContext context, int index) {
            final device = _bluetoothDevices[index];
            return ListTile(
              title: device.name.text(),
              onTap: () async {
                try {
                  await _scanSubscription?.cancel();
                  _resetScanningState();
                  final result = await _devicesController.connectToBluetooth(
                    device.name,
                    device.address ?? '',
                    _userController.user.value,
                  );
                  if (result) {
                    Get.back();
                    Toaster.showSuccess("device connected");
                  }
                } catch (e) {
                  log('🚨 CRASH PREVENTED: Bluetooth Connection Error: $e');
                  Toaster.showError(
                    "Connection terminated: ${e.toString().split(':')[0]}",
                  );
                }
              },
              subtitle: device.address?.text(),
              leading: Iconify(Bx.bluetooth, color: Colors.blue),
            );
          },
        ).expanded1.visibleIf(!_isScanning && _bluetoothDevices.isNotEmpty),

        // Show instructions if no devices are found
        [
              Iconify(Bx.bluetooth, color: Colors.blue, size: 48),
              const Text("No devices found.").padding(EdgeInsets.only(top: 16)),
              const Text(
                "If your printer is not listed, ensure it is paired in your phone's system Bluetooth settings and all permissions are granted.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ).padding(EdgeInsets.only(top: 8)),
            ]
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
        Toaster.showError("Bluetooth not supported on this device.");
        return;
      }

      if (Platform.isAndroid) {
        var status = await Permission.bluetoothScan.request();
        if (status.isDenied) {
          Toaster.showError("Bluetooth Scan permission denied.");
          return;
        }

        status = await Permission.bluetoothConnect.request();
        if (status.isDenied) {
          Toaster.showError("Bluetooth Connect permission denied.");
          return;
        }

        if (await Permission.location.isDenied) {
          status = await Permission.location.request();
          if (status.isDenied) {
            Toaster.showError(
              "Location permission denied (required for scanning).",
            );
            return;
          }
        }
        await FlutterBluePlus.turnOn();
      }

      FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        if (state != BluetoothAdapterState.on) {
          Toaster.showError("Bluetooth is currently turned off.");
        }
      });
    } catch (e) {
      Toaster.showError("Error initializing Bluetooth: $e");
    }
  }
}
