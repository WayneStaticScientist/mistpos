import 'dart:io';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/sdk_int.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/widgets/inputs/input_form.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/features/settings/screens/modern_layout.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/auth/screens/screen_user_profile.dart';
import 'package:mistpos/features/settings/screens/screen_receit_designer.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens_gateways/automated_screen.dart';

class ScreenSettingsPage extends StatefulWidget {
  const ScreenSettingsPage({super.key});

  @override
  State<ScreenSettingsPage> createState() => _ScreenSettingsPageState();
}

class _ScreenSettingsPageState extends State<ScreenSettingsPage> {
  final _user = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();
  final _adminController = Get.find<AdminController>();
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final model = AppSettingsModel.fromStorage();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Get.theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF14161F)
          : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.5,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 800;
          if (isLargeScreen) {
            return _buildDesktopLayout(model, isDark, primary);
          }
          return _buildMobileLayout(model, isDark, primary);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    AppSettingsModel model,
    bool isDark,
    Color primary,
  ) {
    final borderColor = isDark
        ? Colors.white.withAlpha(10)
        : Colors.grey.shade200;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar Navigation
        Container(
          width: 260,
          margin: const EdgeInsets.fromLTRB(24, 0, 12, 24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E202C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 6),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildSidebarTab(0, "My Profile", Bx.user, primary, isDark),
              _buildSidebarTab(1, "Appearance", Bx.adjust, primary, isDark),
              _buildSidebarTab(2, "Receipts", Bx.receipt, primary, isDark),
              _buildSidebarTab(3, "General & Health", Bx.cog, primary, isDark),
              _buildSidebarTab(
                4,
                "Company & Sync",
                Bx.buildings,
                primary,
                isDark,
              ),
              const Spacer(),
              // Brief Footer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "MistPOS Settings v2.0",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content Area
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 24, 24),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildDesktopContent(model, isDark, primary)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarTab(
    int index,
    String label,
    String icon,
    Color primary,
    bool isDark,
  ) {
    final isSelected = _selectedTabIndex == index;
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.grey.shade300 : Colors.black87);
    final iconColor = isSelected
        ? Colors.white
        : (isDark ? Colors.grey.shade400 : Colors.grey.shade700);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [primary, primary.withAlpha(200)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Iconify(icon, size: 20, color: iconColor),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContent(
    AppSettingsModel model,
    bool isDark,
    Color primary,
  ) {
    switch (_selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              "User Profile",
              "Manage your personal credentials and account details",
            ),
            const SizedBox(height: 16),
            MistMordernLayout(
              label: "User Settings",
              children: [
                ListTile(
                  onTap: () => Get.to(() => ScreenUserProfile()),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "My Profile",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "View and edit your personal profile",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  leading: Iconify(Bx.user, color: AppTheme.color(context)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              "Appearance & Display",
              "Personalize how MistPOS looks and behaves on your device",
            ),
            const SizedBox(height: 16),
            MistMordernLayout(
              label: "Theme Mode Selection",
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Switch(
                    value: model.useSystemDarkMode,
                    onChanged: (c) {
                      model.useSystemDarkMode = c;
                      model.saveToStorage();
                      setState(() {});
                      _changeTheme();
                    },
                  ),
                  leading: Iconify(Bx.adjust, color: AppTheme.color(context)),
                  title: const Text(
                    "System Theme Mode",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Sync dark/light mode with your operating system settings",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    model.darkMode = !model.darkMode;
                    model.saveToStorage();
                    setState(() {});
                    _changeTheme();
                  },
                  enabled: !model.useSystemDarkMode,
                  trailing: Switch(
                    activeThumbColor: !model.useSystemDarkMode
                        ? null
                        : Colors.grey,
                    inactiveThumbColor: !model.useSystemDarkMode
                        ? null
                        : Colors.grey,
                    value: model.darkMode,
                    onChanged: (c) {
                      if (model.useSystemDarkMode) return;
                      model.darkMode = c;
                      model.saveToStorage();
                      setState(() {});
                      _changeTheme();
                    },
                  ),
                  leading: Iconify(
                    Bx.moon,
                    color: !model.useSystemDarkMode
                        ? AppTheme.color(context)
                        : Colors.grey,
                  ),
                  title: const Text(
                    "Enable Dark Mode",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Manually toggle the dark theme on or off",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            MistMordernLayout(
              label: "Catalog Layout Options",
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    model.useGridViewForItems = !model.useGridViewForItems;
                    model.saveToStorage();
                    setState(() {});
                  },
                  trailing: Switch(
                    value: model.useGridViewForItems,
                    onChanged: (c) {
                      model.useGridViewForItems = c;
                      model.saveToStorage();
                      setState(() {});
                    },
                  ),
                  leading: Iconify(Bx.grid, color: AppTheme.color(context)),
                  title: const Text(
                    "Use Grid View for Items",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Toggle between grid and list view for products in the sales screen",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              "Receipts & Invoices",
              "Configure logo, size, and layout styling for printed receipts",
            ),
            const SizedBox(height: 16),
            MistMordernLayout(
              label: "Receipt Layout Properties",
              children: [
                ListTile(
                  onTap: () => _changeSize(model.printerRecietLength),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Printer Receipt Length",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${model.printerRecietLength} units (click to edit)",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  leading: Iconify(Bx.receipt, color: AppTheme.color(context)),
                  trailing: const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    model.enableQrCode = !model.enableQrCode;
                    model.saveToStorage();
                    setState(() {});
                  },
                  trailing: Switch(
                    value: model.enableQrCode,
                    onChanged: (c) {
                      model.enableQrCode = c;
                      model.saveToStorage();
                      setState(() {});
                    },
                  ),
                  leading: Iconify(Bx.qr_scan, color: AppTheme.color(context)),
                  title: const Text(
                    "Print Receipt Qr Code",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Enable automated QR code printing for invoice scanning",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
                const Divider(height: 24),
                ListTile(
                  onTap: _pickImage,
                  title: const Text(
                    "Receipt Logo Image",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  contentPadding: EdgeInsets.zero,
                  leading: Iconify(Bx.camera, color: AppTheme.color(context)),
                  trailing: model.receitLogoPath.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _removeLogo,
                          icon: Iconify(Bx.x, color: Colors.red),
                        ),
                  subtitle: Text(
                    model.receitLogoPath.isEmpty
                        ? "No logo selected"
                        : model.receitLogoPath,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
                if (_user.user.value?.role == 'admin' ||
                    _user.user.value?.role == 'manager') ...[
                  const Divider(height: 24),
                  ListTile(
                    onTap: () => Get.to(() => ScreenReceiptDesigner()),
                    title: const Text(
                      "Receipt Visual Designer",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Customize and design printed slips layout dynamically",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Iconify(
                      Bx.receipt,
                      color: AppTheme.color(context),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              "General & Health",
              "Manage base display units, local options, and system health status",
            ),
            const SizedBox(height: 16),
            MistMordernLayout(
              label: "Numbers Formatting",
              children: [
                ListTile(
                  onTap: () => _changeDecimalPlaces(model.decimalPlaces),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Decimal Places",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${model.decimalPlaces} places (click to edit)",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  leading: Iconify(
                    Bx.font_size,
                    color: AppTheme.color(context),
                  ),
                  trailing: const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(
              () =>
                  MistMordernLayout(
                    label: "Inventory Display",
                    children: [
                      ListTile(
                        trailing: _adminController.companyLoading.value
                            ? const CircularProgressIndicator()
                            : Switch(
                                value:
                                    _invController
                                        .company
                                        .value
                                        ?.showSalesCount ??
                                    false,
                                onChanged: (c) {
                                  _updateCompanyModel(
                                    c,
                                    enableCreditSale:
                                        _invController
                                            .company
                                            .value
                                            ?.enableCreditSale ??
                                        true,
                                    autoApproveAllExpenses:
                                        _invController
                                            .company
                                            .value
                                            ?.autoApproveAllExpenses ??
                                        false,
                                    shiftBasedSales:
                                        _invController
                                            .company
                                            .value
                                            ?.shiftBasedSales ??
                                        false,
                                  );
                                },
                              ),
                        onTap: () => _updateCompanyModel(
                          !(_invController.company.value?.showSalesCount ??
                              false),
                          enableCreditSale:
                              _invController.company.value?.enableCreditSale ??
                              true,
                          autoApproveAllExpenses:
                              _invController
                                  .company
                                  .value
                                  ?.autoApproveAllExpenses ??
                              false,
                          shiftBasedSales:
                              _invController.company.value?.shiftBasedSales ??
                              false,
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Show Sales Item Quantities",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Display remaining stock numbers in real-time on sales screen",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        leading: Iconify(
                          Bx.font_size,
                          color: AppTheme.color(context),
                        ),
                      ),
                    ],
                  ).visibleIf(
                    _user.user.value?.role == 'admin' ||
                        _user.user.value?.role == 'manager',
                  ),
            ),
            const SizedBox(height: 24),
            MistMordernLayout(
              label: "System Status & Client Health",
              children: [
                FutureBuilder(
                  future: getAndroidSdkInt(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return MistLoader1();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    final sdkInt = snapshot.data as int;
                    final isOld = sdkInt < 24;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        isOld
                            ? 'Old HTTP Client Active'
                            : 'New HTTP Client Active',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOld ? Colors.redAccent : Colors.green,
                        ),
                      ),
                      subtitle: Text(
                        "Detected system SDK Level: $sdkInt",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                      leading: Icon(
                        isOld
                            ? Icons.error_outline_rounded
                            : Icons.check_circle_outline_rounded,
                        color: isOld ? Colors.redAccent : Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              "Company & Data Synchronization",
              "Configure operational rules and sync offline database",
            ),
            const SizedBox(height: 16),
            Obx(
              () =>
                  MistMordernLayout(
                    label: "Store Financial Policies",
                    children: [
                      ListTile(
                        trailing: _adminController.companyLoading.value
                            ? const CircularProgressIndicator()
                            : Switch(
                                value:
                                    _invController
                                        .company
                                        .value
                                        ?.enableCreditSale ??
                                    true,
                                onChanged: (c) {
                                  _updateCompanyModel(
                                    _invController
                                            .company
                                            .value
                                            ?.showSalesCount ??
                                        false,
                                    enableCreditSale: c,
                                    autoApproveAllExpenses:
                                        _invController
                                            .company
                                            .value
                                            ?.autoApproveAllExpenses ??
                                        false,
                                    shiftBasedSales:
                                        _invController
                                            .company
                                            .value
                                            ?.shiftBasedSales ??
                                        false,
                                  );
                                },
                              ),
                        onTap: () => _updateCompanyModel(
                          _invController.company.value?.showSalesCount ?? false,
                          enableCreditSale:
                              !(_invController
                                      .company
                                      .value
                                      ?.enableCreditSale ??
                                  true),
                          autoApproveAllExpenses:
                              _invController
                                  .company
                                  .value
                                  ?.autoApproveAllExpenses ??
                              false,
                          shiftBasedSales:
                              _invController.company.value?.shiftBasedSales ??
                              false,
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Enable Credit Sale",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Allow registers/cashiers to process sales with pending balances",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        leading: Iconify(
                          Bx.credit_card,
                          color: AppTheme.color(context),
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        trailing: _adminController.companyLoading.value
                            ? const CircularProgressIndicator()
                            : Switch(
                                value:
                                    _invController
                                        .company
                                        .value
                                        ?.autoApproveAllExpenses ??
                                    true,
                                onChanged: (c) {
                                  _updateCompanyModel(
                                    _invController
                                            .company
                                            .value
                                            ?.showSalesCount ??
                                        false,
                                    enableCreditSale:
                                        _invController
                                            .company
                                            .value
                                            ?.enableCreditSale ??
                                        true,
                                    autoApproveAllExpenses: c,
                                    shiftBasedSales:
                                        _invController
                                            .company
                                            .value
                                            ?.shiftBasedSales ??
                                        false,
                                  );
                                },
                              ),
                        onTap: () => _updateCompanyModel(
                          _invController.company.value?.showSalesCount ?? false,
                          enableCreditSale:
                              _invController.company.value?.enableCreditSale ??
                              true,
                          autoApproveAllExpenses:
                              !(_invController
                                      .company
                                      .value
                                      ?.autoApproveAllExpenses ??
                                  true),
                          shiftBasedSales:
                              _invController.company.value?.shiftBasedSales ??
                              false,
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Auto-Approve All Expenses",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Process newly logged store expenses immediately without audit approval",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        leading: Iconify(
                          Bx.wallet,
                          color: AppTheme.color(context),
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        trailing: _adminController.companyLoading.value
                            ? const CircularProgressIndicator()
                            : Switch(
                                value:
                                    _invController
                                        .company
                                        .value
                                        ?.shiftBasedSales ??
                                    false,
                                onChanged: (c) {
                                  _updateCompanyModel(
                                    _invController
                                            .company
                                            .value
                                            ?.showSalesCount ??
                                        false,
                                    enableCreditSale:
                                        _invController
                                            .company
                                            .value
                                            ?.enableCreditSale ??
                                        true,
                                    autoApproveAllExpenses:
                                        _invController
                                            .company
                                            .value
                                            ?.autoApproveAllExpenses ??
                                        false,
                                    shiftBasedSales: c,
                                  );
                                },
                              ),
                        onTap: () => _updateCompanyModel(
                          _invController.company.value?.showSalesCount ?? false,
                          enableCreditSale:
                              _invController.company.value?.enableCreditSale ??
                              true,
                          autoApproveAllExpenses:
                              _invController
                                  .company
                                  .value
                                  ?.autoApproveAllExpenses ??
                              false,
                          shiftBasedSales:
                              !(_invController.company.value?.shiftBasedSales ??
                                  false),
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Enable Shift Based Sales",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Force cashiers to open an active session before processing invoices",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        leading: Iconify(
                          Bx.time,
                          color: AppTheme.color(context),
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        subtitle: Text(
                          "Configure and schedule daily WhatsApp digest reports",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          if (_invController.company.value != null) {
                            Get.to(
                              () => AutomatedSyncScreen(
                                company: _invController.company.value!,
                              ),
                            );
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "WhatsApp Reports Integration",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Iconify(
                          Bx.bxl_whatsapp,
                          color: AppTheme.color(context),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ).visibleIf(
                    _user.user.value?.role == 'admin' ||
                        _user.user.value?.role == 'manager',
                  ),
            ),
            const SizedBox(height: 24),
            MistMordernLayout(
              label: "Database & Synchronization",
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Get.defaultDialog(
                      title: "Force Sync Database",
                      content: const Text(
                        "This will clear your local cache and download all items, categories, and settings from the server. Are you sure?",
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            if (Get.isRegistered<ItemsController>()) {
                              Get.find<ItemsController>().clearAndResyncData();
                              Toaster.showSuccess(
                                "Cache cleared. Syncing started in background.",
                              );
                            } else {
                              Toaster.showError(
                                "Failed to access items controller.",
                              );
                            }
                          },
                          child: const Text(
                            "Sync Now",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                  leading: Iconify(
                    Bx.cloud_download,
                    color: AppTheme.color(context),
                  ),
                  title: const Text(
                    "Force Sync / Clear Offline Cache",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Wipe local state and pull fresh inventories data",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMobileLayout(
    AppSettingsModel model,
    bool isDark,
    Color primary,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        MistMordernLayout(
          label: "User",
          children: [
            ListTile(
              onTap: () => Get.to(() => ScreenUserProfile()),
              contentPadding: EdgeInsets.zero,
              title: const Text("My Profile"),
              subtitle: "view your profile".text(
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              leading: Iconify(Bx.user, color: AppTheme.color(context)),
            ),
          ],
        ),
        24.gapColumn,
        MistMordernLayout(
          label: "Theme Settings",
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              trailing: Switch(
                value: model.useSystemDarkMode,
                onChanged: (c) {
                  model.useSystemDarkMode = c;
                  model.saveToStorage();
                  setState(() {});
                  _changeTheme();
                },
              ),
              leading: Iconify(Bx.adjust, color: AppTheme.color(context)),
              title: "System Theme Mode".text(),
              subtitle: "select type of theme mode you want".text(
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                model.darkMode = !model.darkMode;
                model.saveToStorage();
                setState(() {});
                _changeTheme();
              },
              enabled: !model.useSystemDarkMode,
              trailing: Switch(
                activeThumbColor: !model.useSystemDarkMode ? null : Colors.grey,
                inactiveThumbColor: !model.useSystemDarkMode
                    ? null
                    : Colors.grey,
                value: model.darkMode,
                onChanged: (c) {
                  if (model.useSystemDarkMode) return;
                  model.darkMode = c;
                  model.saveToStorage();
                  setState(() {});
                  _changeTheme();
                },
              ),
              leading: Iconify(
                Bx.moon,
                color: !model.useSystemDarkMode
                    ? AppTheme.color(context)
                    : Colors.grey,
              ),
              title: "Enable dark mode".text(),
            ),
          ],
        ),
        24.gapColumn,
        MistMordernLayout(
          label: "Receipts",
          children: [
            ListTile(
              onTap: () => _changeSize(model.printerRecietLength),
              contentPadding: EdgeInsets.zero,
              title: const Text("Printer Receipt Length"),
              subtitle: "${model.printerRecietLength} units".text(
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              leading: Iconify(Bx.receipt, color: AppTheme.color(context)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                model.enableQrCode = !model.enableQrCode;
                model.saveToStorage();
                setState(() {});
              },
              trailing: Switch(
                value: model.enableQrCode,
                onChanged: (c) {
                  model.enableQrCode = c;
                  model.saveToStorage();
                  setState(() {});
                },
              ),
              leading: Iconify(Bx.qr_scan, color: AppTheme.color(context)),
              title: "Print Receipt Qr Code".text(),
              subtitle: "enable qrcode scanning of receipts".text(
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            ListTile(
              onTap: _pickImage,
              title: "Receipt Logo".text(),
              contentPadding: EdgeInsets.zero,
              leading: Iconify(Bx.camera, color: AppTheme.color(context)),
              trailing: model.receitLogoPath.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _removeLogo,
                      icon: Iconify(Bx.x, color: Colors.red),
                    ),
              subtitle:
                  (model.receitLogoPath.isEmpty
                          ? "not selected"
                          : model.receitLogoPath)
                      .text(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
            ),
            ListTile(
              onTap: () => Get.to(() => ScreenReceiptDesigner()),
              title: "Receipt Design".text(),
              contentPadding: EdgeInsets.zero,
              leading: Iconify(Bx.receipt, color: AppTheme.color(context)),
            ).visibleIf(
              _user.user.value?.role == 'admin' ||
                  _user.user.value?.role == 'manager',
            ),
          ],
        ),
        24.gapColumn,
        MistMordernLayout(
          label: "Numbers",
          children: [
            ListTile(
              onTap: () => _changeDecimalPlaces(model.decimalPlaces),
              contentPadding: EdgeInsets.zero,
              title: const Text("Decimal Places"),
              subtitle: "${model.decimalPlaces} places".text(
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              leading: Iconify(Bx.font_size, color: AppTheme.color(context)),
            ),
          ],
        ),
        Obx(
          () => 24.gapColumn.visibleIf(
            _user.user.value?.role == 'admin' ||
                _user.user.value?.role == 'manager',
          ),
        ),
        Obx(
          () =>
              MistMordernLayout(
                label: "Item",
                children: [
                  ListTile(
                    trailing: Obx(
                      () => _adminController.companyLoading.value
                          ? const CircularProgressIndicator()
                          : Switch(
                              value:
                                  _invController
                                      .company
                                      .value
                                      ?.showSalesCount ??
                                  false,
                              onChanged: (c) {
                                _updateCompanyModel(
                                  c,
                                  enableCreditSale:
                                      _invController
                                          .company
                                          .value
                                          ?.enableCreditSale ??
                                      true,
                                  autoApproveAllExpenses:
                                      _invController
                                          .company
                                          .value
                                          ?.autoApproveAllExpenses ??
                                      false,
                                  shiftBasedSales:
                                      _invController
                                          .company
                                          .value
                                          ?.shiftBasedSales ??
                                      false,
                                );
                              },
                            ),
                    ),
                    onTap: () => _updateCompanyModel(
                      !(_invController.company.value?.showSalesCount ?? false),
                      enableCreditSale:
                          _invController.company.value?.enableCreditSale ??
                          true,
                      autoApproveAllExpenses:
                          _invController
                              .company
                              .value
                              ?.autoApproveAllExpenses ??
                          false,
                      shiftBasedSales:
                          _invController.company.value?.shiftBasedSales ??
                          false,
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Show Sales Item Quantities"),
                    subtitle: "show quantities of items left in sales screen"
                        .text(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    leading: Iconify(
                      Bx.font_size,
                      color: AppTheme.color(context),
                    ),
                  ),
                ],
              ).visibleIf(
                _user.user.value?.role == 'admin' ||
                    _user.user.value?.role == 'manager',
              ),
        ),
        24.gapColumn,
        MistMordernLayout(
          label: "Display Settings",
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                model.useGridViewForItems = !model.useGridViewForItems;
                model.saveToStorage();
                setState(() {});
              },
              trailing: Switch(
                value: model.useGridViewForItems,
                onChanged: (c) {
                  model.useGridViewForItems = c;
                  model.saveToStorage();
                  setState(() {});
                },
              ),
              leading: Iconify(Bx.grid, color: AppTheme.color(context)),
              title: "Use Grid View for Items".text(),
              subtitle:
                  "Toggle between grid and list view for products in sales screen"
                      .text(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
            ),
          ],
        ),
        24.gapColumn,
        MistMordernLayout(
          label: "Data & Synchronization",
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Get.defaultDialog(
                  title: "Force Sync",
                  content:
                      "This will clear your local offline cache and download all items, categories, and settings from the server. Are you sure?"
                          .text(textAlign: TextAlign.center),
                  actions: [
                    "Cancel".text().textButton(onPressed: () => Get.back()),
                    "Sync Now".text().textButton(
                      onPressed: () {
                        Get.back();
                        if (Get.isRegistered<ItemsController>()) {
                          Get.find<ItemsController>().clearAndResyncData();
                          Toaster.showSuccess(
                            "Cache cleared. Syncing started in background.",
                          );
                        } else {
                          Toaster.showError(
                            "Failed to access items controller.",
                          );
                        }
                      },
                    ),
                  ],
                );
              },
              leading: Iconify(
                Bx.cloud_download,
                color: AppTheme.color(context),
              ),
              title: "Force Sync / Clear Cache".text(),
              subtitle:
                  "Manually clear offline cache and re-download store data"
                      .text(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
            ),
          ],
        ),
        24.gapColumn,
        Obx(
          () =>
              MistMordernLayout(
                label: "Company",
                children: [
                  ListTile(
                    trailing: Obx(
                      () => _adminController.companyLoading.value
                          ? const CircularProgressIndicator()
                          : Switch(
                              value:
                                  _invController
                                      .company
                                      .value
                                      ?.enableCreditSale ??
                                  true,
                              onChanged: (c) {
                                _updateCompanyModel(
                                  _invController
                                          .company
                                          .value
                                          ?.showSalesCount ??
                                      false,
                                  enableCreditSale: c,
                                  autoApproveAllExpenses:
                                      _invController
                                          .company
                                          .value
                                          ?.autoApproveAllExpenses ??
                                      false,
                                  shiftBasedSales:
                                      _invController
                                          .company
                                          .value
                                          ?.shiftBasedSales ??
                                      false,
                                );
                              },
                            ),
                    ),
                    onTap: () => _updateCompanyModel(
                      _invController.company.value?.showSalesCount ?? false,
                      enableCreditSale:
                          !(_invController.company.value?.enableCreditSale ??
                              true),
                      autoApproveAllExpenses:
                          _invController
                              .company
                              .value
                              ?.autoApproveAllExpenses ??
                          false,
                      shiftBasedSales:
                          _invController.company.value?.shiftBasedSales ??
                          false,
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: "Enable Credit Sale".text(),
                    subtitle: "enable cashiers to sell on credit".text(
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    leading: Iconify(
                      Bx.credit_card,
                      color: AppTheme.color(context),
                    ),
                  ),
                  ListTile(
                    trailing: Obx(
                      () => _adminController.companyLoading.value
                          ? const CircularProgressIndicator()
                          : Switch(
                              value:
                                  _invController
                                      .company
                                      .value
                                      ?.autoApproveAllExpenses ??
                                  true,
                              onChanged: (c) {
                                _updateCompanyModel(
                                  _invController
                                          .company
                                          .value
                                          ?.showSalesCount ??
                                      false,
                                  enableCreditSale:
                                      _invController
                                          .company
                                          .value
                                          ?.enableCreditSale ??
                                      true,
                                  autoApproveAllExpenses: c,
                                  shiftBasedSales:
                                      _invController
                                          .company
                                          .value
                                          ?.shiftBasedSales ??
                                      false,
                                );
                              },
                            ),
                    ),
                    onTap: () => _updateCompanyModel(
                      _invController.company.value?.showSalesCount ?? false,
                      enableCreditSale:
                          _invController.company.value?.enableCreditSale ??
                          true,
                      autoApproveAllExpenses:
                          !(_invController
                                  .company
                                  .value
                                  ?.autoApproveAllExpenses ??
                              true),
                      shiftBasedSales:
                          _invController.company.value?.shiftBasedSales ??
                          false,
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: "AutoApprove All Expenses".text(),
                    subtitle: "enable expenses to be added without approval"
                        .text(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    leading: Iconify(
                      Bx.credit_card,
                      color: AppTheme.color(context),
                    ),
                  ),
                  ListTile(
                    trailing: Obx(
                      () => _adminController.companyLoading.value
                          ? const CircularProgressIndicator()
                          : Switch(
                              value:
                                  _invController
                                      .company
                                      .value
                                      ?.shiftBasedSales ??
                                  false,
                              onChanged: (c) {
                                _updateCompanyModel(
                                  _invController
                                          .company
                                          .value
                                          ?.showSalesCount ??
                                      false,
                                  enableCreditSale:
                                      _invController
                                          .company
                                          .value
                                          ?.enableCreditSale ??
                                      true,
                                  autoApproveAllExpenses:
                                      _invController
                                          .company
                                          .value
                                          ?.autoApproveAllExpenses ??
                                      false,
                                  shiftBasedSales: c,
                                );
                              },
                            ),
                    ),
                    onTap: () => _updateCompanyModel(
                      _invController.company.value?.showSalesCount ?? false,
                      enableCreditSale:
                          _invController.company.value?.enableCreditSale ??
                          true,
                      autoApproveAllExpenses:
                          _invController
                              .company
                              .value
                              ?.autoApproveAllExpenses ??
                          false,
                      shiftBasedSales:
                          !(_invController.company.value?.shiftBasedSales ??
                              false),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: "Enable Shift Based Sales".text(),
                    subtitle: "enforce opening shifts to sell items".text(
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    leading: Iconify(Bx.time, color: AppTheme.color(context)),
                  ),
                  ListTile(
                    subtitle: "send daily reports to whatsapp".text(
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () => {
                      Get.to(
                        () => AutomatedSyncScreen(
                          company: _invController.company.value!,
                        ),
                      ),
                    },
                    title: "Whatsapp reports".text(),
                    leading: Iconify(
                      Bx.bxl_whatsapp,
                      color: AppTheme.color(context),
                    ),
                  ),
                ],
              ).visibleIf(
                _user.user.value?.role == 'admin' ||
                    _user.user.value?.role == 'manager',
              ),
        ),
        24.gapColumn,
        MistMordernLayout(
          label: "Heath Status",
          children: [
            FutureBuilder(
              future: getAndroidSdkInt(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MistLoader1();
                }
                if (snapshot.hasError) {
                  return "Error : ${snapshot.error}".text();
                }
                final sdkInt = snapshot.data as int;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  textColor: sdkInt < 24 ? Colors.red : Colors.green,
                  title: sdkInt < 24
                      ? 'Old Http Client'.text()
                      : 'New Http Client'.text(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _changeTheme() {
    final model = AppSettingsModel.fromStorage();
    if (model.useSystemDarkMode) {
      Get.changeThemeMode(ThemeMode.system);
      return;
    }
    Get.changeThemeMode(model.darkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void _changeSize(int size) {
    final model = AppSettingsModel.fromStorage();
    final sizeController = TextEditingController(text: size.toString());
    Get.defaultDialog(
      title: "Printer Receipt Length",
      content: MistFormInput(
        label: "size",
        controller: sizeController,
        isNumberInput: true,
      ),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "save".text().textButton(
          onPressed: () {
            if (sizeController.text.trim().isEmpty) {
              Toaster.showError("Size is required");
              return;
            }
            int? value = int.tryParse(sizeController.text.trim());
            if (value == null) {
              Toaster.showError("invalid number input");
              return;
            }
            model.printerRecietLength = value;
            model.saveToStorage();
            Get.back();
            setState(() {});
          },
        ),
      ],
    );
  }

  void _changeDecimalPlaces(int size) {
    final decimalPlacesController = TextEditingController(
      text: size.toString(),
    );
    final model = AppSettingsModel.fromStorage();

    Get.defaultDialog(
      title: "Decimal Places",
      content: MistFormInput(
        label: "size",
        controller: decimalPlacesController,
        isNumberInput: true,
      ),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "save".text().textButton(
          onPressed: () {
            if (decimalPlacesController.text.trim().isEmpty) {
              Toaster.showError("Size is required");
              return;
            }
            int? value = int.tryParse(decimalPlacesController.text.trim());
            if (value == null) {
              Toaster.showError("invalid number input");
              return;
            }
            Get.back();
            model.decimalPlaces = value;
            model.saveToStorage();
            setState(() {});
          },
        ),
      ],
    );
  }

  void _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final model = AppSettingsModel.fromStorage();
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String fileName = 'receit_logo.jpg';
      final String localPath = p.join(appDocPath, fileName);
      final File localImage = await File(image.path).copy(localPath);
      model.receitLogoPath = localImage.path;
      model.saveToStorage();
      setState(() {});
    } catch (e) {
      Toaster.showError("Error : $e");
    }
  }

  void _removeLogo() {
    Get.defaultDialog(
      title: "Remove Logo",
      content: "Are you sure to remove the receit logo".text(),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "remove".text().textButton(
          onPressed: () {
            final model = AppSettingsModel.fromStorage();
            try {
              File(model.receitLogoPath).deleteSync();
            } catch (_) {}
            model.receitLogoPath = "";
            model.saveToStorage();
            setState(() {});
            Get.back();
          },
        ),
      ],
    );
  }

  void _updateCompanyModel(
    bool bool, {
    required bool enableCreditSale,
    required bool autoApproveAllExpenses,
    required bool shiftBasedSales,
  }) async {
    final company = _invController.company.value;
    if (company == null) {
      Toaster.showError("Failed to initialize , company not found");
      return;
    }
    company.showSalesCount = bool;
    company.enableCreditSale = enableCreditSale;
    company.autoApproveAllExpenses = autoApproveAllExpenses;
    company.shiftBasedSales = shiftBasedSales;
    final response = await _adminController.updateCompany(
      company.toJson(),
      company.hexId,
    );
    if (response) {
      _invController.company.value = company;
      _invController.company.refresh();
      company.saveToStorage();
      Toaster.showSuccess('status updated ');
    }
  }
}
