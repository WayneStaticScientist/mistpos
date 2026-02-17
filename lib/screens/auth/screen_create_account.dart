import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenCreateAccount extends StatefulWidget {
  const ScreenCreateAccount({super.key});

  @override
  State<ScreenCreateAccount> createState() => _ScreenCreateAccountState();
}

class _ScreenCreateAccountState extends State<ScreenCreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userController = Get.find<UserController>();
  final _countryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
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
              label: 'Full Name',
              controller: _fullNameController,
              icon: Iconify(Bx.user, color: Get.theme.colorScheme.primary),
              validateString: "Please enter your full name",
            ),
            18.gapHeight,
            MistFormInput(
              label: 'Email Address',
              controller: _emailController,
              icon: Iconify(Bx.envelope, color: Get.theme.colorScheme.primary),
              validateString: "Please enter a valid email address",
              validLength: 5,
            ),
            18.gapHeight,
            MistFormInput(
              label: 'Business Name',
              controller: _businessNameController,
              icon: Iconify(Bx.wallet, color: Get.theme.colorScheme.primary),
              validateString: "Please enter a business name",
            ),
            18.gapHeight,
            MistFormInput(
              label: 'Country',
              controller: _countryController,
              enabled: false,
              icon: Iconify(Bx.flag, color: Get.theme.colorScheme.primary),
              validateString: "Please select a country",
            ).onTap(_selectCountry),
            18.gapHeight,
            MistFormInput(
              label: 'Password',
              controller: _passwordController,
              validateString: "Please enter a valid password",
              validLength: 5,
              isPasswordField: true,
              icon: Iconify(Bx.key, color: Get.theme.colorScheme.primary),
            ),
            32.gapHeight,

            32.gapHeight,
            Obx(
              () => MistFormButton(
                isLoading: _userController.loading.value,
                label: 'Create Account',
                icon: Iconify(Bx.log_in, color: Colors.white),
                onTap: _createAccount,
              ),
            ),
          ].column(),
        ).constrained(maxWidth: 800).center().padding(EdgeInsets.all(14)),
      ),
    );
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _countryController.text = country.name;
        });
      },
    );
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    if (_fullNameController.text.trim().split(" ").length < 2) {
      Toaster.showError("Please enter your full name e.g John Doe");
      return;
    }
    final user = User(
      till: 1,
      role: 'admin',
      companies: [],
      pinnedInput: false,
      permissions: [],
      subscriptions: [],
      email: _emailController.text,
      country: _countryController.text,
      fullName: _fullNameController.text,
      password: _passwordController.text,
      company: _businessNameController.text,
    );
    _userController.registerUser(user);
  }
}
