import 'package:isar/isar.dart';
part 'printer_device_model.g.dart';

@collection
class PrinterDeviceModel {
  Id id = Isar.autoIncrement;
  String name;
  String address;
  bool isConnected;
  int port;
  PrinterDeviceModel({
    required this.name,
    required this.address,
    this.isConnected = false,
    this.port = 9100,
  });
}
