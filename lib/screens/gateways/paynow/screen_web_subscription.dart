import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/gateways/paynow/screen_web_hook_siubscription.dart';

class ScreenWebSubscription extends StatefulWidget {
  final String mobilePaymentInfo;
  final String title;
  final String subKey;
  final double amount;
  const ScreenWebSubscription({
    super.key,
    required this.mobilePaymentInfo,
    required this.title,
    required this.subKey,
    required this.amount,
  });

  @override
  State<ScreenWebSubscription> createState() => _ScreenWebSubscriptionState();
}

class _ScreenWebSubscriptionState extends State<ScreenWebSubscription> {
  final _key = GlobalKey<FormState>();
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
            "Total Price Payable".text(),
            "\$${widget.amount.toStringAsFixed(2)}".text(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            24.gapHeight,
            Obx(
              () => MistFormButton(
                label: "Pay",
                onTap: _pay,
                isLoading: _invController.webProcessingPayment.value,
              ),
            ),
          ].column(),
        ),
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  _pay() async {
    if (_userController.user.value == null) {
      Toaster.showError("User registration needed");
      return;
    }
    if (!_key.currentState!.validate()) return;
    final response = await _invController.payWeb(
      widget.mobilePaymentInfo,
      widget.amount,
      widget.subKey,
    );
    if (response.returnUrl == null ||
        response.redirectUrl == null ||
        response.pollUrl == null) {
      return;
    }
    // if (response.endsWith("//")) {
    //   response = response.substring(0, response.length - 2);
    // }
    Get.off(
      () => ScreenWebHookSubscription(
        amount: widget.amount,
        subKey: widget.subKey,
        pollUrl: response.pollUrl!,
        returnUrl: response.returnUrl!,
        webHookUrl: response.redirectUrl!,
        paymentInfo: widget.mobilePaymentInfo,
      ),
    );
  }
}
