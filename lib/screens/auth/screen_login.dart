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
import 'package:mistpos/widgets/layouts/auth_layout_wrapper.dart';

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
      body: AuthLayoutWrapper(
        child: Form(
          key: _formKey,
          child: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Get.theme.colorScheme.primary,
              child: const Iconify(Bx.user, size: 40, color: Colors.white),
            ),
            16.gapHeight,
            "Welcome Back".text().styled(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
            8.gapHeight,
            "Please login to your account".text().styled(
                  color: Colors.grey,
                  fontSize: 14,
                ),
            32.gapHeight,
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
                icon: const Iconify(Bx.log_in, color: Colors.white),
              ),
            ),
            24.gapHeight,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: "Don't have an account? Sign up"
                  .text(textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500))
                  .onTap(() {
                Get.off(() => const ScreenCreateAccount());
              }),
            ),
            16.gapHeight,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: "Forgot Password?"
                  .text(textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))
                  .onTap(() {
                Net.launchForgotPassword();
              }),
            ),
            24.gapHeight,
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: "Back to Splash"
                  .text(textAlign: TextAlign.center, style: TextStyle(color: Get.theme.colorScheme.primary))
                  .onTap(() {
                Get.back();
              }),
            ),
          ].column(),
        ),
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    _userController.loginUser(_emailController.text, _passwordController.text);
  }
}
