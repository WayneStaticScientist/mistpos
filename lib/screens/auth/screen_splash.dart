import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/screens/auth/screen_create_account.dart';
import 'package:mistpos/screens/auth/screen_login.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/widgets/layouts/auth_layout_wrapper.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/avatars/splash.jpg"), context);
    precacheImage(const AssetImage("assets/avatars/splash-dark.jpg"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLayoutWrapper(
        child: [
          Iconify(Bx.cube, size: 64, color: Get.theme.colorScheme.primary),
          14.gapHeight,
          "MistPos".text().styled(
            color: Get.theme.colorScheme.primary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          16.gapHeight,
          "Welcome to MistPos. Experience a modern, advanced, and highly intuitive point of sale system designed for professionals."
              .text(
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5),
              )
              .padding(const EdgeInsets.symmetric(horizontal: 14)),
          32.gapHeight,
          // Desktop buttons instead of bottom sheet
          [
            CardButtons(
              onTap: () => Get.to(() => const ScreenLogin()),
              icon: Iconify(Bx.user, color: AppTheme.color(context)),
              label: "Login",
              color: Get.theme.colorScheme.primary.withAlpha(20),
            ).expanded1,
            8.gapWidth,
            CardButtons(
              onTap: () => Get.to(() => const ScreenCreateAccount()),
              icon: Iconify(Bx.user_plus, color: AppTheme.color(context)),
              label: "Create Account",
              color: Get.theme.colorScheme.secondary.withAlpha(20),
            ).expanded1,
          ].row(),
        ].column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
