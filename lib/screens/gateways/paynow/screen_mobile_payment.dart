import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenMobilePayment extends StatefulWidget {
  final String mobilePaymentInfo;
  const ScreenMobilePayment({super.key, required this.mobilePaymentInfo});

  @override
  State<ScreenMobilePayment> createState() => _ScreenMobilePaymentState();
}

class _ScreenMobilePaymentState extends State<ScreenMobilePayment> {
  final _key = GlobalKey<FormState>();
  final _printer = Get.find<DevicesController>();
  final _phoneController = TextEditingController();
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
            "0777 777 777 example format".text(
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Obx(
              () => MistFormInput(
                underLineColor: Colors.white,
                enabled: !_itemController.mobilePaymentProcessing.value,
                controller: _phoneController,
                validateString: "invalid phone number",
                label: "${widget.mobilePaymentInfo.toUpperCase()} Number ",
              ).padding(EdgeInsets.symmetric(horizontal: 14)),
            ),
            24.gapHeight,
            Obx(
              () => MistFormButton(
                label: "Pay",
                onTap: _pay,
                isLoading: _itemController.mobilePaymentProcessing.value,
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
    double amount = _itemController.totalPrice.value;
    String phone = _phoneController.text.trim();
    if (phone.length < 9) {
      Toaster.showError("invalid phone +number");
      return;
    }
    final response = await _itemController.payMobile(
      method: widget.mobilePaymentInfo,
      phoneNumber: phone,
    );
    if (!response) {
      return;
    }
    _itemController.addReceitFromItemModel(
      amount,
      widget.mobilePaymentInfo,
      allowOfflinePurchase:
          _userController.user.value != null &&
          _userController.user.value!.allowOfflinePurchase,
      user: _userController.user.value!,
      printReceits: _printer.isPrinterConnected(),
    );
    Get.back();
    Toaster.showSuccess("payment delivered");
  }
}
