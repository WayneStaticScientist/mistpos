import 'package:isar/isar.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';

class DevicesController extends GetxController {
  RxBool hasPrinterConnections = RxBool(false);
  @override
  void onInit() {
    super.onInit();
    hasPrinterConnections.value = printer.isRoleConnected(
      PosPrinterRole.cashier,
    );
  }

  bool isPrinterConnected() {
    return printer.isRoleConnected(PosPrinterRole.cashier);
  }

  final PosUniversalPrinter printer = PosUniversalPrinter.instance;
  RxBool cashierConnected = false.obs;
  RxBool connectingToDevice = false.obs;
  RxList<PrinterDeviceModel> printerDevices = RxList<PrinterDeviceModel>([]);

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
      return;
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
    getConnectedDevices();
  }

  Future<bool> connectToBluetooth(
    String name,
    String macAddress,
    User? user,
  ) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("Database was not initialized");
      return false;
    }
    if (user == null) {
      Toaster.showError("User should be register first");
      return false;
    }
    try {
      connectingToDevice.value = true;
      await printer.registerDevice(
        PosPrinterRole.cashier,
        PrinterDevice(
          id: user.hexId,
          name: user.fullName,
          type: PrinterType.bluetooth,
          address: macAddress,
        ),
      );
      cashierConnected.value = false;
      for (int i = 0; i < 10; i++) {
        if (printer.isRoleConnected(PosPrinterRole.cashier)) {
          cashierConnected.value = true;
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
      connectingToDevice.value = true;

      if (!cashierConnected.value) {
        Toaster.showError(
          "Failed to connect to device , Switch on bluetooth and try again",
        );
        return false;
      }
      await isar.writeTxn(() async {
        isar.printerDeviceModels.put(
          PrinterDeviceModel(
            name: name,
            address: macAddress,
            isConnected: cashierConnected.value,
            port: 0,
          ),
        );
      });
      getConnectedDevices();
      return true;
    } catch (e) {
      connectingToDevice.value = false;
      Toaster.showError("There was error : $e");
      return false;
    }
  }

  void getConnectedDevices() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    printerDevices.value = await isar.printerDeviceModels.where().findAll();
  }

  void forgetDevice(PrinterDeviceModel printerDevic) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    printer.unregisterDevice(PosPrinterRole.cashier);
    await isar.writeTxn(() async {
      await isar.printerDeviceModels.delete(printerDevic.id);
    });
    Toaster.showError(
      "Printer device disconnected , you might wanna connect from devices",
    );
    getConnectedDevices();
  }
}
