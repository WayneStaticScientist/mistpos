import 'package:get_storage/get_storage.dart';

class AppSettingsModel {
  bool externalBarCodeEnabled;
  bool useSystemDarkMode;
  bool darkMode;
  bool enableQrCode;
  int printerRecietLength = 32;
  int decimalPlaces = 2;
  bool prioritizeShift = true;
  String receitLogoPath;
  bool hasAlertedAboutFreeVersion = false;
  AppSettingsModel({
    required this.externalBarCodeEnabled,
    required this.useSystemDarkMode,
    required this.darkMode,
    required this.enableQrCode,
    required this.printerRecietLength,
    required this.decimalPlaces,
    this.receitLogoPath = "",
    this.prioritizeShift = true,
    this.hasAlertedAboutFreeVersion = false,
  });
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      AppSettingsModel(
        externalBarCodeEnabled: json["externalBarCodeEnabled"] ?? false,
        useSystemDarkMode: json["useSystemDarkMode"] ?? true,
        darkMode: json["darkMode"] ?? false,
        enableQrCode: json["enableQrCode"] ?? false,
        printerRecietLength: json["printerRecietLength"] ?? 32,
        decimalPlaces: json["decimalPlaces"] ?? 2,
        receitLogoPath: json["receitLogoPath"] ?? "",
        prioritizeShift: json["prioritizeShift"] ?? true,
        hasAlertedAboutFreeVersion: json["hasAlertedAboutFreeVersion"] ?? false,
      );
  Map<String, dynamic> toJson() => {
    "darkMode": darkMode,
    "enableQrCode": enableQrCode,
    "decimalPlaces": decimalPlaces,
    "receitLogoPath": receitLogoPath,
    "prioritizeShift": prioritizeShift,
    "useSystemDarkMode": useSystemDarkMode,
    "printerRecietLength": printerRecietLength,
    "externalBarCodeEnabled": externalBarCodeEnabled,
    "hasAlertedAboutFreeVersion": hasAlertedAboutFreeVersion,
  };
  static AppSettingsModel fromStorage() {
    GetStorage box = GetStorage();
    return AppSettingsModel.fromJson(box.read('appSettings') ?? {});
  }

  saveToStorage() {
    GetStorage box = GetStorage();
    box.write('appSettings', toJson());
  }
}
