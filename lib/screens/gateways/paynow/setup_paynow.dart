import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/screens/gateways/paynow/register_paynow.dart';
import 'package:mistpos/screens/gateways/paynow/screen_assign_keys_paynow.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenSetupPaynow extends StatefulWidget {
  const ScreenSetupPaynow({super.key});

  @override
  State<ScreenSetupPaynow> createState() => _ScreenSetupPaynowState();
}

class _ScreenSetupPaynowState extends State<ScreenSetupPaynow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup Paynow")),
      body: SingleChildScrollView(
        child: [
          "Do you have Paynow Keys ".text(),
          12.gapHeight,
          MistFormButton(
            label: "Assign Keys",
            fillColor: Get.theme.colorScheme.secondary,
            onTap: () => Get.to(() => ScreenAssignKeysPaynow()),
          ),
          24.gapColumn,
          "New to Paynow integration steps?".text(),
          12.gapColumn,
          MistFormButton(
            label: "Register Account",
            onTap: () => Get.off(() => ScreenRegisterPaynow()),
          ),
          24.gapColumn,
        ].column(),
      ).center(),
    );
  }
}
