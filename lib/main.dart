import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/gateway.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/screens/basic/screen_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/screens/auth/screen_splash.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([
    GatewaySchema,
    ItemModelSchema,
    ItemModifierSchema,
    DiscountModelSchema,
    ItemReceitModelSchema,
    ItemCategoryModelSchema,
    PrinterDeviceModelSchema,
    ItemSavedItemsModelSchema,
  ], directory: dir.path);
  await GetStorage.init();
  runApp(const MyApp());
  Get.put(ItemsController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final model = AppSettingsModel.fromStorage();
    return GetMaterialApp(
      title: 'MistPos',
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
        Get.put(ItemsController());
        Get.put(AdminController());
        Get.put(InventoryController());
        Get.put(DevicesController());
      }),

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: model.useSystemDarkMode
          ? ThemeMode.system
          : model.darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: User.fromStorage() == null
          ? const ScreenSplash()
          : const ScreenMain(),
    );
  }
}
