import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/widgets/layouts/centered_error.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/layouts/subscription_card.dart';
import 'package:mistpos/screens/gateways/paynow/screen_subscription_payment.dart';

class ScreenSubscription extends StatefulWidget {
  const ScreenSubscription({super.key});

  @override
  State<ScreenSubscription> createState() => _ScreenSubscriptionState();
}

class _ScreenSubscriptionState extends State<ScreenSubscription> {
  final _controller = Get.find<InventoryController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadCompany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
        backgroundColor: Get.theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (_controller.loadingCompany.value) {
          return MistLoader1().center();
        }
        if (_controller.companyError.value.isNotEmpty) {
          return CenteredError(errorMessage: _controller.companyError.value);
        }
        if (_controller.company.value == null) {
          return CenteredError(
            errorMessage: "There was an error loading company data.",
          );
        }
        return _buildList();
      }),
    );
  }

  Widget _buildList() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        alignment: WrapAlignment.center,
        children: [
          Obx(
            () =>
                SubscriptionCard(
                  title: 'Trial Plan',
                  remainingTime:
                      _controller.company.value!.subscriptionType.validUntil,
                  selectedPlan:
                      _controller.company.value!.subscriptionType.type,
                  plan: MistSubscriptionUtils.trialPlan,
                  price: 0.0,
                  fillColor: Colors.orange,
                  buttonLabel: _controller.loadingFreeTrial.value
                      ? "Loading..."
                      : "Start Free Trial",
                  features: ["All Features", "For 2 Weeks Only"],
                  onSubscribe: _startFreeTrial,
                ).visibleIfNot(
                  _controller
                          .company
                          .value!
                          .subscriptionType
                          .hasExhaustedCredits &&
                      !(_controller.company.value!.subscriptionType.type ==
                          MistSubscriptionUtils.trialPlan),
                ),
          ),
          24.gapHeight,
          Obx(
            () => SubscriptionCard(
              title: 'Free Plan',
              onSubscribe: _freePlan,
              selectedPlan: _controller.company.value!.subscriptionType.type,
              plan: MistSubscriptionUtils.freePlan,
              price: 0.0,
              features: ["Basic Features", "Limited Support", "Sales Reports"],
            ),
          ),
          24.gapHeight,
          Obx(
            () => SubscriptionCard(
              title: 'Basic Plan',
              remainingTime:
                  _controller.company.value!.subscriptionType.validUntil,
              selectedPlan: _controller.company.value!.subscriptionType.type,
              plan: MistSubscriptionUtils.basicPlan,
              features: [
                "Basic Features",
                "Full Support",
                "Sales Reports",
                "Manage Cashiers",
                "Add/Remove Manager s",
                "Manage Multiple Stores",
              ],
              onSubscribe: () => _subscribe(
                MistSubscriptionUtils.basicPlan,
                5.00,
                "Basic Plan",
              ),
              price: 5.00,
            ),
          ),
          24.gapHeight,
          Obx(
            () => SubscriptionCard(
              remainingTime:
                  _controller.company.value!.subscriptionType.validUntil,
              title: 'Pro Plan',
              price: 10.00,
              selectedPlan: _controller.company.value!.subscriptionType.type,
              plan: MistSubscriptionUtils.proPlan,
              features: [
                "Basic Features",
                "Full Support",
                "Sales Reports",
                "Manage Cashiers",
                "Add/Remove Managers",
                "Advanced Analytics",
                "Manage Multiple Stores",
                "Advanced Inventory Management",
              ],
              onSubscribe: () =>
                  _subscribe(MistSubscriptionUtils.proPlan, 10.00, "Pro Plan"),
            ),
          ),
          24.gapHeight,
          Obx(
            () => SubscriptionCard(
              title: 'Enterprise Plan',
              remainingTime:
                  _controller.company.value!.subscriptionType.validUntil,
              selectedPlan: _controller.company.value!.subscriptionType.type,
              plan: MistSubscriptionUtils.enterprisePlan,
              price: 15.00,
              features: [
                "Basic Features",
                "Full Support",
                "Sales Reports",
                "Manage Cashiers",
                "Add/Remove Managers",
                "Advanced Analytics",
                "Manage Multiple Stores",
                "Advanced Inventory Management",
                "Composite Items",
                "Productions",
              ],
              onSubscribe: () => _subscribe(
                MistSubscriptionUtils.enterprisePlan,
                15.00,
                "Enterprise Plan",
              ),
            ),
          ),
        ],
      ).padding(EdgeInsets.all(16)),
    );
  }

  void _subscribe(String basicPlan, double d, String s) {
    Get.defaultDialog(
      title: "Subscribe",
      middleText: "Subribing to $s plan for \$$d per month",
      onConfirm: () {
        Get.off(
          () =>
              ScreenSubscriptionPayment(subKey: basicPlan, title: s, amount: d),
        );
      },
      textConfirm: "OK",
      textCancel: "Cancel",
    );
  }

  void _startFreeTrial() {
    Get.defaultDialog(
      title: "Subscribe",
      middleText:
          "This will start your free trial period and you will have "
          "access to all features for 14 days. After that, you can choose a plan to continue using the service.",
      textConfirm: "OK",
      onConfirm: () {
        Get.back();
        _controller.registerFreeTrial();
      },
      textCancel: "Cancel",
    );
  }

  void _freePlan() {
    String planType = _controller.company.value!.subscriptionType.type;
    int daysLeft =
        _controller.company.value!.subscriptionType.validUntil
            ?.difference(DateTime.now())
            .inDays ??
        0;
    if (planType != MistSubscriptionUtils.trialPlan && daysLeft > 0) {
      Toaster.showError(
        "You can only switch to Free Plan after Period has overwhelmed.",
      );
      return;
    }
    Get.defaultDialog(
      title: "Free Plan",
      middleText:
          "This will switch you to the free plan. You will have "
          "access to basic features with limited support.",
      textConfirm: "OK",
      onConfirm: () {
        Get.back();
        _controller.registerFreePlan();
      },
      textCancel: "Cancel",
    );
  }
}
