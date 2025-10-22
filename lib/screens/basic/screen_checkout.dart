import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_card_payment.dart';
import 'package:mistpos/screens/basic/screen_cash_payment.dart';
import 'package:mistpos/utils/currence_converter.dart';

class ScreenCheckout extends StatefulWidget {
  const ScreenCheckout({super.key});

  @override
  State<ScreenCheckout> createState() => _ScreenCheckoutState();
}

class _ScreenCheckoutState extends State<ScreenCheckout> {
  final _itemsListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Checkout Items".text()),
      body: SingleChildScrollView(
        child: Obx(
          () =>
              [
                CurrenceConverter.getCurrenceFloatInStrings(
                  _itemsListController.totalPrice.value,
                ).text(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                "Total Amount Due".text(textAlign: TextAlign.center),
                18.gapHeight,
                "Cash"
                    .text(textAlign: TextAlign.center)
                    .elevatedIconButton(
                      onPressed: _cashPaymenthandler,
                      icon: Iconify(Bx.money, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 65),
                        backgroundColor: Get.theme.colorScheme.primary,
                        foregroundColor: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                18.gapHeight,
                "Card"
                    .text(textAlign: TextAlign.center)
                    .elevatedIconButton(
                      onPressed: _cardPaymentHandler,
                      icon: Iconify(Bx.card, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 65),
                        backgroundColor: Get.theme.colorScheme.primary,
                        foregroundColor: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
              ].column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
        ),
      ).center(),
    );
  }

  void _cashPaymenthandler() {
    Get.off(() => ScreenCashPayment());
  }

  void _cardPaymentHandler() {
    Get.off(() => ScreenCardPayment());
  }
}
