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
    this.useGridViewForItems = true,
    this.hasAlertedAboutFreeVersion = false,
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
        useGridViewForItems: json["useGridViewForItems"] ?? true,
        hasAlertedAboutFreeVersion: json["hasAlertedAboutFreeVersion"] ?? false,
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
  };
  static AppSettingsModel fromStorage() {
    GetStorage box = GetStorage();
    final settings = AppSettingsModel.fromJson(box.read('appSettings') ?? {});
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
    }
    return settings;
  }

  void saveToStorage() {
    GetStorage box = GetStorage();
    box.write('appSettings', toJson());
  }
}
