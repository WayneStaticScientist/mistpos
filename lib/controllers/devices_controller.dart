import 'dart:math' as math;

import 'package:get_storage/get_storage.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
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

  static void printReceitToBackround(
    ItemReceitModel itemReceitModel,
    User user,
  ) {
    final printer = PosUniversalPrinter.instance;
    final b = EscPosBuilder();
    GetStorage storage = GetStorage();
    int receitWidth = storage.read("receitWidth") ?? 42;
    String padRight(String text, int length) => text.padRight(length, ' ');
    String padLeft(String text, int length) => text.padLeft(length, ' ');
    b.text(user.companyName.toString(), align: PosAlign.center, bold: true);
    b.feed(2);
    b.text('Company: ${user.companyName.toString()}', align: PosAlign.center);
    b.text('Role: ${user.role.toString()}');
    b.text('Pos: ${user.till.toString()}');
    b.text(
      'Time: ${DateTime.now().toString().substring(0, 19)}',
      align: PosAlign.center,
    );
    b.feed(1);
    b.text('*** FISCAL RECEIPT ***', align: PosAlign.center, bold: true);
    b.feed(1);

    // --- SEPARATOR and ITEM HEADER (Manually Aligned) ---
    b.text('-' * receitWidth);
    // ITEM (22 chars) + QTY (4 chars) + TOTAL (16 chars) = 42
    b.text(
      padRight('ITEM', 22) + padRight('QTY', 4) + padLeft('TOTAL', 16),
      bold: true,
    );
    b.text('-' * receitWidth);
    for (final item in itemReceitModel.items) {
      final itemPrice = item.addenum + item.price;
      final totalItemPrice = itemPrice * item.count;
      final totalStr = CurrenceConverter.getCurrenceFloatInStrings(
        totalItemPrice,
        user.baseCurrence,
      );
      final itemName = item.name.substring(0, math.min(item.name.length, 22));
      if (item.count > 1) {
        final qtyStr = item.count.toString();
        final unitPriceStr = CurrenceConverter.getCurrenceFloatInStrings(
          itemPrice,
          user.baseCurrence,
        );
        String line1 =
            padRight(itemName, 22) + padLeft(qtyStr, 4) + padLeft(totalStr, 16);
        b.text(line1);
        b.text('  @ $unitPriceStr');
      } else {
        final singleItemName = item.name.substring(
          0,
          math.min(item.name.length, 26),
        );
        String line1 = padRight(singleItemName, 26) + padLeft(totalStr, 16);
        b.text(line1);
      }
    }

    // --- SEPARATOR ---
    b.text('=' * receitWidth);

    // --- 3. TOTALS SECTION ---
    b.feed(1);
    final totalDueStr = CurrenceConverter.getCurrenceFloatInStrings(
      itemReceitModel.total,
      user.baseCurrence,
    );
    final totalLine =
        padRight('TOTAL DUE:', receitWidth - totalDueStr.length) + totalDueStr;

    // The total is now only formatted with 'bold' and left alignment (since 'align: PosAlign.right' would align the entire string)
    b.text(totalLine, bold: true);

    b.feed(2);

    // --- 4. FOOTER SECTION ---
    b.text('--- THANK YOU FOR YOUR BUSINESS ---', align: PosAlign.center);
    b.text('--- END ---', align: PosAlign.center);
    b.feed(1);
    b.cut();
    printer.printEscPos(PosPrinterRole.cashier, b);
  }
}
