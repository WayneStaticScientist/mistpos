import 'dart:io';
import 'dart:math' as math;

import 'package:isar/isar.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DevicesController extends GetxController {
  RxBool hasPrinterConnections = RxBool(false);
  @override
  void onInit() {
    super.onInit();
    hasPrinterConnections.value = printer.isRoleConnected(
      PosPrinterRole.cashier,
    );
    connectLastDevice();
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
        connectingToDevice.value = false;
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
      connectingToDevice.value = false;
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
    CustomerModel? customer,
    List<TaxModel> salesTaxes,
  ) {
    final printer = PosUniversalPrinter.instance;
    final b = EscPosBuilder();
    final model = AppSettingsModel.fromStorage();
    int receitWidth = model.printerRecietLength;
    bool enableQrCode = model.enableQrCode;
    String padRight(String text, int length) => text.padRight(length, ' ');
    if (model.receitLogoPath.isNotEmpty) {
      final rasterImage = getRasterImage(model.receitLogoPath);
      if (rasterImage != null) {
        b.feed(1);
        b.raster(rasterImage);
        b.feed(1);
      }
    }
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
    b.text('.' * receitWidth);
    for (final item in itemReceitModel.items) {
      final itemPrice = item.addenum + item.price;
      final totalItemPrice = itemPrice * item.count;
      final totalStr = CurrenceConverter.getCurrenceFloatInStrings(
        totalItemPrice,
        user.baseCurrence,
      );
      final itemName = item.name.substring(
        0,
        math.min(item.name.length, (receitWidth * 0.65).toInt()),
      );
      String label =
          padRight(itemName, receitWidth - totalStr.length) + totalStr;
      b.text(label);
      final unitPriceStr = CurrenceConverter.getCurrenceFloatInStrings(
        itemPrice,
        user.baseCurrence,
      );
      String priceModel = "${item.count} x $unitPriceStr";
      if (item.discount > 0 && item.discountId != null) {
        priceModel +=
            " - ${(item.percentageDiscount ? '${item.discount}%' : CurrenceConverter.getCurrenceFloatInStrings(item.discount, user.baseCurrence))}";
      }
      b.text(priceModel);
    }
    // --- SEPARATOR ---
    b.text('.' * receitWidth);
    b.feed(1);
    final totalDueStr = CurrenceConverter.getCurrenceFloatInStrings(
      itemReceitModel.total,
      user.baseCurrence,
    );

    if (itemReceitModel.discounts.isNotEmpty) {
      b.feed(1);
      b.text('--- DISCOUNTS ---', align: PosAlign.center, bold: true);
      b.feed(1);
      for (final discount in itemReceitModel.discounts) {
        final discountStr = discount.percentageDiscount == false
            ? CurrenceConverter.getCurrenceFloatInStrings(
                discount.discount ?? 0.0,
                user.baseCurrence,
              )
            : '${discount.discount}%';
        String label = '${discount.name ?? '-no=name-'} - $discountStr';
        b.text(label);
      }
    }
    if (salesTaxes.isNotEmpty) {
      b.feed(1);
      b.text('--- Taxes ---', align: PosAlign.center, bold: true);
      b.feed(1);
      for (final tax in salesTaxes) {
        final taxString = '${tax.value}%';
        String label = '${tax.label} - $taxString';
        b.text(label);
      }
    }
    final totalLine =
        padRight('TOTAL DUE:', receitWidth - totalDueStr.length) + totalDueStr;
    b.text(totalLine, bold: true);

    b.feed(2);
    b.text('.' * receitWidth);
    if (customer != null) {
      b.feed(1);
      b.text("--- CUSTOMER INFO ---", align: PosAlign.center, bold: true);
      b.feed(1);
      b.text('Customer: ${customer.fullName}');
      b.text('Phone: ${customer.phoneNumber}');
      b.text('Email: ${customer.email}');
      b.text('Address: ${customer.address}');
      b.feed(1);
    }
    if (enableQrCode) {
      b.feed(1);
      b.text("--- QR CODE ---", align: PosAlign.center, bold: true);
      b.qrCode(itemReceitModel.label);
      b.feed(1);
    }
    b.text('--- END ---', align: PosAlign.center);
    b.feed(1);
    b.text(itemReceitModel.label, align: PosAlign.center);
    b.feed(1);
    b.cut();
    printer.printEscPos(PosPrinterRole.cashier, b);
  }

  static List<int>? getRasterImage(String receitLogoPath) {
    try {
      final imageBytes = File(receitLogoPath).readAsBytesSync();
      return imageBytes;
    } catch (_) {
      return null;
    }
  }

  void connectLastDevice() async {
    final isar = Isar.getInstance();
    final user = User.fromStorage();
    if (isar == null || user == null) {
      return;
    }
    final device = await isar.printerDeviceModels
        .where()
        .sortByIsConnected()
        .findFirst();
    if (device != null) {
      await printer.registerDevice(
        PosPrinterRole.cashier,
        PrinterDevice(
          id: user.hexId,
          name: user.fullName,
          type: PrinterType.bluetooth,
          address: device.address,
        ),
      );
    }
  }
}
