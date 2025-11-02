import 'package:get_storage/get_storage.dart';

class AppSettingsModel {
  bool externalBarCodeEnabled;
  bool useSystemDarkMode;
  bool darkMode;
  AppSettingsModel({
    required this.externalBarCodeEnabled,
    required this.useSystemDarkMode,
    required this.darkMode,
  });
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      AppSettingsModel(
        externalBarCodeEnabled: json["externalBarCodeEnabled"] ?? false,
        useSystemDarkMode: json["useSystemDarkMode"] ?? true,
        darkMode: json["darkMode"] ?? false,
      );
  Map<String, dynamic> toJson() => {
    "externalBarCodeEnabled": externalBarCodeEnabled,
    "useSystemDarkMode": useSystemDarkMode,
    "darkMode": darkMode,
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
