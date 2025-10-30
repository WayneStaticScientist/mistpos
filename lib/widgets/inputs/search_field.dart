import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class MistSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  const MistSearchField({super.key, this.controller, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hint: (label ?? "Search").text(style: TextStyle(color: Colors.grey)),
        fillColor: AppTheme.surface,
        filled: true,
        prefixIcon: SizedBox(
          height: 14,
          width: 14,
          child: Iconify(Bx.search, color: Colors.grey).center(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
