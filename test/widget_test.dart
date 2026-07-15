import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mistpos/features/settings/screens/screen_cash_payment.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';

void main() {
  testWidgets('Cash Payment Smoke Test', (WidgetTester tester) async {
    // Put controllers
    final user = Get.put(UserController());
    final items = Get.put(ItemsController());
    final inv = Get.put(InventoryController());
    final dev = Get.put(DevicesController());

    // Force size to desktop
    tester.binding.window.physicalSizeTestValue = const Size(1200, 900);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      GetMaterialApp(
        home: const ScreenCashPayment(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    // Verify if it finds the summary text
    final textFinder = find.text("TOTAL AMOUNT TO PAY");
    expect(textFinder, findsOneWidget);

    print("Elements found successfully!");
  });
}
