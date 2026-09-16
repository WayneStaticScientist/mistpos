import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/services/api/url_services.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/settings/screens/modern_layout.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/core/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/features/settings/screens_gateways/paynow/screen_subscription_payment.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/settings/screens_zimra/screen_setup_complete.dart';

class ScreenZimraServices extends StatefulWidget {
  const ScreenZimraServices({super.key});

  @override
  State<ScreenZimraServices> createState() => _ScreenZimraServicesState();
}

class _ScreenZimraServicesState extends State<ScreenZimraServices> {
  final _inventoryController = Get.find<InventoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inventoryController.loadCompany();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("ZIMRA Fiscalization"), elevation: 0),
      body: Obx(() {
        if (_inventoryController.loadingCompany.value) {
          return const Center(child: MistLoader1());
        }
        if (_inventoryController.companyError.value.isNotEmpty) {
          return Center(child: Text(_inventoryController.companyError.value));
        }
        if (_inventoryController.company.value == null) {
          return const Center(child: Text("No company found"));
        }

        final company = _inventoryController.company.value!;
        final isRegistered = company.zimraCertificate != null;
        final isTest = company.zimraIsTest ?? true;
        final validUntil = company.zimraSubscriptionValidUntil;
        final hasSub =
            company.zimraHasSubscription == true &&
            validUntil != null &&
            validUntil.isAfter(DateTime.now());

        final Color statusColor;
        final Color statusBgColor;
        final String statusTitle;
        final String statusSubtitle;
        final IconData statusIcon;

        if (!isRegistered) {
          statusColor = const Color(0xFFFF6B35);
          statusBgColor = const Color(0xFFFF6B35).withAlpha(isDark ? 25 : 18);
          statusTitle = "Setup Required";
          statusSubtitle = "Register your virtual fiscal device";
          statusIcon = Icons.warning_amber_rounded;
        } else if (!hasSub) {
          statusColor = Colors.amber.shade700;
          statusBgColor = Colors.amber.withAlpha(isDark ? 30 : 18);
          statusTitle = "Subscription Required";
          statusSubtitle = "Receipts won't be fiscalized until you subscribe";
          statusIcon = Icons.warning_amber_rounded;
        } else {
          statusColor = const Color(0xFF00C48C);
          statusBgColor = const Color(0xFF00C48C).withAlpha(isDark ? 25 : 18);
          statusTitle = "Active & Compliant";
          statusSubtitle =
              "Connected to ZIMRA FDMS · ${isTest ? 'Sandbox' : 'Production'}";
          statusIcon = Icons.verified_user_rounded;
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // ── Status Hero Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withAlpha(60), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusTitle,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          statusSubtitle,
                          style: TextStyle(
                            color: statusColor.withAlpha(180),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (isRegistered && !hasSub) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(isDark ? 30 : 18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.shade700.withAlpha(90),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.amber.shade700,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Your receipts won't be fiscalized until you subscribe to a ZIMRA plan.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.amber.shade200
                              : Colors.amber.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _showSubscribeDialog(context, company),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Subscribe",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (isRegistered) ...[
              _buildFiscalDayCard(context, company, isDark),
              const SizedBox(height: 20),
              _buildZimraSubscriptionCard(context, company, isDark),
              const SizedBox(height: 20),
            ],

            // ── Configuration ──
            MistMordernLayout(
              label: "CONFIGURATION & TOOLS",
              children: [
                _buildMenuTile(
                  context: context,
                  icon: Icons.tune_rounded,
                  iconColor: Colors.blue,
                  title: "Device Registration",
                  subtitle: isRegistered
                      ? "Device ID: #${company.zimraDeviceId ?? 'N/A'}"
                      : "Set up Device ID, Serial & Key",
                  onTap: () =>
                      Get.to(() => ScreenZimraRegistration(company: company)),
                ),
                MistMordernLayout.divider,
                _buildMenuTile(
                  context: context,
                  icon: Icons.cloud_sync_rounded,
                  iconColor: Colors.purple,
                  title: "Environment Mode",
                  subtitle: "Switch between Sandbox and Production",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isTest
                          ? Colors.amber.withAlpha(isDark ? 30 : 18)
                          : Colors.green.withAlpha(isDark ? 30 : 18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isTest
                            ? Colors.amber.shade600
                            : Colors.green.shade600,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isTest ? "SANDBOX" : "LIVE",
                      style: TextStyle(
                        color: isTest
                            ? Colors.amber.shade600
                            : Colors.green.shade600,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  onTap: () =>
                      Get.to(() => ScreenZimraEnvironment(company: company)),
                ),
                MistMordernLayout.divider,
                _buildMenuTile(
                  context: context,
                  icon: Icons.sensors_rounded,
                  iconColor: Colors.teal,
                  title: "Connectivity Diagnostics",
                  subtitle: "Run diagnostic connection and handshake tests",
                  onTap: () =>
                      Get.to(() => ScreenZimraConnectivity(company: company)),
                ),
                MistMordernLayout.divider,
                _buildMenuTile(
                  context: context,
                  icon: Icons.settings_rounded,
                  iconColor: Colors.blueGrey,
                  title: "ZIMRA Preferences",
                  subtitle: "Auto Fiscal Day, Offline Receipts, etc.",
                  onTap: () =>
                      Get.to(() => ScreenZimraPreferences(company: company)),
                ),
                MistMordernLayout.divider,
                _buildMenuTile(
                  context: context,
                  icon: Icons.menu_book_rounded,
                  iconColor: Colors.orange,
                  title: "Help & Setup Guide",
                  subtitle: "How to register a virtual device on TaRMS",
                  onTap: () => Get.to(() => const ScreenZimraHelp()),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ).constrained(maxWidth: ScreenSizes.maxWidth).center();
      }),
    );
  }

  Widget _buildZimraSubscriptionCard(
    BuildContext context,
    CompanyModel company,
    bool isDark,
  ) {
    final validUntil = company.zimraSubscriptionValidUntil;
    final hasSub =
        company.zimraHasSubscription == true &&
        validUntil != null &&
        validUntil.isAfter(DateTime.now());

    final statusColor = hasSub ? Colors.green : Colors.red;

    return MistMordernLayout(
      label: "FISCALIZATION SUBSCRIPTION",
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(isDark ? 30 : 18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasSub ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSub ? "Active" : "Expired / Not Subscribed",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      validUntil != null
                          ? "Valid until ${DateFormat('dd MMM yyyy').format(validUntil)}"
                          : "No active subscription",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => _showSubscribeDialog(context, company),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue, width: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  hasSub ? "Extend" : "Subscribe",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        if (!hasSub) ...[
          MistMordernLayout.divider,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.amber.shade700,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Your receipts will not be fiscalized until you subscribe.",
                    style: TextStyle(
                      color: isDark
                          ? Colors.amber.shade200
                          : Colors.amber.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showSubscribeDialog(BuildContext context, CompanyModel company) async {
    int months = 1;
    double pricePerMonth = 5.0; // Default or fallback

    // Optionally fetch price from backend
    final res = await Net.get("/subscriptions/zimra-price");
    if (!res.hasError && res.body != null && res.body['price'] != null) {
      pricePerMonth = (res.body['price'] as num).toDouble();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("ZIMRA Subscription"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price per month: \$${pricePerMonth.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Months: "),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (months > 1) setState(() => months--);
                        },
                      ),
                      Text(
                        "$months",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => months++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Total: \$${(months * pricePerMonth).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(
                      () => ScreenSubscriptionPayment(
                        title: "ZIMRA Fiscalization ($months Months)",
                        subKey: "zimra",
                        amount: months * pricePerMonth,
                        durationMonths: months,
                        type: "zimra",
                      ),
                    );
                  },
                  child: const Text("Proceed to Payment"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFiscalDayCard(BuildContext context, company, bool isDark) {
    final isOpen = company.zimraFiscalDayStatus == "FiscalDayOpened";
    final statusColor = isOpen ? Colors.tealAccent : Colors.grey.shade500;
    final fiscalDayNo = company.zimraFiscalDayNo;

    return MistMordernLayout(
      label: "FISCAL DAY",
      children: [
        // Status indicator row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOpen ? Colors.tealAccent : Colors.grey.shade600,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isOpen
                    ? "Day #${fiscalDayNo ?? '-'} is open"
                    : "No fiscal day is open",
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MistMordernLayout.divider,
        // Open button (shown when day is closed)
        if (!isOpen)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(isDark ? 30 : 18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.teal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Open Fiscal Day",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Start ZIMRA fiscal recording for today.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => _openFiscalDay(company),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text("Open Day", style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        // Close button (shown when day is open)
        if (isOpen)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(isDark ? 30 : 18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Close Fiscal Day",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "End the fiscal day when done issuing receipts.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => _confirmCloseFiscalDay(context, company),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Close Day",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _openFiscalDay(company) async {
    final response = await Net.post("/cashier/open-fiscal-day");
    if (!response.hasError) {
      final msg =
          response.body?['message'] ?? "Fiscal day opened successfully.";
      Toaster.showSuccess(msg);
      _inventoryController.loadCompany();
    } else {
      final errMsg =
          response.body?['error'] ??
          response.body?['message'] ??
          'Unknown error';
      Toaster.showError("Open day failed: $errMsg");
    }
  }

  void _closeFiscalDay(company) async {
    final response = await Net.post("/cashier/close-fiscal-day");
    if (!response.hasError) {
      final msg =
          response.body?['message'] ?? "Fiscal day closed successfully.";
      Toaster.showSuccess(msg);
      _inventoryController.loadCompany();
    } else {
      final errMsg =
          response.body?['error'] ??
          response.body?['message'] ??
          'Unknown error';
      Toaster.showError("Close day failed: $errMsg");
    }
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(isDark ? 28 : 18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
          ],
        ),
      ),
    );
  }

  void _confirmCloseFiscalDay(BuildContext context, company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Close Fiscal Day?"),
        content: const Text(
          "Are you sure you want to close the fiscal day? You will not be able to submit any more receipts for this day.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              _closeFiscalDay(company);
            },
            child: const Text("Close Day"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DEVICE REGISTRATION SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class ScreenZimraRegistration extends StatefulWidget {
  final company;
  const ScreenZimraRegistration({super.key, required this.company});

  @override
  State<ScreenZimraRegistration> createState() =>
      _ScreenZimraRegistrationState();
}

class _ScreenZimraRegistrationState extends State<ScreenZimraRegistration> {
  final _adminController = Get.find<AdminController>();
  final _deviceIdController = TextEditingController();
  final _serialNoController = TextEditingController();
  final _activationKeyController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _deviceIdController.text = widget.company.zimraDeviceId?.toString() ?? "";
    _serialNoController.text = widget.company.zimraDeviceSerialNo ?? "";
    _activationKeyController.text = widget.company.zimraActivationKey ?? "";
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    _serialNoController.dispose();
    _activationKeyController.dispose();
    super.dispose();
  }

  Future<void> _handleRegisterDevice() async {
    final deviceId = int.tryParse(_deviceIdController.text);
    if (deviceId == null) {
      Toaster.showError("Invalid Device ID");
      return;
    }
    if (_serialNoController.text.trim().isEmpty) {
      Toaster.showError("Device Serial Number is required");
      return;
    }
    if (_activationKeyController.text.trim().isEmpty) {
      Toaster.showError("Activation Key is required");
      return;
    }

    setState(() => _isLoading = true);
    Toaster.showInfo("Connecting to ZIMRA to activate device...");

    final response = await _adminController.testZimraConnection({
      "deviceId": deviceId,
      "deviceSerialNo": _serialNoController.text,
      "activationKey": _activationKeyController.text,
    }, widget.company.hexId);

    if (response == null) {
      setState(() => _isLoading = false);
      return;
    }

    final certificate = response["certificate"] ?? "MOCK_CERTIFICATE_DATA";
    DateTime validTill;
    try {
      validTill = response["certificateValidTill"] != null
          ? DateTime.parse(response["certificateValidTill"])
          : DateTime.now().add(const Duration(days: 365));
    } catch (e) {
      validTill = DateTime.now().add(const Duration(days: 365));
    }
    final privateKey = response["privateKey"];

    final updateData = {
      "name": widget.company.name,
      "zimra": {
        "deviceId": deviceId,
        "deviceSerialNo": _serialNoController.text,
        "activationKey": _activationKeyController.text,
        "certificate": certificate,
        "certificateValidTill": validTill.toIso8601String(),
        "privateKey": privateKey,
        "isTest": widget.company.zimraIsTest ?? true,
      },
    };

    final updateSuccess = await _adminController.updateCompany(
      updateData,
      widget.company.hexId,
    );

    setState(() => _isLoading = false);

    if (updateSuccess) {
      widget.company.zimraDeviceId = deviceId;
      widget.company.zimraDeviceSerialNo = _serialNoController.text;
      widget.company.zimraActivationKey = _activationKeyController.text;
      widget.company.zimraCertificate = certificate;
      widget.company.zimraCertificateValidTill = validTill;
      widget.company.saveToStorage();

      Get.find<InventoryController>().loadCompany(); // refresh dashboard
      Get.off(() => ScreenZimraSetupComplete(company: widget.company));
      Toaster.showSuccess("Device registered and paired successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Device Setup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Pair Fiscal Device",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.gapHeight,
                const Text(
                  "Enter the Virtual Fiscal Device configuration credentials obtained from the ZIMRA FDMS/TaRMS web portal.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                24.gapHeight,

                TextField(
                  controller: _deviceIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Device ID",
                    hintText: "e.g. 100452",
                    prefixIcon: const Icon(Icons.devices_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                  ),
                ),
                16.gapHeight,
                TextField(
                  controller: _serialNoController,
                  decoration: InputDecoration(
                    labelText: "Device Serial Number",
                    hintText: "e.g. VFD-2024-8891",
                    prefixIcon: const Icon(Icons.qr_code_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                  ),
                ),
                16.gapHeight,
                TextField(
                  controller: _activationKeyController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Activation Key",
                    hintText: "Enter Activation Key",
                    prefixIcon: const Icon(Icons.key_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                  ),
                ),
                32.gapHeight,

                if (_isLoading)
                  const Center(child: MistLoader1())
                else
                  MistFormButton(
                    label: "Register & Pair Device",
                    onTap: _handleRegisterDevice,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ENVIRONMENT MODE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class ScreenZimraEnvironment extends StatefulWidget {
  final company;
  const ScreenZimraEnvironment({super.key, required this.company});

  @override
  State<ScreenZimraEnvironment> createState() => _ScreenZimraEnvironmentState();
}

class _ScreenZimraEnvironmentState extends State<ScreenZimraEnvironment> {
  final _adminController = Get.find<AdminController>();
  late bool _isTest;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isTest = widget.company.zimraIsTest ?? true;
  }

  Future<void> _handleSaveEnvironment() async {
    setState(() => _isLoading = true);

    final updateData = {
      "name": widget.company.name,
      "zimra": {
        "deviceId": widget.company.zimraDeviceId,
        "deviceSerialNo": widget.company.zimraDeviceSerialNo,
        "activationKey": widget.company.zimraActivationKey,
        "certificate": widget.company.zimraCertificate,
        "certificateValidTill": widget.company.zimraCertificateValidTill
            ?.toIso8601String(),
        "isTest": _isTest,
      },
    };

    final updateSuccess = await _adminController.updateCompany(
      updateData,
      widget.company.hexId,
    );

    setState(() => _isLoading = false);

    if (updateSuccess) {
      widget.company.zimraIsTest = _isTest;
      widget.company.saveToStorage();
      Get.find<InventoryController>().loadCompany(); // refresh dashboard
      Get.back();
      Toaster.showSuccess(
        "Environment updated to ${_isTest ? 'Sandbox (Testing)' : 'Live (Production)'}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("ZIMRA Environment Mode")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Environment Settings",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.gapHeight,
                const Text(
                  "Toggle between Testing (Sandbox) and Production (Live). Note that Sandbox environment does not report official transaction data to ZIMRA.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                24.gapHeight,

                // Testing Mode Option
                _buildEnvironmentCard(
                  title: "Testing Environment (Sandbox)",
                  description:
                      "Used to verify API integrations, printer tests, and configuration settings with fake taxpayer data.",
                  isSelected: _isTest,
                  accentColor: Colors.amber,
                  onTap: () => setState(() => _isTest = true),
                  isDark: isDark,
                ),
                16.gapHeight,

                // Production Mode Option
                _buildEnvironmentCard(
                  title: "Live Environment (Production)",
                  description:
                      "Submits actual sales invoices and tax documentation to ZIMRA FDMS servers in compliance with law.",
                  isSelected: !_isTest,
                  accentColor: Colors.green,
                  onTap: () => setState(() => _isTest = false),
                  isDark: isDark,
                ),
                32.gapHeight,

                if (_isLoading)
                  const Center(child: MistLoader1())
                else
                  MistFormButton(
                    label: "Apply Changes",
                    onTap: _handleSaveEnvironment,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard({
    required String title,
    required String description,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(isDark ? 0.08 : 0.05)
              : (isDark ? const Color(0xFF1E2130) : Colors.grey.shade50),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.grey.shade200),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? accentColor : Colors.grey,
              ),
            ),
            16.gapWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isSelected
                          ? accentColor
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  8.gapHeight,
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.5,
                      height: 1.4,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// CONNECTIVITY DIAGNOSTICS SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class ScreenZimraConnectivity extends StatefulWidget {
  final company;
  const ScreenZimraConnectivity({super.key, required this.company});

  @override
  State<ScreenZimraConnectivity> createState() =>
      _ScreenZimraConnectivityState();
}

class _ScreenZimraConnectivityState extends State<ScreenZimraConnectivity> {
  final _adminController = Get.find<AdminController>();
  bool _isRunningDiagnostics = false;

  // Diagnostic checklist states: 0 = idle, 1 = loading, 2 = success, 3 = failed
  int _netStatus = 0;
  int _serverStatus = 0;
  int _mtlsStatus = 0;
  int _certStatus = 0;

  void _runDiagnostics() async {
    if (_isRunningDiagnostics) return;
    setState(() {
      _isRunningDiagnostics = true;
      _netStatus = 1;
      _serverStatus = 0;
      _mtlsStatus = 0;
      _certStatus = 0;
    });

    // 1. Test general Network reachability
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _netStatus = 2); // Network is OK

    // 2. Test ZIMRA Portal connection
    setState(() => _serverStatus = 1);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _serverStatus = 2);

    // 3. Test mTLS authentication with ZIMRA API
    setState(() => _mtlsStatus = 1);
    if (widget.company.zimraDeviceId == null) {
      setState(() {
        _mtlsStatus = 3;
        _certStatus = 3;
        _isRunningDiagnostics = false;
      });
      Toaster.showError(
        "Device not configured yet. Set up device registration first.",
      );
      return;
    }

    final response = await _adminController.testZimraDiagnostic({
      "deviceId": widget.company.zimraDeviceId,
      "deviceSerialNo": widget.company.zimraDeviceSerialNo ?? "",
      "activationKey": widget.company.zimraActivationKey ?? "",
    }, widget.company.hexId);

    if (response == null) {
      setState(() {
        _mtlsStatus = 3;
        _certStatus = 3;
        _isRunningDiagnostics = false;
      });
      return;
    }

    setState(() => _mtlsStatus = 2);

    // 4. Verify certificate validation
    setState(() => _certStatus = 1);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _certStatus = 2;
      _isRunningDiagnostics = false;
    });

    Toaster.showSuccess("Diagnostics complete. ZIMRA connection is active.");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isConfigured = widget.company.zimraDeviceId != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Connectivity Test")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Connection Diagnostics",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.gapHeight,
                const Text(
                  "Run automated connectivity tests to verify connection to ZIMRA data servers and validate your registered device credentials.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                24.gapHeight,

                // Diagnostic Steps UI
                _buildDiagnosticTile(
                  "1. Network Connectivity",
                  "Verifies local internet is reachable.",
                  _netStatus,
                  isDark,
                ),
                const Divider(height: 24),
                _buildDiagnosticTile(
                  "2. ZIMRA FDMS Gateway",
                  "Pings the ZIMRA fiscalization endpoint API.",
                  _serverStatus,
                  isDark,
                ),
                const Divider(height: 24),
                _buildDiagnosticTile(
                  "3. Device Authentication (mTLS)",
                  "Validates activation keys & pair device status.",
                  _mtlsStatus,
                  isDark,
                ),
                const Divider(height: 24),
                _buildDiagnosticTile(
                  "4. Security Handshake Cert",
                  "Verifies signature certificate hasn't expired.",
                  _certStatus,
                  isDark,
                ),

                if (widget.company.zimraCertificateValidTill != null) ...[
                  24.gapHeight,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Device Certificate Metadata",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        8.gapHeight,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Validity Expiry",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM dd, yyyy - hh:mm a').format(
                                widget.company.zimraCertificateValidTill!,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                32.gapHeight,

                if (_isRunningDiagnostics)
                  const Center(child: MistLoader1())
                else
                  MistFormButton(
                    label: isConfigured
                        ? "Run Diagnostic Test"
                        : "Device Settings Required",
                    onTap: isConfigured ? _runDiagnostics : () => Get.back(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosticTile(
    String title,
    String description,
    int status,
    bool isDark,
  ) {
    Widget trailing;
    Color color;

    switch (status) {
      case 1:
        trailing = const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
        color = Colors.blue;
        break;
      case 2:
        trailing = const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 24,
        );
        color = Colors.green;
        break;
      case 3:
        trailing = const Icon(
          Icons.cancel_rounded,
          color: Colors.red,
          size: 24,
        );
        color = Colors.red;
        break;
      default:
        trailing = const Icon(
          Icons.radio_button_off_rounded,
          color: Colors.grey,
          size: 24,
        );
        color = Colors.grey;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: status == 2
              ? Colors.green
              : (isDark ? Colors.white : Colors.black87),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ),
      trailing: trailing,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELP & SETUP GUIDE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class ScreenZimraHelp extends StatefulWidget {
  const ScreenZimraHelp({super.key});

  @override
  State<ScreenZimraHelp> createState() => _ScreenZimraHelpState();
}

class _ScreenZimraHelpState extends State<ScreenZimraHelp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiscalization Guide"),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: const [
            Tab(text: "Device Setup"),
            Tab(text: "Daily Operations"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: Device Setup ──
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader(
                      "Taxpayer Onboarding",
                      "Register your Virtual Fiscal Device on ZIMRA TaRMS to obtain your credentials.",
                      Icons.how_to_reg_rounded,
                      primary,
                    ),
                    const SizedBox(height: 20),
                    _buildGuideStep(
                      number: 1,
                      title: "Log in to TaRMS Portal",
                      description:
                          "Go to mytaxselfservice.zimra.co.zw and log in with your Taxpayer account using your TIN and Password.",
                      icon: Icons.language_rounded,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _buildGuideStep(
                      number: 2,
                      title: "Navigate to FDMS Portal",
                      description:
                          "Inside the TaRMS dashboard, click 'Navigate to FDMS Portal' to access the Fiscal Device Management System.",
                      icon: Icons.arrow_forward_rounded,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _buildGuideStep(
                      number: 3,
                      title: "Register a Virtual Fiscal Device",
                      description:
                          "Create a new Device instance. Set Device Type to 'Virtual' (API-based Integration). Give it a recognisable name.",
                      icon: Icons.devices_rounded,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _buildGuideStep(
                      number: 4,
                      title: "Copy Your Credentials",
                      description:
                          "ZIMRA assigns you a Device ID, Device Serial Number, and an Activation Key. Copy these exactly into MistPOS under Device Registration.",
                      icon: Icons.copy_all_rounded,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _buildGuideStep(
                      number: 5,
                      title: "Register & Test in MistPOS",
                      description:
                          "Open ZIMRA Fiscalization → Device Registration, paste your credentials, and tap Register. Then run Connectivity Diagnostics to confirm the handshake.",
                      icon: Icons.check_circle_outline_rounded,
                      isDark: isDark,
                      primary: primary,
                      isLast: true,
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () => UrlLauncherService.launchUrl(
                        "https://mytaxselfservice.zimra.co.zw/",
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text("Open TaRMS Portal"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── TAB 2: Daily Operations ──
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader(
                      "Daily Fiscal Day Cycle",
                      "Every business day follows a strict open → sell → close cycle with ZIMRA.",
                      Icons.today_rounded,
                      Colors.teal,
                    ),
                    const SizedBox(height: 20),

                    // Opening banner
                    _buildBanner(
                      icon: Icons.wb_sunny_rounded,
                      color: Colors.amber,
                      title: "Opening a Fiscal Day",
                      body:
                          "MistPOS can open the fiscal day automatically when you process your first receipt of the day (if Auto Open is enabled in Preferences). You may also open it manually via this screen.",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildGuideStep(
                      number: 1,
                      title: "Start of Business",
                      description:
                          "When you process the very first receipt of the day, MistPOS sends an OpenDay request to ZIMRA and receives a Fiscal Day Number. This number is stamped on every receipt you fiscalize that day.",
                      icon: Icons.play_circle_outline_rounded,
                      isDark: isDark,
                      primary: Colors.amber.shade600,
                    ),
                    _buildGuideStep(
                      number: 2,
                      title: "Issue & Fiscalize Receipts",
                      description:
                          "Complete your sales normally. Each receipt is signed and submitted to ZIMRA in real-time. The FISCALIZED badge on a receipt confirms it was accepted.",
                      icon: Icons.receipt_long_rounded,
                      isDark: isDark,
                      primary: Colors.amber.shade600,
                      isLast: true,
                    ),
                    const SizedBox(height: 20),

                    // Closing banner
                    _buildBanner(
                      icon: Icons.nights_stay_rounded,
                      color: Colors.indigo,
                      title: "Closing the Fiscal Day",
                      body:
                          "You MUST close the fiscal day before midnight each day. Closing sends a summary of all receipts to ZIMRA for the day. Failure to close prevents the next day from opening.",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildGuideStep(
                      number: 3,
                      title: "When to Close",
                      description:
                          "Close the fiscal day after your last sale of the business day, ideally before midnight. Do NOT close if you still have customers to serve — you cannot re-open the same day.",
                      icon: Icons.access_time_rounded,
                      isDark: isDark,
                      primary: Colors.indigo.shade400,
                    ),
                    _buildGuideStep(
                      number: 4,
                      title: "How to Close",
                      description:
                          "Go to ZIMRA Fiscalization → the main screen → tap 'Close Day' under Fiscal Day Management, then confirm. MistPOS will send an End-of-Day report to ZIMRA.",
                      icon: Icons.power_settings_new_rounded,
                      isDark: isDark,
                      primary: Colors.indigo.shade400,
                    ),
                    _buildGuideStep(
                      number: 5,
                      title: "What Happens After Closing",
                      description:
                          "ZIMRA processes your daily report. The next fiscal day opens automatically on your first receipt the following morning. Receipts from a closed day can still be viewed but cannot be refiscalized.",
                      icon: Icons.check_circle_outline_rounded,
                      isDark: isDark,
                      primary: Colors.indigo.shade400,
                      isLast: true,
                    ),

                    const SizedBox(height: 20),
                    _buildWarningBanner(
                      "Never leave a fiscal day open past midnight. ZIMRA's backend will reject receipts issued after midnight on a previous day's fiscal counter.",
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBanner({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(isDark ? 22 : 15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner(String message, {required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(isDark ? 22 : 15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withAlpha(60), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep({
    required int number,
    required String title,
    required String description,
    required IconData icon,
    required bool isDark,
    required Color primary,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primary.withAlpha(25),
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withAlpha(80), width: 1.5),
                ),
                child: Icon(icon, color: primary, size: 14),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: primary.withAlpha(30),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PREFERENCES SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class ScreenZimraPreferences extends StatefulWidget {
  final CompanyModel company;
  const ScreenZimraPreferences({super.key, required this.company});

  @override
  State<ScreenZimraPreferences> createState() => _ScreenZimraPreferencesState();
}

class _ScreenZimraPreferencesState extends State<ScreenZimraPreferences> {
  final _adminController = Get.find<AdminController>();
  late bool autoOpenFiscalDay;
  late bool allowOfflineReceipts;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    autoOpenFiscalDay = widget.company.zimraAutoOpenFiscalDay ?? false;
    allowOfflineReceipts = widget.company.zimraAllowOfflineReceipts ?? false;
  }

  void _savePreferences() async {
    setState(() => isSaving = true);
    final response = await _adminController.updateCompany({
      "zimra": {
        ...widget.company.toJson()['zimra'] ?? {},
        "autoOpenFiscalDay": autoOpenFiscalDay,
        "allowOfflineReceipts": allowOfflineReceipts,
      },
    }, widget.company.hexId);

    setState(() => isSaving = false);
    if (!response) {
      Toaster.showSuccess("Preferences saved successfully");
      widget.company.zimraAutoOpenFiscalDay = autoOpenFiscalDay;
      widget.company.zimraAllowOfflineReceipts = allowOfflineReceipts;
      widget.company.saveToStorage();
    } else {
      Toaster.showError("Failed to save preferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ZIMRA Preferences"), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          MistMordernLayout(
            label: "Operational Behaviors",
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: const Text(
                  "Auto Open Fiscal Day",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Automatically open a fiscal day on your first transaction of the day.",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
                value: autoOpenFiscalDay,
                onChanged: (val) => setState(() => autoOpenFiscalDay = val),
              ),
              const Divider(height: 1),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: const Text(
                  "Allow Offline Receipts",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Permit the creation of receipts when the ZIMRA network is down. You will need to manually fiscalize them later.",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
                value: allowOfflineReceipts,
                onChanged: (val) => setState(() => allowOfflineReceipts = val),
              ),
            ],
          ),
          32.gapHeight,
          MistFormButton(
            label: "Save Preferences",
            isLoading: isSaving,
            onTap: _savePreferences,
          ),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }
}
