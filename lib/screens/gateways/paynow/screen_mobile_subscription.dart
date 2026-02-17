import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/controllers/inventory_controller.dart';

class ScreenMobileSubscription extends StatefulWidget {
  final String mobilePaymentInfo;
  final String title;
  final String subKey;
  final double amount;
  const ScreenMobileSubscription({
    super.key,
    required this.title,
    required this.subKey,
    required this.amount,
    required this.mobilePaymentInfo,
  });

  @override
  State<ScreenMobileSubscription> createState() =>
      _ScreenMobileSubscriptionState();
}

class _ScreenMobileSubscriptionState extends State<ScreenMobileSubscription> {
  final _key = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _userController = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: [
            widget.mobilePaymentInfo.toUpperCase().text(
              style: TextStyle(fontSize: 32),
            ),
            "Subscribe for ${widget.title}".text(),
            "\$${widget.amount.toStringAsFixed(2)}".text(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            MistFormInput(
              controller: _phoneController,
              label: "Phone Number",
              keyboardType: TextInputType.phone,
              validateString: "Phone number is required",
              underLineColor: Colors.grey,
            ).padding(EdgeInsets.all(14)),
            12.gapHeight,

            Obx(
              () => MistFormButton(
                label: "Subscribe",
                onTap: _pay,
                isLoading: _invController.mobilePaymentProcessing.value,
              ),
            ),
          ].column(),
        ),
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  Future<void> _pay() async {
    if (_userController.user.value == null) {
      Toaster.showError("User registration needed");
      return;
    }
    if (!_key.currentState!.validate()) return;
    String phone = _phoneController.text.trim();
    if (phone.length < 9) {
      Toaster.showError("invalid phone +number");
      return;
    }
    final response = await _invController.subscribeMobile(
      method: widget.mobilePaymentInfo,
      amount: widget.amount,
      phoneNumber: phone,
      subKey: widget.subKey,
    );
    if (!response) {
      return;
    }
    Get.back();
    Toaster.showSuccess("Subscription successful");
  }
}
