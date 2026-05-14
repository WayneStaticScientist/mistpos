import 'package:isar_plus/isar_plus.dart';

import '../main.dart';
part 'printer_device_model.g.dart';

@collection
class PrinterDeviceModel {
  late int id = IdGen.id;
  String name;
  String address;
  bool isConnected;
  int port;
  /// Whether this printer is selected for multi-point printing
  bool isSelectedForMultiPrint;
  /// Connection type: "bluetooth", "network", or "usb"
  String connectionType;
  PrinterDeviceModel({
    required this.name,
    required this.address,
    this.isConnected = false,
    this.port = 9100,
    this.isSelectedForMultiPrint = true,
    this.connectionType = "bluetooth",
  });
}
