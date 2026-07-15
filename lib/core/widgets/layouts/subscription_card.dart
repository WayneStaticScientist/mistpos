import 'package:exui/exui.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  // Mock data for the card
  final String title;
  final double price;
  final String plan;
  final Color? fillColor;
  final String selectedPlan;
  final String? buttonLabel;
  final List<String> features;
  final DateTime? remainingTime;
  final VoidCallback? onSubscribe;
  final String billingCycle = 'mo';
  const SubscriptionCard({
    super.key,
    this.plan = '',
    this.fillColor,
    this.onSubscribe,
    this.buttonLabel,
    this.remainingTime,
    required this.title,
    required this.price,
    required this.features,
    required this.selectedPlan,
  });
  @override
  Widget build(BuildContext context) {
    final currentPlan = plan == selectedPlan;
    // Determine accent color based on plan type roughly mimicking the image
    Color accentColor = fillColor ?? Colors.grey;
    if (plan.toLowerCase() == 'basic') accentColor = Colors.cyanAccent;
    if (plan.toLowerCase() == 'pro') accentColor = Colors.purpleAccent;
    if (plan.toLowerCase() == 'enterprise') accentColor = Colors.amber;
    if (plan.toLowerCase() == 'trial' || plan.toLowerCase() == 'trialplan')
      accentColor = Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10), // Glass effect background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withAlpha(currentPlan ? 150 : 50),
          width: currentPlan ? 2 : 1,
        ),
        boxShadow: [
          if (currentPlan)
            BoxShadow(
              color: accentColor.withAlpha(30),
              blurRadius: 20,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (plan.toLowerCase() == 'pro')
            Positioned(
              top: -12,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withAlpha(100),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  "MOST POPULAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TOP SECTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT (Icon and Title)
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accentColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: accentColor.withAlpha(100),
                              ),
                            ),
                            child: Icon(
                              plan.toLowerCase() == 'enterprise'
                                  ? Icons.business_center
                                  : plan.toLowerCase() == 'pro'
                                  ? Icons.workspace_premium
                                  : plan.toLowerCase() == 'basic'
                                  ? Icons.account_tree
                                  : plan.toLowerCase() == 'trial'
                                  ? Icons.verified_user
                                  : Icons.layers,
                              color: accentColor,
                              size: 28,
                            ),
                          ),
                          12.gapHeight,
                          Text(
                            title.toUpperCase(),
                            style: TextStyle(
                              color: currentPlan
                                  ? Colors.white
                                  : Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // RIGHT (Price & Button)
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              if (price > 0)
                                Text(
                                  ' / mo.',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).padding(const EdgeInsets.only(bottom: 4)),
                            ],
                          ),
                          16.gapHeight,
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: onSubscribe,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentPlan
                                    ? Colors.white.withAlpha(30)
                                    : accentColor,
                                foregroundColor: currentPlan
                                    ? Colors.white
                                    : Colors.black87,
                                elevation: currentPlan ? 0 : 4,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: currentPlan
                                      ? BorderSide(color: Colors.white30)
                                      : BorderSide.none,
                                ),
                              ),
                              child: Text(
                                currentPlan
                                    ? "Extend Plan"
                                    : (buttonLabel ?? "Subscribe"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          if (currentPlan && remainingTime != null) ...[
                            8.gapHeight,
                            Text(
                              "Ends: ${remainingTime!.day}/${remainingTime!.month}/${remainingTime!.year}",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                20.gapHeight,
                Container(height: 1, color: Colors.white.withAlpha(30)),
                20.gapHeight,

                // BOTTOM SECTION (Features)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: features
                      .take(4)
                      .map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check, size: 16, color: accentColor),
                              12.gapWidth,
                              Expanded(
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
