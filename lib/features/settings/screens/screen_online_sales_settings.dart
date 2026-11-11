import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/settings/screens/modern_layout.dart';

class ScreenOnlineSalesSettings extends StatefulWidget {
  const ScreenOnlineSalesSettings({super.key});

  @override
  State<ScreenOnlineSalesSettings> createState() =>
      _ScreenOnlineSalesSettingsState();
}

class _ScreenOnlineSalesSettingsState extends State<ScreenOnlineSalesSettings> {
  final _invController = Get.find<InventoryController>();
  final _adminController = Get.find<AdminController>();

  Future<void> _persistCompany(VoidCallback mutate) async {
    final company = _invController.company.value;
    if (company == null) {
      Toaster.showError("Company not loaded");
      return;
    }
    mutate();
    final ok = await _adminController.updateCompany(
      company.toJson(),
      company.hexId,
    );
    if (!ok) return;
    if (mounted) setState(() {});
    Toaster.showSuccess("Online sales settings updated");
  }

  bool get _onlineOn => _invController.company.value?.enableOnlineSales ?? false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Online sales"),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pad = constraints.maxWidth >= 600 ? 20.0 : 12.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(pad, 12, pad, 28),
                  children: [
                    _infoBanner(isDark),
                    20.gapColumn,
                    MistMordernLayout(
                      label: "Mode",
                      children: [
                        Obx(
                          () => _switchTile(
                            context,
                            enabled: true,
                            icon: Bx.cloud,
                            title: "Enable online sales",
                            subtitle:
                                "Checkout waits for the server receipt before printing. Offline-first sales stay the default when this is off.",
                            value: _invController
                                    .company.value?.enableOnlineSales ??
                                false,
                            loading: _adminController.companyLoading.value,
                            onChanged: (v) => _persistCompany(() {
                              _invController.company.value!.enableOnlineSales =
                                  v;
                            }),
                          ),
                        ),
                      ],
                    ),
                    20.gapColumn,
                    MistMordernLayout(
                      label: "Ghost & stale stock",
                      children: [
                        Obx(
                          () => _switchTile(
                            context,
                            enabled: _onlineOn,
                            icon: Bx.error_circle,
                            title: "Prevent ghost / stale stock",
                            subtitle:
                                "Block cart changes and checkout when tracked items exceed available quantity (local cache and server).",
                            value: _invController
                                    .company.value?.onlineSalesStrictStock ??
                                true,
                            loading: _adminController.companyLoading.value,
                            onChanged: (v) => _persistCompany(() {
                              _invController
                                      .company.value!.onlineSalesStrictStock =
                                  v;
                            }),
                          ),
                        ),
                        Obx(
                          () => _switchTile(
                            context,
                            enabled: _onlineOn,
                            icon: Bx.refresh,
                            title: "Sync stock before checkout",
                            subtitle:
                                "Download latest product quantities from the server immediately before payment.",
                            value: _invController.company.value
                                    ?.onlineSalesSyncBeforeCheckout ??
                                true,
                            loading: _adminController.companyLoading.value,
                            onChanged: (v) => _persistCompany(() {
                              _invController.company.value!
                                  .onlineSalesSyncBeforeCheckout = v;
                            }),
                          ),
                        ),
                      ],
                    ),
                    20.gapColumn,
                    MistMordernLayout(
                      label: "Receipts & fiscalization",
                      children: [
                        Obx(() {
                          final company = _invController.company.value;
                          final hasZimra = company?.zimraCertificate != null &&
                              company!.zimraCertificate!.isNotEmpty;
                          return _switchTile(
                            context,
                            enabled: _onlineOn && hasZimra,
                            icon: Bx.receipt,
                            title: "Wait for ZIMRA fiscalization",
                            subtitle: hasZimra
                                ? "When on, checkout blocks until ZIMRA FDMS accepts the receipt. When off, checkout completes on the server and fiscalization proceeds in background."
                                : "ZIMRA device is not configured for this company. Receipts are created online without ZIMRA fiscalization.",
                            value: hasZimra
                                ? (company.onlineSalesWaitForFiscalization)
                                : false,
                            loading: _adminController.companyLoading.value,
                            onChanged: (v) => _persistCompany(() {
                              _invController.company.value!
                                  .onlineSalesWaitForFiscalization = v;
                            }),
                          );
                        }),
                        _noteTile(
                          context,
                          enabled: _onlineOn,
                          icon: Bx.wifi,
                          title: "Internet required",
                          subtitle:
                              "Online sales requires an active internet connection to communicate with the server during checkout.",
                        ),
                      ],
                    ),
                    20.gapColumn,
                    MistMordernLayout(
                      label: "How it works",
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "With online sales off, cashiers keep the familiar offline flow: receipt is saved locally, synced in the background, and printed immediately if a printer is connected.\n\n"
                            "With online sales on, payment posts to the server first, stock rules above apply, and the printed receipt is the server response—including ZIMRA fiscal data when your device is configured and subscribed.",
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoBanner(bool isDark) {
    return Obx(() {
      final on = _invController.company.value?.enableOnlineSales ?? false;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: on
              ? Colors.blue.shade50.withAlpha(isDark ? 35 : 255)
              : AppTheme.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: on ? Colors.blue.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Iconify(
              on ? Bx.cloud : Bx.store,
              color: on ? Colors.blue.shade700 : Colors.grey.shade600,
              size: 28,
            ),
            12.gapWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    on ? "Online sales active" : "Offline sales (default)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  6.gapHeight,
                  Text(
                    on
                        ? "This store uses server-first checkout for all cashiers."
                        : "Standard offline POS. Open the options below when you are ready to switch.",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _switchTile(
    BuildContext context, {
    required bool enabled,
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool loading,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: enabled,
      leading: Iconify(
        icon,
        color: enabled ? AppTheme.color(context) : Colors.grey,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      trailing: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Switch(
              value: enabled ? value : false,
              onChanged: enabled ? onChanged : null,
            ),
      onTap: enabled && !loading ? () => onChanged(!value) : null,
    );
  }

  Widget _noteTile(
    BuildContext context, {
    required bool enabled,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: enabled,
      leading: Iconify(
        icon,
        color: enabled ? AppTheme.color(context) : Colors.grey,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }
}
