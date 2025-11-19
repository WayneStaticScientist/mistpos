import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/widgets/layouts/payments_cards.dart';
import 'package:mistpos/screens/gateways/paynow/screen_web_subscription.dart';
import 'package:mistpos/screens/gateways/paynow/screen_mobile_subscription.dart';

class ScreenSubscriptionPayment extends StatefulWidget {
  final String title;
  final String subKey;
  final double amount;
  const ScreenSubscriptionPayment({
    super.key,
    required this.subKey,
    required this.title,
    required this.amount,
  });

  @override
  State<ScreenSubscriptionPayment> createState() =>
      _ScreenSubscriptionPaymentState();
}

class _ScreenSubscriptionPaymentState extends State<ScreenSubscriptionPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: [
          "Payment Methods".text(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(color: AppTheme.surface(context)),
          "Mobile Money".text(),
          Wrap(
            children: [
              MistPaymentCards(
                label: "Ecocash",
                ontTap: () => _mobilePayment('ecocash'),
                color: Colors.blue,
              ),
              MistPaymentCards(
                label: "Innbucks",
                ontTap: () => _webPayment("Innbucks"),
                color: Colors.purple,
              ),
              MistPaymentCards(
                label: "OneMoney",
                ontTap: () => _mobilePayment('onemoney'),
                color: Colors.orangeAccent,
              ),
              MistPaymentCards(
                label: "OMari",
                ontTap: () => _webPayment("OMari"),
                color: Colors.green,
              ),
            ],
          ),
          Divider(color: AppTheme.surface(context)),
          "Credit or debit cards".text(),
          Wrap(
            children: [
              MistPaymentCards(
                label: "ZimSwitch",
                ontTap: () => _webPayment("ZimSwitch"),
                color: Colors.yellowAccent,
              ),
              MistPaymentCards(
                label: "Visa",
                ontTap: () => _webPayment("Visa"),
                color: Colors.deepPurpleAccent,
              ),
              MistPaymentCards(
                label: "MasterCard",
                ontTap: () => _webPayment("MasterCard"),
                color: Colors.red,
              ),
            ],
          ),
        ].column(),
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  void _webPayment(String s) {
    Get.off(
      () => ScreenWebSubscription(
        mobilePaymentInfo: s,
        title: widget.title,
        subKey: widget.subKey,
        amount: widget.amount,
      ),
    );
  }

  void _mobilePayment(String s) {
    Get.off(
      () => ScreenMobileSubscription(
        mobilePaymentInfo: s,
        title: widget.title,
        subKey: widget.subKey,
        amount: widget.amount,
      ),
    );
  }
}
