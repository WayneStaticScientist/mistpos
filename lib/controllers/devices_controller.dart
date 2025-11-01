import 'package:isar/isar.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';

class DevicesController extends GetxController {
  // @override
  // void onInit() {
  //   super.onInit();
  // }
  final PosUniversalPrinter printer = PosUniversalPrinter.instance;
  RxBool cashierConnected = false.obs;
  RxBool connectingToDevice = false.obs;

  Future<void> connectToNetwork(String ipAddress, int port, User? user) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("Database was not initialized");
      return;
    }
    if (user == null) {
      Toaster.showError("User should be register first");
      return;
    }
    connectingToDevice.value = true;
    await printer.registerDevice(
      PosPrinterRole.cashier,
      PrinterDevice(
        id: user.hexId,
        name: user.fullName,
        type: PrinterType.tcp,
        address: ipAddress,
        port: port,
      ),
    );
    connectingToDevice.value = false;
    cashierConnected.value = printer.isRoleConnected(PosPrinterRole.cashier);
    if (!cashierConnected.value) {
      Toaster.showError(
        "Failed to connect to device | check ip address and port from the device",
      );
    }
    await isar.writeTxn(() async {
      isar.printerDeviceModels.put(
        PrinterDeviceModel(
          name: ipAddress,
          address: ipAddress,
          isConnected: cashierConnected.value,
          port: port,
        ),
      );
    });
  }
}
