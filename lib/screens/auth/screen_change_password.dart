import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';

class ScreenChangePassword extends StatefulWidget {
  const ScreenChangePassword({super.key});

  @override
  State<ScreenChangePassword> createState() => _ScreenChangePasswordState();
}

class _ScreenChangePasswordState extends State<ScreenChangePassword> {
  final _userController = Get.find<UserController>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: [
            'Change Password'
                .text(style: TextStyle(fontWeight: FontWeight.bold))
                .padding(EdgeInsets.all(14)),
            MistFormInput(
              icon: Iconify(Bx.lock, color: AppTheme.color(context), size: 18),
              label: "Old Password",
              underLineColor: AppTheme.color(context),
              controller: _oldPasswordController,
              validateString: "Old password field is required",
            ),
            18.gapHeight,
            MistFormInput(
              controller: _newPasswordController,
              validateString: "Please enter a valid password",
              validLength: 5,
              isPasswordField: true,
              icon: Iconify(
                Bx.lock_open,
                color: AppTheme.color(context),
                size: 18,
              ),
              label: "New Password",
              underLineColor: AppTheme.color(context),
            ),
            32.gapHeight,
            MistFormButton(
              isLoading: _userController.changingPassword.value,
              label: "Change Password",
              icon: Iconify(Bx.log_in_circle, color: Colors.white),
              onTap: _changePassword,
            ),
          ].column(),
        ).center().padding(EdgeInsets.all(14)),
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await _userController.changePassword(
      _oldPasswordController.text,
      _newPasswordController.text,
    );
    if (success) {
      setState(() {
        _oldPasswordController.clear();
        _newPasswordController.clear();
      });
    }
  }
}
