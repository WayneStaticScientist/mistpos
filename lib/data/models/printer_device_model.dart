import 'package:isar_plus/isar_plus.dart';

import 'package:mistpos/main.dart';
part 'printer_device_model.g.dart';

@collection
class PrinterDeviceModel {
  // Isar id
  late int id = IdGen.id;

  String name;
  String address;
  bool isConnected;
  int port;
  // NEW: role that identifies which PosPrinterRole the device belongs to
  @Index()
  String role; // e.g. 'cashier', 'customer', 'label'

  PrinterDeviceModel({
    required this.name,
    required this.address,
    this.isConnected = false,
    this.port = 9100,
    this.role = 'cashier', // default for backward compatibility
  });
}
