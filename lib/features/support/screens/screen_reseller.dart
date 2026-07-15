import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/support/screens/screen_reseller_dashboard.dart';

class ScreenReseller extends StatefulWidget {
  const ScreenReseller({super.key});

  @override
  State<ScreenReseller> createState() => _ScreenResellerState();
}

class _ScreenResellerState extends State<ScreenReseller> {
  final _invController = Get.find<InventoryController>();
  final _reasonController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    setState(() => _submitting = true);
    try {
      final response = await Net.post(
        "/admin/reseller-requests",
        data: {"reason": _reasonController.text.trim()},
      );

      if (response.hasError) {
        Toaster.showError(response.response);
      } else {
        Toaster.showSuccess("Application submitted successfully!");
        if (response.body != null && response.body['company'] != null) {
          final updatedCompany = CompanyModel.fromJson(response.body['company']);
          _invController.company.value = updatedCompany;
          updatedCompany.saveToStorage();
        }
      }
    } catch (e) {
      Toaster.showError("An error occurred. Please try again.");
    } finally {
      setState(() => _submitting = false);
    }
  }

  void _showApplyDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.rocket_launch_rounded, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Apply for Reselling",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tell us a bit about how you plan to market and promote the MistPOS application to other merchants.",
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white.withOpacity(0.70) : Colors.black.withOpacity(0.54),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                maxLines: 4,
                style: TextStyle(color: isDark ? Colors.white : Colors.black.withOpacity(0.87), fontSize: 14),
                decoration: InputDecoration(
                  hintText: "e.g., I run a business consultancy / IT service firm and plan to recommend MistPOS to my retail clients...",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.4),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: isDark ? Colors.white.withOpacity(0.70) : Colors.black.withOpacity(0.54), fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: _submitting
                  ? null
                  : () {
                      Navigator.pop(context);
                      _submitApplication();
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Submit Application", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Obx(() {
        final company = _invController.company.value;
        if (company == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final status = company.resellerProps.status;

        if (status == "Approved") {
          return _buildApprovedView(company, isDark, primary);
        } else if (status == "Pending") {
          return _buildPendingView(isDark, primary);
        } else if (status == "Rejected") {
          return _buildRejectedView(company, isDark, primary);
        } else {
          return _buildNotResellerView(isDark, primary);
        }
      }),
    );
  }

  Widget _buildNotResellerView(bool isDark, Color primary) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Promotional Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary,
                  primary.withOpacity(0.80),
                  const Color(0xFF1E3A8A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.20),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(Bx.group, color: Colors.white, size: 14),
                      const SizedBox(width: 8),
                      const Text(
                        "RESELLER PARTNERSHIP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Earn Passive Income with MistPOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Recommend the ultimate point-of-sale platform and receive recurring monthly commissions for every merchant that registers and subscribes.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Steps of Reselling Program
          Text(
            "HOW THE PROGRAM WORKS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white.withOpacity(0.54) : Colors.black.withOpacity(0.45),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          _buildStepRow(
            stepNumber: "1",
            icon: Bx.bullseye,
            title: "Introduce & Promote MistPOS",
            description: "Market and recommend the MistPOS application to retail stores, supermarkets, restaurants, and other businesses in your area.",
            isDark: isDark,
            iconColor: Colors.blueAccent,
          ),
          _buildStepRow(
            stepNumber: "2",
            icon: Bx.key,
            title: "Share Your Unique Referral Code",
            description: "Provide merchants with your unique code. During their registration process, they enter this code under the referral field.",
            isDark: isDark,
            iconColor: Colors.indigoAccent,
          ),
          _buildStepRow(
            stepNumber: "3",
            icon: Bx.money,
            title: "Collect Monthly Commission Share",
            description: "Every time a referred business renews their premium monthly subscription, your partner account earns a direct percentage of the transaction.",
            isDark: isDark,
            iconColor: const Color(0xFF10B981),
          ),
          _buildStepRow(
            stepNumber: "4",
            icon: Bx.bar_chart,
            title: "Real-time Dashboard & Review",
            description: "Track referred businesses, monitor subscription cycles, review pending rewards, and verify monthly pay-outs in real time.",
            isDark: isDark,
            iconColor: Colors.amber,
          ),

          const SizedBox(height: 16),

          // Apply Call to Action Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.20 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 44,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 14),
                Text(
                  "Become an Approved Reseller",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Applications are reviewed within 24-48 hours. Upon approval, your unique code and customizable dashboard will be unlocked immediately.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white.withOpacity(0.60) : Colors.black.withOpacity(0.54),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _showApplyDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "Submit Partnership Application",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String stepNumber,
    required String icon,
    required String title,
    required String description,
    required bool isDark,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.10 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Iconify(icon, color: iconColor, size: 24),
              ),
              Container(
                transform: Matrix4.translationValues(4, 4, 0),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    width: 2,
                  ),
                ),
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white.withOpacity(0.60) : Colors.black.withOpacity(0.54),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPendingView(bool isDark, Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber.withOpacity(0.30),
                  width: 3,
                ),
              ),
              child: const Iconify(
                Carbon.time,
                size: 56,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Application Under Review",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Thank you for applying. Our accounts team is validating your application information. We will notify you here once your account is active.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.60) : Colors.black.withOpacity(0.54),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Standard response within 24 hours",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white.withOpacity(0.55) : Colors.black.withOpacity(0.54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedView(CompanyModel company, bool isDark, Color primary) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.30),
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 56,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Application Declined",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "We appreciate your interest in the partnership. Unfortunately, your request could not be approved at this time.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.60) : Colors.black.withOpacity(0.54),
                height: 1.5,
              ),
            ),
            if (company.resellerProps.statusReason.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Review Feedback:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white.withOpacity(0.38) : Colors.black.withOpacity(0.45),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company.resellerProps.statusReason,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark ? Colors.white.withOpacity(0.87) : Colors.black.withOpacity(0.87),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _showApplyDialog,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  "Modify & Re-apply",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovedView(CompanyModel company, bool isDark, Color primary) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Welcome Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.20),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(Bx.check_double, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      const Text(
                        "APPROVED MISTPOS PARTNER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Welcome, Partner!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You are officially registered. Use the promotional tools and metrics below to grow your network and check your commissions.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Referral Code Box
          Text(
            "YOUR UNIQUE REFERRAL CODE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white.withOpacity(0.54) : Colors.black.withOpacity(0.45),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: primary.withOpacity(0.30),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.resellerProps.code.toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: primary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Clients must input this code during registration.",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white.withOpacity(0.55) : Colors.black.withOpacity(0.54),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: company.resellerProps.code.toUpperCase()));
                    Toaster.showSuccess("Referral code copied to clipboard!");
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      color: primary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Partner Details Grid
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const ScreenResellerDashboard());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dashboard_customize_rounded, size: 22),
                  SizedBox(width: 12),
                  Text(
                    "Access Reseller Dashboard",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Program guide for approved partners
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HOW TO MAXIMIZE YOUR EARNINGS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white.withOpacity(0.54) : Colors.black.withOpacity(0.45),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGuideBullet("1", "Present the MistPOS app demo directly to managers and directors of retail stores."),
                const SizedBox(height: 12),
                _buildGuideBullet("2", "Remind them to use your Referral Code during registration so they get premium setup assistance."),
                const SizedBox(height: 12),
                _buildGuideBullet("3", "Commissions accrue immediately on all basic, pro, or enterprise plans paid by the merchants."),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatsTile({
    required String icon,
    required Color iconColor,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Iconify(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white.withOpacity(0.55) : Colors.black.withOpacity(0.54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideBullet(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: Text(
            num,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
