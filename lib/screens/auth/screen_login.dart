import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/auth/screen_create_account.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: [
            CircleAvatar(
              radius: 45,
              child: Iconify(Bx.user, size: 34, color: Colors.white),
            ),
            28.gapHeight,
            MistFormInput(
              label: 'Email Address',
              controller: _emailController,
              validateString: "Please enter a valid email address",
              icon: Iconify(Bx.user, color: Get.theme.colorScheme.primary),
            ),
            18.gapHeight,
            MistFormInput(
              label: 'Password',
              isPasswordField: true,
              controller: _passwordController,
              validateString: "Please enter a valid password",
              icon: Iconify(Bx.key, color: Get.theme.colorScheme.primary),
            ),
            32.gapHeight,

            Obx(
              () => MistFormButton(
                label: 'Login',
                onTap: _login,
                isLoading: _userController.loading.value,
                icon: Iconify(Bx.log_in, color: Colors.white),
              ),
            ),
            18.gapHeight,
            "Don't have an account ? ".text(textAlign: TextAlign.center).onTap(
              () {
                Get.to(() => ScreenCreateAccount());
              },
            ),
            18.gapHeight,
            "Forgot Password ? ".text(textAlign: TextAlign.center).onTap(() {
              Net.launchForgotPassword();
            }),
          ].column(),
        ).constrained(maxWidth: 800).center().padding(EdgeInsets.all(14)),
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    _userController.loginUser(_emailController.text, _passwordController.text);
  }
}
