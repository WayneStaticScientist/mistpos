import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/features/auth/screens/screen_create_account.dart';
import 'package:mistpos/features/auth/screens/screen_login.dart';

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
    final primary = Get.theme.colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with full-screen cover
          Image.asset(
            isDark
                ? "assets/avatars/splash-dark.jpg"
                : "assets/avatars/splash.jpg",
            fit: BoxFit.cover,
          ),
          // Dark gradient overlay so text is always readable
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(30),
                  Colors.black.withAlpha(170),
                  Colors.black.withAlpha(230),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(),
                  // Logo mark
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withAlpha(100),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/launcher.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.7, 0.7)),
                  const SizedBox(height: 24),
                  // Brand name
                  Text(
                    'MistPos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  )
                      .animate(delay: 150.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 10),
                  Text(
                    'Your modern point of sale system.\nBuilt for speed. Designed for growth.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(160),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 48),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _AuthButton(
                          label: 'Sign In',
                          icon: Bx.log_in,
                          isPrimary: true,
                          onTap: () => Get.to(() => const ScreenLogin()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AuthButton(
                          label: 'Create Account',
                          icon: Bx.user_plus,
                          isPrimary: false,
                          onTap: () =>
                              Get.to(() => const ScreenCreateAccount()),
                        ),
                      ),
                    ],
                  )
                      .animate(delay: 350.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.4, end: 0),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isPrimary;
  final VoidCallback onTap;
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? primary : Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withAlpha(40), width: 1),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: primary.withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
