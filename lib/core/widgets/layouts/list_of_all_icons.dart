import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/fa.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/zondicons.dart';

List icons = [
  ...Fa.iconsList,
  ...Zondicons.iconsList,
  ...Bx.iconsList,
  ...Carbon.iconsList,
];

class MistListOfAllIcons extends StatelessWidget {
  final Function(String data) ontap;
  const MistListOfAllIcons({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () => ontap(icons[index]),
        title: "Icon #$index".text(),
        leading: CircleAvatar(
          child: Iconify(icons[index], color: Colors.white),
        ),
      ),
    );
  }
}

Future<dynamic> pickListIcon() async {
  return await Get.dialog(
    AlertDialog(
      title: "Select Icon".text(),
      content: MistListOfAllIcons(ontap: (data) => Get.back(result: data)),
      actions: ["Close".text().textButton(onPressed: () => Get.back())],
    ),
  );
}
