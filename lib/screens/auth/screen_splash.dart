import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/screens/auth/screen_create_account.dart';
import 'package:mistpos/screens/auth/screen_login.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/widgets/buttons/mist_default.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/avatars/splash.jpg"), context);
    precacheImage(const AssetImage("assets/avatars/splash-dark.jpg"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: [
          Image.asset(
            Get.isDarkMode
                ? "assets/avatars/splash-dark.jpg"
                : "assets/avatars/splash.jpg",
            fit: BoxFit.cover,
          ).sizedBox(width: double.infinity, height: Get.height * 0.5),
          14.gapHeight,
          "MistPos".text().styled(
            color: Get.theme.colorScheme.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          8.gapHeight,
          "Welcome to MistPos , your point of sell system with modern advanced above human system"
              .text(textAlign: TextAlign.center)
              .padding(EdgeInsets.all(14)),
          12.gapHeight,
          MistButton(text: "Start", onPressed: _openBottomNav),
        ].column(),
      ),
    );
  }

  _openBottomNav() {
    Get.bottomSheet(
      [
        CardButtons(
          onTap: () => Get.to(() => ScreenLogin()),
          icon: Iconify(Bx.user, color: AppTheme.color(context)),
          label: "Login",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          onTap: () => Get.to(() => ScreenCreateAccount()),
          icon: Iconify(Bx.user_plus, color: AppTheme.color(context)),
          label: "Create Account",
          color: Get.theme.colorScheme.secondary.withAlpha(50),
        ).expanded1,
      ].row().padding(EdgeInsets.only(top: 18)).safeArea(),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }
}
