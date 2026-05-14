import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';

class CustomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomTitleBar({
    super.key,
    this.title = "MistPos",
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (!GetPlatform.isDesktop) return const SizedBox.shrink();

    return Container(
      height: preferredSize.height,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: WindowCaption(
        brightness: Theme.of(context).brightness,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(32);
}

/// A wrapper widget that adds a custom title bar on desktop platforms.
class DesktopWindowWrapper extends StatelessWidget {
  final Widget child;

  const DesktopWindowWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!GetPlatform.isDesktop) return child;

    return Column(
      children: [
        const CustomTitleBar(),
        Expanded(child: child),
      ],
    );
  }
}
