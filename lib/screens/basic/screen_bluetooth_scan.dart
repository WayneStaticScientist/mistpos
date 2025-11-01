import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
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
  bool _isScanning = false;
  List<PrinterDevice> _bluetoothDevices = [];

  Future<void> _scanBluetoothDevices() async {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _bluetoothDevices.clear();
    });

    try {
      final devices = await printer.scanBluetooth().toList();
      final dedup = <String, PrinterDevice>{};
      for (final d in devices) {
        dedup[d.id] = d;
      }
      if (!mounted) return;
      setState(() {
        _bluetoothDevices = dedup.values.toList();
        _isScanning = false;
      });
    } catch (e) {
      Toaster.showError("Error : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scanBluetoothDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Scan")),
      body: _isScanning
          ? MistLoader1().center()
          : ListView.builder(
              itemCount: _bluetoothDevices.length,
              itemBuilder: (BuildContext context, int index) {
                final device = _bluetoothDevices[index];
                return ListTile(
                  title: device.name.text(),
                  subtitle: device.address?.text(),
                  leading: Iconify(Bx.bluetooth, color: Colors.blue),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBluetoothDevices,
        child: Iconify(Bx.refresh, color: Colors.white),
      ),
    );
  }
}
