import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/screens/gateways/paynow/screen_webhook_payment_url.dart';

class ScreenWebBasedPaymentPaynow extends StatefulWidget {
  final String mobilePaymentInfo;

  const ScreenWebBasedPaymentPaynow({
    super.key,
    required this.mobilePaymentInfo,
  });

  @override
  State<ScreenWebBasedPaymentPaynow> createState() =>
      _ScreenWebBasedPaymentPaynowState();
}

class _ScreenWebBasedPaymentPaynowState
    extends State<ScreenWebBasedPaymentPaynow> {
  final _key = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();
  final _itemController = Get.find<ItemsController>();
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
            CurrenceConverter.getCurrenceFloatInStrings(
              _itemController.totalPrice.value,
              _userController.user.value?.baseCurrence ?? '',
            ).text(style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            24.gapHeight,
            Obx(
              () => MistFormButton(
                label: "Pay",
                onTap: _pay,
                isLoading: _itemController.webProcessingPayment.value,
              ),
            ),
          ].column(),
        ),
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  Future<void> _pay() async {
    final amount = _itemController.totalPrice.value;
    if (_userController.user.value == null) {
      Toaster.showError("User registration needed");
      return;
    }
    if (!_key.currentState!.validate()) return;
    final response = await _itemController.payWeb(widget.mobilePaymentInfo);
    if (response.returnUrl == null ||
        response.redirectUrl == null ||
        response.pollUrl == null) {
      return;
    }
    // if (response.endsWith("//")) {
    //   response = response.substring(0, response.length - 2);
    // }
    Get.off(
      () => ScreenWebhookPaymentUrl(
        amount: amount,
        paymentInfo: widget.mobilePaymentInfo,
        pollUrl: response.pollUrl!,
        returnUrl: response.returnUrl!,
        webHookUrl: response.redirectUrl!,
      ),
    );
  }
}
