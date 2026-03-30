import 'package:flutter/material.dart';
import 'package:mistpos/models/company_model.dart';

// Note: Ensure the model classes provided in your snippet are imported or available in your project.
// For this demo, I'm using the logic from your provided CompanyModel and AutomatedSyncModel.

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

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.company.automatedSync.hasSubscription;
    _phoneController.text = widget.company.automatedSync.phone;
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
          double monthlyPrice = 10.0; // Example price
          double totalPrice = _selectedMonths * monthlyPrice;

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
                        "\$${totalPrice.toStringAsFixed(2)}",
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
                    onPressed: () {
                      // Logic to process subscription
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Subscription initiated..."),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("PROCEED TO PAYMENT"),
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
    final sync = widget.company.automatedSync;

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

            _InfoTile(
              icon: Icons.phone_android,
              title: "Registered Phone",
              value: sync.phone.isEmpty ? "Not provided" : sync.phone,
            ),
            _InfoTile(
              icon: Icons.payments_outlined,
              title: "Subscription Fee",
              value: "\$${sync.price.toStringAsFixed(2)} / mo",
            ),

            const SizedBox(height: 40),

            // Action Button
            Center(
              child: isSubscribed
                  ? OutlinedButton.icon(
                      onPressed: () {}, // Extend or Manage logic
                      icon: const Icon(Icons.history),
                      label: const Text("VIEW SUBSCRIPTION HISTORY"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
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
              "Note: Automated sync requires an active internet connection and a registered device phone number.",
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
