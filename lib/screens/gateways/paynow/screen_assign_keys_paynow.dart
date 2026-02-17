import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenAssignKeysPaynow extends StatefulWidget {
  const ScreenAssignKeysPaynow({super.key});

  @override
  State<ScreenAssignKeysPaynow> createState() => _ScreenAssignKeysPaynowState();
}

class _ScreenAssignKeysPaynowState extends State<ScreenAssignKeysPaynow> {
  final _formKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _integrationIdController = TextEditingController();
  final _integrationKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assign Keys")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: [
            CircleAvatar(
              radius: 45,
              child: Iconify(Bx.key, size: 34, color: Colors.white),
            ),
            28.gapHeight,
            MistFormInput(
              label: 'Integration ID',
              controller: _integrationIdController,
              validateString: "Please enter a valid  integration ID",
              icon: Iconify(Bx.user, color: Get.theme.colorScheme.primary),
            ),
            18.gapHeight,
            MistFormInput(
              label: 'Integration Key',
              isPasswordField: true,
              controller: _integrationKeyController,
              validateString: "Integration Key is required",
              icon: Iconify(Bx.key, color: Get.theme.colorScheme.primary),
            ),
            32.gapHeight,
            Obx(
              () => MistFormButton(
                isLoading: _adminController.settingUpKeys.value,
                label: 'Setup keys',
                onTap: _setupKeys,
                icon: Iconify(Bx.log_in, color: Colors.white),
              ),
            ),
          ].column(),
        ).constrained(maxWidth: 800).center().padding(EdgeInsets.all(14)),
      ),
    );
  }

  Future<void> _setupKeys() async {
    if (!_formKey.currentState!.validate()) return;
    User? response = await _adminController.setupPaynowKeys(
      integrationId: _integrationIdController.text,
      integrationKey: _integrationKeyController.text,
    );
    if (response != null) {
      _userController.user.value = response;
      User.saveToStorage(response);
      if (mounted) Get.back();
      Toaster.showSuccess("Keys added");
    }
  }
}
