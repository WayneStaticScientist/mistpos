import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/screens/basic/screen_main.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: [
          CircleAvatar(
            radius: 45,
            child: Iconify(Bx.user, size: 34, color: Colors.white),
          ),
          28.gapHeight,
          MistFormInput(
            label: 'Email Address',
            icon: Iconify(Bx.user, color: Get.theme.colorScheme.primary),
          ),
          18.gapHeight,
          MistFormInput(
            label: 'Password',
            isPasswordField: true,
            icon: Iconify(Bx.key, color: Get.theme.colorScheme.primary),
          ),
          32.gapHeight,
          MistFormButton(
            label: 'Login',
            onTap: () => Get.to(() => ScreenMain()),
            icon: Iconify(Bx.log_in, color: Colors.white),
          ),
        ].column(),
      ).center().padding(EdgeInsets.all(14)),
    );
  }
}
