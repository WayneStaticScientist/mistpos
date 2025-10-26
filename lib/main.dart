import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/screens/auth/screen_splash.dart';
import 'package:mistpos/screens/basic/screen_main.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([
    ItemModelSchema,
    ItemModifierSchema,
    ItemReceitModelSchema,
    ItemCategoryModelSchema,
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
    return GetMaterialApp(
      title: 'MistPos',
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
        Get.put(ItemsController());
      }),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Color.fromARGB(255, 20, 89, 180),
          secondary: Colors.orange,
          surface: const Color.fromARGB(248, 255, 255, 255),
        ),
      ),
      home: User.fromStorage() == null
          ? const ScreenSplash()
          : const ScreenMain(),
    );
  }
}
