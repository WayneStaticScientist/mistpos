import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/features/inventory/controllers/expenses_controller.dart';
import 'package:mistpos/features/admin/controllers/goals_tasks_controller.dart';
import 'package:mistpos/data/models/gateway.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/data/models/tax_model.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mistpos/data/models/shifts_model.dart';
import 'package:mistpos/data/models/discount_model.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/features/settings/screens/screen_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/features/auth/screens/screen_splash.dart';
import 'package:mistpos/data/models/item_unsaved_model.dart';
import 'package:mistpos/data/models/notification_model.dart';
import 'package:mistpos/data/models/item_modifier_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/data/models/printer_device_model.dart';
import 'package:mistpos/data/models/item_categories_model.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/data/models/item_saved_items_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:mistpos/core/services/firebase/firebase_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_unsaved_controller.dart';
import 'package:mistpos/core/services/firebase/firebase_bg_notification_handler.dart';

class IsarStatic {
  static Isar? isar;
  static Directory? externalDirectory;
  static Isar? getInstance() {
    if (IsarStatic.isar == null && externalDirectory != null) {
      initIsarDatabase(externalDirectory!);
    }
    return isar;
  }
}

class IdGen {
  static int get id {
    GetStorage storage = GetStorage();
    int id = storage.read("mist-id") ?? 0;
    storage.write("mist-id", id + 1);
    return id;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsarStatic.externalDirectory = await getApplicationDocumentsDirectory();
  final path = "${IsarStatic.externalDirectory!.path}/default.isar";
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    //
  }
  try {
    initIsarDatabase(IsarStatic.externalDirectory!);
  } catch (e) {
    if (e.toString().contains('deserialize') ||
        e.toString().contains('Schema')) {
      final dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
        final lockFile = File("$path.lock");
        if (await lockFile.exists()) await lockFile.delete();
      }
      initIsarDatabase(IsarStatic.externalDirectory!);
    }
  }
  await GetStorage.init();
  runApp(const MyApp());
  Get.put(ItemsController());
}

void initIsarDatabase(Directory dir) {
  IsarStatic.isar = Isar.open(
    schemas: [
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
    ],
    directory: dir.path,
  );
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
        Get.put(GoalsTasksController());
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
  try {
    await Firebase.initializeApp();
  } catch (e) {
    //
    return;
  }
  await GetStorage.init();
  addMessage(message);
}
