import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/gateways/automated_phone_verification.dart';
import 'package:mistpos/screens/gateways/paynow/screen_automated_payment.dart';

class AutomatedSyncScreen extends StatefulWidget {
  final CompanyModel company;
  const AutomatedSyncScreen({super.key, required this.company});

  @override
  State<AutomatedSyncScreen> createState() => _AutomatedSyncScreenState();
}

class _AutomatedSyncScreenState extends State<AutomatedSyncScreen> {
  final _phoneController = TextEditingController();
  int _selectedMonths = 1;
  final _itemController = Get.find<ItemsController>();
  final _inventoryController = Get.find<InventoryController>();
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _phoneController.text =
        _inventoryController.company.value!.automatedSync.phone.isEmpty
        ? _inventoryController.company.value!.weeklyAutomatedSync.phone
        : _inventoryController.company.value!.automatedSync.phone;
  }

  void _showSubscribeSheet(String type) {
    final sync = type == 'weekly'
        ? _inventoryController.company.value!.weeklyAutomatedSync
        : _inventoryController.company.value!.automatedSync;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          double price = sync.price > 0
              ? sync.price
              : (type == 'weekly' ? 5 : 3);
          double totalPrice = _selectedMonths * price;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activate ${type.capitalizeFirst} Automated Sync",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Keep your data synchronized across all devices automatically.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone_android),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Duration Selector
                Text(
                  "Subscription Duration",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [1, 3, 6, 12].map((m) {
                    bool isSelected = _selectedMonths == m;
                    return ChoiceChip(
                      label: Text("$m Mo"),
                      selected: isSelected,
                      onSelected: (val) =>
                          setModalState(() => _selectedMonths = m),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Payable:"),
                      Text(
                        CurrenceConverter.selectedCurrencyInString(totalPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _subscribe(totalPrice, type),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                      () => _itemController.webProcessingPayment.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text("PROCEED TO PAYMENT"),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showChangeNumberSheet(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update Phone Number",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone_android),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _changeNumber(_phoneController.text, type),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                      () =>
                          _inventoryController.updatingAutomatedSyncPhone.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text("Change Number"),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool isProOrEnterprise =
        _userController.user.value?.subscriptions.contains('pro') == true ||
        _userController.user.value?.subscriptions.contains('enterprise') ==
            true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Automated Sync & Backup"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Sync Card
            _StatusCard(
              title: "DAILY AUTOMATED SYNC",
              sync: _inventoryController.company.value!.automatedSync,
              isProOrEnterprise: isProOrEnterprise,
              onSubscribe: () => _showSubscribeSheet('daily'),
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            // Weekly Sync Card
            _StatusCard(
              title: "WEEKLY AUTOMATED SYNC",
              sync: _inventoryController.company.value!.weeklyAutomatedSync,
              isProOrEnterprise: isProOrEnterprise,
              onSubscribe: () => _showSubscribeSheet('weekly'),
              colorScheme: colorScheme,
            ),

            const SizedBox(height: 32),

            // Details Section
            Text(
              "Configuration Details",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Obx(() {
              final dailySync =
                  _inventoryController.company.value!.automatedSync;
              final weeklySync =
                  _inventoryController.company.value!.weeklyAutomatedSync;

              return Column(
                children: [
                  _PhoneTile(
                    label: "Daily Sync Phone",
                    sync: dailySync,
                    onEdit: () => _showChangeNumberSheet('daily'),
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 12),
                  _PhoneTile(
                    label: "Weekly Sync Phone",
                    sync: weeklySync,
                    onEdit: () => _showChangeNumberSheet('weekly'),
                    colorScheme: colorScheme,
                  ),
                ],
              );
            }),

            const SizedBox(height: 24),
            Text(
              "Note: Automated sync requires an active internet connection and a registered device phone number where you can receive updates and notifications about your inventory and sales.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _subscribe(double amount, String type) async {
    Get.back();

    final formatted = formatPhoneNumber(_phoneController.text);
    if (formatted.length < 10) {
      Get.snackbar("Invalid Number", "Please enter a valid phone number");
      return;
    }

    final currentSync = type == 'weekly'
        ? _inventoryController.company.value!.weeklyAutomatedSync
        : _inventoryController.company.value!.automatedSync;

    if (currentSync.phone.isNotEmpty &&
        formatted == currentSync.phone &&
        currentSync.phoneVerified) {
      final response = await _itemController.payWeForAutomation(
        amount,
        formatted,
        type: type,
      );
      if (response.returnUrl == null ||
          response.redirectUrl == null ||
          response.pollUrl == null) {
        Toaster.showError("Failed to initiate payment, try again later");
        return;
      }
      Get.off(
        () => ScreenAutomatedPayment(
          amount: amount,
          pollUrl: response.pollUrl!,
          returnUrl: response.returnUrl!,
          webHookUrl: response.redirectUrl!,
        ),
      );
      return;
    }

    final requestSuccess = await _inventoryController
        .requestAutomatedSyncPhoneChange(formatted, type: type);
    if (!requestSuccess) return;

    final verified = await Get.to(
      () => AutomatedPhoneVerificationScreen(phone: formatted, type: type),
    );
    if (verified != true) return;

    // Proceed to payment after verification
    final response = await _itemController.payWeForAutomation(
      amount,
      formatted,
      type: type,
    );
    if (response.returnUrl == null ||
        response.redirectUrl == null ||
        response.pollUrl == null) {
      Toaster.showError("Failed to initiate payment, try again later");
      return;
    }
    Get.off(
      () => ScreenAutomatedPayment(
        amount: amount,
        pollUrl: response.pollUrl!,
        returnUrl: response.returnUrl!,
        webHookUrl: response.redirectUrl!,
      ),
    );
  }

  void _changeNumber(String text, String type) async {
    final currentSync = type == 'weekly'
        ? _inventoryController.company.value!.weeklyAutomatedSync
        : _inventoryController.company.value!.automatedSync;

    if (text == currentSync.phone) {
      Get.back();
      return;
    }
    final formatted = formatPhoneNumber(text);

    if (formatted.length < 10) {
      Get.snackbar("Invalid Number", "Please enter a valid phone number");
      return;
    }

    final requestSuccess = await _inventoryController
        .requestAutomatedSyncPhoneChange(formatted, type: type);
    if (!requestSuccess) return;

    Get.back();
    final verified = await Get.to(
      () => AutomatedPhoneVerificationScreen(phone: formatted, type: type),
    );
    if (verified == true) {
      setState(() {});
    }
  }

  String formatPhoneNumber(String text) {
    String formatted = text.replaceAll(' ', '');
    if (formatted.startsWith('0')) {
      formatted = '263${formatted.substring(1)}';
    } else if (formatted.startsWith('7') && formatted.length == 9) {
      formatted = '263$formatted';
    }
    return formatted.replaceAll('+', '');
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final AutomatedSyncModel sync;
  final bool isProOrEnterprise;
  final VoidCallback onSubscribe;
  final ColorScheme colorScheme;

  const _StatusCard({
    required this.title,
    required this.sync,
    required this.isProOrEnterprise,
    required this.onSubscribe,
    required this.colorScheme,
  });

  bool get isActive =>
      isProOrEnterprise ||
      (sync.hasSubscription &&
          (sync.validUntil == null ||
              sync.validUntil!.isAfter(DateTime.now())));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [colorScheme.primary, colorScheme.secondary]
              : [
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainerHighest,
                ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isActive ? Icons.sync : Icons.sync_disabled,
            size: 40,
            color: isActive ? Colors.white : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            isActive ? "$title ACTIVE" : "$title INACTIVE",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isActive ? Colors.white : colorScheme.onSurfaceVariant,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 8),
            Text(
              isProOrEnterprise
                  ? "Premium Tier Sync Access"
                  : "Valid Until: ${sync.validUntil?.toLocal().toString().split(' ')[0] ?? 'Continuous'}",
              style: TextStyle(color: Colors.white.withAlpha(204)),
            ),
          ] else ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("SUBSCRIBE NOW"),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneTile extends StatelessWidget {
  final String label;
  final AutomatedSyncModel sync;
  final VoidCallback onEdit;
  final ColorScheme colorScheme;

  const _PhoneTile({
    required this.label,
    required this.sync,
    required this.onEdit,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVerified = sync.phoneVerified;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(30)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.phone_android, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  sync.phone.isEmpty ? "Not provided" : sync.phone,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (sync.phone.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isVerified
                            ? Icons.verified_user
                            : Icons.warning_amber_rounded,
                        size: 14,
                        color: isVerified
                            ? Colors.green
                            : Colors.amber.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isVerified ? "Verified" : "Unverified Number",
                        style: TextStyle(
                          color: isVerified
                              ? Colors.green
                              : Colors.amber.shade800,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.edit, size: 16, color: colorScheme.primary),
            label: Text(
              sync.phone.isEmpty ? "Add" : "Change",
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatPhoneNumber(String text) {
  String formatted = text.replaceAll(' ', '');
  if (formatted.startsWith('0')) {
    formatted = '263${formatted.substring(1)}';
  } else if (formatted.startsWith('7') && formatted.length == 9) {
    formatted = '263$formatted';
  }
  return formatted.replaceAll('+', '');
}
