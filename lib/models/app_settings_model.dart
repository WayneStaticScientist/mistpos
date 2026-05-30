import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/receit_extras_model.dart';

class AppSettingsModel {
  bool externalBarCodeEnabled;
  bool useSystemDarkMode;
  bool darkMode;
  List<ReceitExtrasModel> extras;
  bool enableQrCode;
  int printerRecietLength = 32;
  int decimalPlaces = 2;
  bool prioritizeShift = true;
  String receitLogoPath;
  bool useGridViewForItems;
  bool hasAlertedAboutFreeVersion = false;
  /// Printing mode: "single" (one printer) or "multi" (all selected printers)
  String printingMode;
  bool enableCashDrawer;
  /// Trigger mode: "cash" (cash sales only) or "all" (all sales)
  String cashDrawerTriggerMode;
  AppSettingsModel({
    required this.externalBarCodeEnabled,
    required this.useSystemDarkMode,
    required this.darkMode,
    required this.enableQrCode,
    required this.printerRecietLength,
    required this.decimalPlaces,
    this.receitLogoPath = "",
    required this.extras,
    this.prioritizeShift = true,
    this.useGridViewForItems = false,
    this.hasAlertedAboutFreeVersion = false,
    this.printingMode = "single",
    this.enableCashDrawer = false,
    this.cashDrawerTriggerMode = "all",
  });
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      AppSettingsModel(
        extras:
            (json["extras"] as List<dynamic>?)
                ?.map((e) => ReceitExtrasModel.fromJSON(e))
                .toList() ??
            [],
        externalBarCodeEnabled: json["externalBarCodeEnabled"] ?? false,
        useSystemDarkMode: json["useSystemDarkMode"] ?? true,
        darkMode: json["darkMode"] ?? false,
        enableQrCode: json["enableQrCode"] ?? false,
        printerRecietLength: json["printerRecietLength"] ?? 32,
        decimalPlaces: json["decimalPlaces"] ?? 2,
        receitLogoPath: json["receitLogoPath"] ?? "",
        prioritizeShift: json["prioritizeShift"] ?? true,
        useGridViewForItems: json["useGridViewForItems"] ?? false,
        hasAlertedAboutFreeVersion: json["hasAlertedAboutFreeVersion"] ?? false,
        printingMode: json["printingMode"] ?? "single",
        enableCashDrawer: json["enableCashDrawer"] ?? false,
        cashDrawerTriggerMode: json["cashDrawerTriggerMode"] ?? "all",
      );
  Map<String, dynamic> toJson() => {
    "darkMode": darkMode,
    "enableQrCode": enableQrCode,
    "decimalPlaces": decimalPlaces,
    "receitLogoPath": receitLogoPath,
    "prioritizeShift": prioritizeShift,
    "useGridViewForItems": useGridViewForItems,
    "useSystemDarkMode": useSystemDarkMode,
    "printerRecietLength": printerRecietLength,
    "extras": extras.map((e) => e.toJson()).toList(),
    "externalBarCodeEnabled": externalBarCodeEnabled,
    "hasAlertedAboutFreeVersion": hasAlertedAboutFreeVersion,
    "printingMode": printingMode,
    "enableCashDrawer": enableCashDrawer,
    "cashDrawerTriggerMode": cashDrawerTriggerMode,
  };
  static AppSettingsModel fromStorage() {
    GetStorage box = GetStorage();
    final settings = AppSettingsModel.fromJson(box.read('appSettings') ?? {});
    bool changed = false;
    if (settings.extras.any((e) => e.value == "drawer")) {
      settings.extras.removeWhere((e) => e.value == "drawer");
      changed = true;
    }
    if (settings.extras.isEmpty) {
      settings.extras = [
        ReceitExtrasModel(
          key: "Company Logo",
          value: "logo",
          align: "center",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Company Info",
          value: "company",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Seller/Till Info",
          value: "seller",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Time",
          value: "time",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Fiscal Receit Label",
          value: "fiscal",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Receipt Items",
          value: "items",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Customer Details",
          value: "customer",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "QR Code",
          value: "qrcode",
          align: "left",
          isBold: false,
          type: "system",
        ),
        ReceitExtrasModel(
          key: "Receit End Label",
          value: "label",
          align: "left",
          isBold: false,
          type: "system",
        ),
      ];
      changed = true;
    }
    if (changed) {
      settings.saveToStorage();
    }
    return settings;
  }

  void saveToStorage() {
    GetStorage box = GetStorage();
    box.write('appSettings', toJson());
  }
}
