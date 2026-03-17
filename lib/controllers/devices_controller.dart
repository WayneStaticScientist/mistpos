import 'dart:math' as math;

import 'package:mistpos/main.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/shifts_model.dart';
import 'package:mistpos/utils/offline_printer.dart';
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
    final isar = IsarStatic.getInstance();
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
    await isar.write((isar) async {
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
    final isar = IsarStatic.getInstance();
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
      await isar.write((isar) async {
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
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    printerDevices.value = isar.printerDeviceModels.where().findAll();
  }

  void forgetDevice(PrinterDeviceModel printerDevic) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    printer.unregisterDevice(PosPrinterRole.cashier);
    await isar.write((isar) async {
      isar.printerDeviceModels.delete(printerDevic.id);
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
    for (final row in model.extras) {
      if (!row.enabled) {
        continue;
      }
      if (row.key == "Company Logo" && row.type == "system") {
        OfflinePrinter.printLogo(model, b);
        continue;
      }
      if (row.value == "company" && row.type == "system") {
        b.text(
          user.companyName.toUpperCase().toString(),
          align: PosAlign.center,
          bold: true,
        );
        b.feed(2);
        b.text(
          'Company: ${user.companyName.toString()}',
          align: PosAlign.center,
        );
        continue;
      }
      if (row.value == "seller" && row.type == "system") {
        b.text('Role: ${user.role.toString()}');
        b.text('Pos: ${user.till.toString()}');
        continue;
      }
      if (row.value == "time" && row.type == "system") {
        b.text(
          'Time: ${DateTime.now().toString().substring(0, 19)}',
          align: PosAlign.center,
        );
        continue;
      }
      if (row.value == "fiscal" && row.type == "system") {
        b.feed(1);
        b.text('*** FISCAL RECEIPT ***', align: PosAlign.center, bold: true);
        b.feed(1);
        b.text('.' * receitWidth);
        continue;
      }

      if (row.value == "items" && row.type == "system") {
        OfflinePrinter.printReceitItems(
          model: model,
          b: b,
          itemReceitModel: itemReceitModel,
          user: user,
          salesTaxes: salesTaxes,
        );
      }
      if (row.value == "customer" && row.type == "system") {
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
        continue;
      }
      if (row.value == "qrcode" && row.type == "system") {
        if (enableQrCode) {
          b.feed(1);
          b.text("--- QR CODE ---", align: PosAlign.center, bold: true);
          b.qrCode(itemReceitModel.label);
          b.feed(1);
        }
        continue;
      }
      if (row.value == "label" && row.type == "system") {
        b.text('--- END ---', align: PosAlign.center);
        b.feed(1);
        b.text(itemReceitModel.label, align: PosAlign.center);
        b.feed(1);
        continue;
      }
      if (row.type == "normal-spaced") {
        String value = sanitizeInput(
          row.value,
          user,
          customer,
          itemReceitModel,
        );
        String label = padRight(row.key, receitWidth - value.length) + value;
        b.text(label, bold: row.isBold);
        continue;
      }
      if (row.type == "normal") {
        b.text(
          "${row.key} : ${sanitizeInput(row.value, user, customer, itemReceitModel)}",
          bold: row.isBold,
        );
        continue;
      }
      if (row.type == "space") {
        b.feed(1);
        continue;
      }
      if (row.type == "repeat") {
        String value = row.value * receitWidth;
        b.text(value);
        continue;
      }
      if (row.type == "comment") {
        b.text(
          sanitizeInput(row.value, user, customer, itemReceitModel),
          align: row.align == "center"
              ? PosAlign.center
              : (row.align == "left" ? PosAlign.left : PosAlign.right),
          bold: row.isBold,
        );
        continue;
      }
    }

    // --- SEPARATOR and ITEM HEADER (Manually Aligned) ---

    b.cut();
    printer.printEscPos(PosPrinterRole.cashier, b);
  }

  void connectLastDevice() async {
    final isar = IsarStatic.getInstance();
    final user = User.fromStorage();
    if (isar == null || user == null) {
      return;
    }
    final device = isar.printerDeviceModels
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

  static void printShift(ShiftsModel shift, User user) {
    final printer = PosUniversalPrinter.instance;
    final b = EscPosBuilder();
    final model = AppSettingsModel.fromStorage();
    int receitWidth = model.printerRecietLength;
    bool enableQrCode = model.enableQrCode;
    String padRight(String text, int length) => text.padRight(length, ' ');
    if (model.receitLogoPath.isNotEmpty) {
      final rasterImage = OfflinePrinter.getRasterImage(model.receitLogoPath);
      if (rasterImage != null) {
        b.feed(1);
        b.raster(rasterImage);
        b.feed(1);
      }
    }
    b.text(
      user.companyName.toUpperCase().toString(),
      align: PosAlign.center,
      bold: true,
    );
    b.feed(2);
    b.text('Company: ${user.companyName.toString()}', align: PosAlign.center);
    b.text('Role: ${user.role.toString()}');
    b.text('Pos: ${user.till.toString()}');
    b.text('Cashier: ${user.fullName.toUpperCase().trim()}');
    b.text(
      'Time: ${DateTime.now().toString().substring(0, 19)}',
      align: PosAlign.center,
    );
    b.feed(1);
    b.text('.' * receitWidth);
    b.text('*** SHIFT ***', align: PosAlign.center, bold: true);
    final totalSales = CurrenceConverter.getCurrenceFloatInStrings(
      shift.totalSales,
      user.baseCurrence,
    );

    String totalSalesLabel = "Total Sales :";
    b.text(
      padRight(
            totalSalesLabel.substring(
              0,
              math.min(totalSalesLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - totalSales.length,
          ) +
          totalSales,
    );

    final startingCash = CurrenceConverter.getCurrenceFloatInStrings(
      shift.cashDrawerStart,
      user.baseCurrence,
    );
    String startingCashLabel = "Starting cash :";
    b.text(
      padRight(
            startingCashLabel.substring(
              0,
              math.min(startingCashLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - startingCash.length,
          ) +
          startingCash,
    );

    final cashEnd = CurrenceConverter.getCurrenceFloatInStrings(
      shift.cashDrawerEnd,
      user.baseCurrence,
    );
    String cashEndLabel = "End cash :";
    b.text(
      padRight(
            cashEndLabel.substring(
              0,
              math.min(cashEndLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - cashEnd.length,
          ) +
          cashEnd,
    );

    final difference = CurrenceConverter.getCurrenceFloatInStrings(
      shift.cashDrawerEnd - shift.cashDrawerStart,
      user.baseCurrence,
    );

    String differenceLabel = "Difference :";
    b.text(
      padRight(
            differenceLabel.substring(
              0,
              math.min(differenceLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - difference.length,
          ) +
          difference,
    );

    final totalCustomers = shift.totalCustomers.toString();
    String totalCustomersLabel = "Total Customers: ";
    b.text(
      padRight(
            totalCustomersLabel.substring(
              0,
              math.min(
                totalCustomersLabel.length,
                (receitWidth * 0.65).toInt(),
              ),
            ),
            receitWidth - totalCustomers.length,
          ) +
          totalCustomers,
    );

    final salesQuantity = shift.salesQuantity.toString();
    String salesQuantityLabel = "Total Sales :";
    b.text(
      padRight(
            salesQuantityLabel.substring(
              0,
              math.min(salesQuantityLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - salesQuantity.length,
          ) +
          salesQuantity,
    );
    b.feed(1);
    b.text('.' * receitWidth);
    b.text('Time', align: PosAlign.center);
    b.feed(1);

    final shiftStart =
        "${shift.openShiftTime.hour.toString().padLeft(2, '0')}:${shift.openShiftTime.minute.toString().padLeft(2, '0')}";
    String shiftStartLabel = "Shift Start :";
    b.text(
      padRight(
            shiftStartLabel.substring(
              0,
              math.min(shiftStartLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - shiftStart.length,
          ) +
          shiftStart,
    );

    final shiftEnd =
        "${shift.closeShiftTime.hour.toString().padLeft(2, '0')}:${shift.closeShiftTime.minute.toString().padLeft(2, '0')}";
    String shiftEndLabel = "Shift End :";
    b.text(
      padRight(
            shiftEndLabel.substring(
              0,
              math.min(shiftEndLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - shiftEnd.length,
          ) +
          shiftEnd,
    );

    b.text(
      "${shift.closeShiftTime.difference(shift.openShiftTime).inHours.toString()} Hours of shift",
      align: PosAlign.center,
    );

    final dateInit = MistDateUtils.getInformalShortDate(shift.openShiftTime);
    String dateInitLabel = "Date :";
    b.text(
      padRight(
            dateInitLabel.substring(
              0,
              math.min(dateInitLabel.length, (receitWidth * 0.65).toInt()),
            ),
            receitWidth - dateInit.length,
          ) +
          dateInit,
    );
    if (enableQrCode) {
      b.feed(1);
      b.text("--- QR CODE ---", align: PosAlign.center, bold: true);
      b.qrCode(shift.shiftLabel);
      b.feed(1);
    }
    b.feed(1);
    b.cut();
    printer.printEscPos(PosPrinterRole.cashier, b);
  }

  static String sanitizeInput(
    String label,
    User user,
    CustomerModel? customer,
    ItemReceitModel itemReceitModel,
  ) {
    return label
        .replaceAll("%%customer%%", customer?.fullName ?? "customer")
        .replaceAll(
          "%%amount%%",
          CurrenceConverter.selectedCurrencyInString(itemReceitModel.total),
        )
        .replaceAll("%%cashier%%", itemReceitModel.cashier)
        .replaceAll("%%number%%", itemReceitModel.items.length.toString())
        .replaceAll("%%company%%", user.companyName)
        .replaceAll(
          "%%formatted_date%%",
          MistDateUtils.formatNormalDate(DateTime.now()),
        )
        .replaceAll("%%date%%", DateTime.now().toString())
        .replaceAll("%%day%%", DateTime.now().day.toString())
        .replaceAll("%%month%%", DateTime.now().month.toString())
        .replaceAll("%%year%%", DateTime.now().year.toString());
  }
}
