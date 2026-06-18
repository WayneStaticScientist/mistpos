import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/core/widgets/layouts/centered_error.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/layouts/subscription_card.dart';
import 'package:mistpos/features/settings/screens_gateways/paynow/screen_subscription_payment.dart';

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
      _controller.getSubscriptionPricing();
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
    if (_controller.loadingSubscriptionPricing.value) {
      return MistLoader1().center();
    }
    final plans = _controller.subscriptionPlans;
    final currentPlan = _controller.company.value!.subscriptionType.type;

    return Container(
      color: Color(0xFF161622), // Dark background matching the image
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modern Hero Header
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 40,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  "Upgrade Your Experience".text(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  8.gapHeight,
                  "Choose the best plan for your needs.".text(
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  24.gapHeight,
                  if (currentPlan.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(30)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars, color: Colors.amber, size: 16),
                          8.gapWidth,
                          "Current Plan: ${currentPlan.toUpperCase()}".text(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Plans List
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () =>
                        SubscriptionCard(
                          title: 'Trial Plan',
                          remainingTime: _controller
                              .company
                              .value!
                              .subscriptionType
                              .validUntil,
                          selectedPlan:
                              _controller.company.value!.subscriptionType.type,
                          plan: MistSubscriptionUtils.trialPlan,
                          price: 0.0,
                          buttonLabel: _controller.loadingFreeTrial.value
                              ? "Loading..."
                              : "Start 30-Day Trial",
                          features: [
                            "30-Day Pro Access",
                            "All Pro Features",
                            "Try Risk-Free",
                            "Ends in 30 Days",
                          ],
                          onSubscribe: _startFreeTrial,
                        ).visibleIfNot(
                          _controller
                                  .company
                                  .value!
                                  .subscriptionType
                                  .hasExhaustedCredits &&
                              !(_controller
                                      .company
                                      .value!
                                      .subscriptionType
                                      .type ==
                                  MistSubscriptionUtils.trialPlan),
                        ),
                  ),
                  Obx(
                    () => SubscriptionCard(
                      title: 'Free Plan',
                      onSubscribe: _freePlan,
                      selectedPlan:
                          _controller.company.value!.subscriptionType.type,
                      plan: MistSubscriptionUtils.freePlan,
                      price: 0.0,
                      buttonLabel: "Get Started",
                      features: [
                        "1 Project",
                        "500 MB Storage",
                        "Basic Support",
                        "Access 10 Templates",
                      ],
                    ),
                  ),
                  ...plans.map((p) {
                    if (p['id'] == 'free') return SizedBox();

                    List<String> features = [];
                   if (p['features'] != null && p['features'] is List) {
                      features = (p['features'] as List).map((e) => e.toString()).toList();
                   }

                    return Obx(
                      () => SubscriptionCard(
                        title: p['name'],
                        remainingTime: _controller
                            .company
                            .value!
                            .subscriptionType
                            .validUntil,
                        selectedPlan:
                            _controller.company.value!.subscriptionType.type,
                        plan: p['id'],
                        features: features,
                        price: double.tryParse(p['price'].toString()) ?? 0.0,
                        onSubscribe: () => _subscribe(
                          p['id'],
                          double.tryParse(p['price'].toString()) ?? 0.0,
                          p['name'],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _subscribe(String basicPlan, double d, String s) {
    int durationMonths = 1;
    final currentPlan = _controller.company.value!.subscriptionType.type;
    final isUpgrade =
        currentPlan != MistSubscriptionUtils.freePlan &&
        currentPlan != MistSubscriptionUtils.trialPlan &&
        currentPlan != basicPlan;

    Get.defaultDialog(
      title: "Subscribe",
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isUpgrade)
                "Warning: You are upgrading your plan to a different tier. Ensure you understand that you might lose some remaining time if not accounted for."
                    .text(style: TextStyle(color: Colors.red, fontSize: 12)),
              if (isUpgrade) 12.gapHeight,
              "Subscribing to $s plan for \$$d per month".text(),
              12.gapHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Duration:".text(),
                  8.gapWidth,
                  DropdownButton<int>(
                    value: durationMonths,
                    items: [1, 3, 6, 12]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: "$e Month${e > 1 ? 's' : ''}".text(),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        durationMonths = v ?? 1;
                      });
                    },
                  ),
                ],
              ),
              12.gapHeight,
              "Total: \$${(d * durationMonths).toStringAsFixed(2)}".text(
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          );
        },
      ),
      onConfirm: () {
        Get.off(
          () => ScreenSubscriptionPayment(
            subKey: basicPlan,
            title: s,
            amount: d * durationMonths,
            durationMonths: durationMonths,
          ),
        );
      },
      textConfirm: "Proceed to Payment",
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
