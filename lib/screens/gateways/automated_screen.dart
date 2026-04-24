import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
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
  late bool isSubscribed;
  final _phoneController = TextEditingController();
  int _selectedMonths = 1;
  final _itemController = Get.find<ItemsController>();
  final _inventoryController = Get.find<InventoryController>();
  @override
  void initState() {
    super.initState();
    isSubscribed =
        _inventoryController.company.value!.automatedSync.hasSubscription &&
        (_inventoryController.company.value!.automatedSync.validUntil == null ||
            _inventoryController.company.value!.automatedSync.validUntil!
                .isAfter(DateTime.now()));
    _phoneController.text =
        _inventoryController.company.value!.automatedSync.phone;
  }

  void _showSubscribeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          double totalPrice =
              _selectedMonths *
              (_inventoryController.company.value!.automatedSync.price > 0
                  ? _inventoryController.company.value!.automatedSync.price
                  : 3);

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
                  "Activate Automated Sync",
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
                    onPressed: () => _subsribe(totalPrice),
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

  void _showChangeNumberSheet() {
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

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _changeNumber(_phoneController.text),
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
    final sync = _inventoryController.company.value!.automatedSync;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sync Settings"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSubscribed
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
                    isSubscribed ? Icons.sync : Icons.sync_disabled,
                    size: 48,
                    color: isSubscribed
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSubscribed ? "AUTOMATED SYNC ACTIVE" : "SYNC INACTIVE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isSubscribed
                          ? Colors.white
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isSubscribed && sync.validUntil != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      sync.validUntil!.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.white.withAlpha(204)),
                    ),
                  ],
                ],
              ),
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

            Obx(
              () => _InfoTile(
                icon: Icons.phone_android,
                title: "Registered Phone",
                value:
                    _inventoryController
                        .company
                        .value!
                        .automatedSync
                        .phone
                        .isEmpty
                    ? "Not provided"
                    : _inventoryController.company.value!.automatedSync.phone,
              ).onTap(() => _showChangeNumberSheet()),
            ),
            _InfoTile(
              icon: Icons.payments_outlined,
              title: "Subscription Fee",
              value:
                  "${CurrenceConverter.selectedCurrencyInString(sync.price)} / mo",
            ),
            const SizedBox(height: 40),

            // Action Button
            Center(
              child: isSubscribed
                  ? 0.gapHeight
                  : ElevatedButton(
                      onPressed: _showSubscribeSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 20,
                        ),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "SUBSCRIBE NOW",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 24),
            Text(
              "Note: Automated sync requires an active internet connection and a registered device phone number.Where you can receive updates and notifications about your inventory and sales.",
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

  void _subsribe(double amount) async {
    Get.back(); // Close the subscription sheet

    final formatted = formatPhoneNumber(_phoneController.text);
    if (formatted.length < 10) {
      Get.snackbar("Invalid Number", "Please enter a valid phone number");
      return;
    }

    final requestSuccess = await _inventoryController
        .requestAutomatedSyncPhoneChange(formatted);
    if (!requestSuccess) return;

    final verified = await Get.to(
      () => AutomatedPhoneVerificationScreen(phone: formatted),
    );
    if (verified != true) return;

    // Proceed to payment after verification
    final response = await _itemController.payWeForAutomation(
      amount,
      formatted,
    );
    if (response.returnUrl == null ||
        response.redirectUrl == null ||
        response.pollUrl == null) {
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

  void _changeNumber(String text) async {
    final formatted = formatPhoneNumber(text);
    if (formatted.length < 10) {
      Get.snackbar("Invalid Number", "Please enter a valid phone number");
      return;
    }

    final requestSuccess = await _inventoryController
        .requestAutomatedSyncPhoneChange(formatted);
    if (!requestSuccess) return;

    Get.back();
    final verified = await Get.to(
      () => AutomatedPhoneVerificationScreen(phone: formatted),
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withAlpha(102),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.grey),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
