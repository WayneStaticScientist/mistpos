import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenChangeEmployee extends StatefulWidget {
  final User user;
  const ScreenChangeEmployee({super.key, required this.user});

  @override
  State<ScreenChangeEmployee> createState() => _ScreenChangeEmployeeState();
}

class _ScreenChangeEmployeeState extends State<ScreenChangeEmployee> {
  final _controller = TextEditingController();
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _userController.loading.value
            ? Center(
                child: [MistLoader1(), 18.gapHeight, "Verifying User...".text()]
                    .column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
              )
            : Center(
                child:
                    [
                          Text(
                            "Enter pin",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          "Logging for ${widget.user.fullName}".text(),
                          18.gapHeight,
                          Pinput(
                            onCompleted: (pin) => _userController.loginUser(
                              widget.user.email,
                              pin,
                            ),
                          ).visibleIf(widget.user.pinnedInput),
                          if (!widget.user.pinnedInput) ...[
                            MistFormInput(
                              label: "Enter password",
                              isPasswordField: true,
                              controller: _controller,
                            ),
                            18.gapHeight,
                            MistFormButton(
                              label: "Switch",
                              icon: Icon(Icons.login),
                              onTap: _switch,
                            ),
                          ],
                        ]
                        .column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                        .padding(EdgeInsets.all(12)),
              ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      ),
    );
  }

  void _switch() {
    if (_controller.text.trim().isEmpty) {
      Toaster.showError("password is required");
      return;
    }
    _userController.loginUser(widget.user.email, _controller.text);
  }
}
