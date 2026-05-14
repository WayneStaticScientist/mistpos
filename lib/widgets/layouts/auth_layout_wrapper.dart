import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';

class AuthLayoutWrapper extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final String darkImagePath;

  const AuthLayoutWrapper({
    super.key,
    required this.child,
    this.imagePath = "assets/avatars/splash.jpg",
    this.darkImagePath = "assets/avatars/splash-dark.jpg",
  });

  @override
  Widget build(BuildContext context) {
    final imageToUse = Get.isDarkMode ? darkImagePath : imagePath;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          // Desktop split-pane view
          return Row(
            children: [
              // Left Image Pane
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageToUse),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(150),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              // Right Form Pane
              Expanded(
                flex: 1,
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Mobile view
          return SingleChildScrollView(
            child: Column(
              children: [
                // Top Image
                Image.asset(
                  imageToUse,
                  width: double.infinity,
                  height: Get.height * 0.35,
                  fit: BoxFit.cover,
                ),
                // Form
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: child,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
