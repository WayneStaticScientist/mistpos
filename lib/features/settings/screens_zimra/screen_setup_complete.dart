import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:mistpos/core/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';

class ScreenZimraSetupComplete extends StatelessWidget {
  final dynamic company;
  const ScreenZimraSetupComplete({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final deviceId = company.zimraDeviceId?.toString() ?? "N/A";
    final serialNo = company.zimraDeviceSerialNo ?? "N/A";
    final isTest = company.zimraIsTest ?? true;
    final validTill = company.zimraCertificateValidTill != null
        ? DateFormat("yyyy-MM-dd HH:mm").format(company.zimraCertificateValidTill)
        : "N/A";

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon with elegant animations
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F9B0F).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF007A33),
                      size: 56,
                    ),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.elasticOut)
                      .fadeIn(duration: 300.ms),
                  24.gapHeight,

                  // Title & Subtitle
                  "Setup Complete!"
                      .text(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      )
                      .animate(delay: 200.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
                  12.gapHeight,
                  "Your point-of-sale is successfully connected and integrated with ZIMRA."
                      .text(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate(delay: 300.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
                  32.gapHeight,

                  // Configuration details card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(context, "Device ID", deviceId, isDark),
                        const Divider(height: 24),
                        _buildDetailRow(context, "Serial Number", serialNo, isDark),
                        const Divider(height: 24),
                        _buildDetailRow(
                          context,
                          "Environment",
                          isTest ? "Sandbox (Testing)" : "Live (Production)",
                          isDark,
                          valueColor: isTest ? Colors.amber.shade700 : Colors.green.shade700,
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(context, "Valid Until", validTill, isDark),
                      ],
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
                  40.gapHeight,

                  // Done Button
                  SizedBox(
                    width: double.infinity,
                    child: MistFormButton(
                      label: "Finish & Return",
                      onTap: () {
                        Get.back(); // Goes back to screen_zimra_services
                      },
                    ),
                  )
                      .animate(delay: 500.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        label.text(
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),
        value.text(
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }
}
