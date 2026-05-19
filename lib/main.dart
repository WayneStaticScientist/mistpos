import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_plus/isar_plus.dart';
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
import 'package:window_manager/window_manager.dart';
import 'package:mistpos/widgets/layouts/custom_title_bar.dart';

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
    initIsarDatabase(IsarStatic.externalDirectory!);
    if (!GetPlatform.isDesktop) {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
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

  if (GetPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1100, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
      }),

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: model.useSystemDarkMode
          ? ThemeMode.system
          : model.darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: DesktopWindowWrapper(
        child: User.fromStorage() == null
            ? const ScreenSplash()
            : const ScreenMain(),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  addMessage(message);
}
