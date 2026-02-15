import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:mistpos/controllers/expenses_controller.dart';
import 'package:mistpos/models/gateway.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mistpos/models/shifts_model.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/screens/basic/screen_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/screens/auth/screen_splash.dart';
import 'package:mistpos/models/item_unsaved_model.dart';
import 'package:mistpos/models/notification_model.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/controllers/firebase_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/controllers/items_unsaved_controller.dart';
import 'package:mistpos/firebase-messanging/firebase_bg_notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([
    GatewaySchema,
    TaxModelSchema,
    ItemModelSchema,
    ShiftsModelSchema,
    ItemModifierSchema,
    DiscountModelSchema,
    ItemReceitModelSchema,
    ItemUnsavedModelSchema,
    NotificationModelSchema,
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
        Get.put(ItemsUnsavedController());
        Get.put(FirebaseController());
        Get.put(ExpensesController());
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  addMessage(message);
}
