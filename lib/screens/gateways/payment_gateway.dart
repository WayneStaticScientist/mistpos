import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/screens/gateways/paynow/setup_paynow.dart';

class ScreenPaymentGetway extends StatefulWidget {
  const ScreenPaymentGetway({super.key});

  @override
  State<ScreenPaymentGetway> createState() => _ScreenPaymentGetwayState();
}

class _ScreenPaymentGetwayState extends State<ScreenPaymentGetway> {
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Getways")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          24.gapColumn,
          MistMordernLayout(
            label: "Payment Getways",
            children: [
              Obx(
                () => ListTile(
                  onTap: () => Get.to(() => ScreenSetupPaynow()),
                  contentPadding: EdgeInsets.all(0),
                  title: "Paynow(Zimbabwe) ".text(),
                  subtitle:
                      (_userController.user.value?.paynowActivated ?? false
                              ? 'update paynow detais'
                              : "setup paynow account")
                          .text(
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                  trailing: Iconify(Bx.check_circle, color: Colors.green)
                      .visibleIf(
                        _userController.user.value?.paynowActivated ?? false,
                      ),
                  leading: Iconify(
                    Bx.bxs_package,
                    color: AppTheme.color(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
