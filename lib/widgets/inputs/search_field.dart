import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class MistSearchField extends StatelessWidget {
  final TextEditingController? controller;
  const MistSearchField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hint: "Search Menu".text(style: TextStyle(color: Colors.grey)),
        fillColor: Get.isDarkMode ? Colors.black : Colors.white,
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
