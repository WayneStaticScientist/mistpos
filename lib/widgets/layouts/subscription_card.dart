import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/utils/date_utils.dart';

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
    final Color primaryColor =
        fillColor ??
        (selectedPlan == plan
            ? Colors.green
            : Get.theme.colorScheme.primary); // Deep Purple
    final Color secondaryColor = fillColor ?? Color(0xFF4527A0); // Indigo
    final Color accentColor =
        Get.theme.colorScheme.secondary; // Amber for the CTA button
    // Determine if this card represents the current plan
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: currentPlan
            ? BorderSide(color: Colors.green, width: 5)
            : BorderSide.none,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(28.0),
            child:
                [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  12.gapHeight,
                  [
                        Text(
                          // Display price clearly
                          '\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          '/$billingCycle',
                          style: TextStyle(
                            color: Colors.white.withAlpha(204),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ).padding(EdgeInsets.only(bottom: 10.0)),
                      ]
                      .row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      )
                      .visibleIfNot(currentPlan),
                  if (remainingTime != null && currentPlan)
                    Text(
                      'Valid Until: ${remainingTime!.day}/${remainingTime!.month}/${remainingTime!.year}',
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ].column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
          ),

          // 2. Features List
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: primaryColor, size: 20),
                      const SizedBox(width: 12),
                      feature.text().expanded1, // Takes up remaining space
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          Divider(
            height: 0,
            thickness: 1,
            indent: 24,
            endIndent: 24,
            color: Colors.grey.withAlpha(100),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            child: ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                minimumSize: const Size(
                  double.infinity,
                  56,
                ), // Full width and good height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: accentColor.withAlpha(128),
              ),
              child: Text(
                buttonLabel ?? 'Subscribe Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ).visibleIfNot(currentPlan),
          12.gapHeight.visibleIf(currentPlan),
          if (currentPlan && remainingTime != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  remainingTime!.difference(DateTime.now()).inDays < 0
                      ? 'Your current plan has expired.'
                      : MistDateUtils.getDifferenxeInApproximate(
                          remainingTime!,
                        ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: remainingTime!.difference(DateTime.now()).inDays > 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    ).constrained(maxWidth: 340);
  }
}
