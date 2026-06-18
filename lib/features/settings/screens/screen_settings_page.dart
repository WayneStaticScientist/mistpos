import 'dart:io';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:mistpos/features/settings/screens_gateways/automated_screen.dart';
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

class ScreenSettingsPage extends StatefulWidget {
  const ScreenSettingsPage({super.key});

  @override
  State<ScreenSettingsPage> createState() => _ScreenSettingsPageState();
}

class _ScreenSettingsPageState extends State<ScreenSettingsPage> {
  final _user = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();
  final _adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    final model = AppSettingsModel.fromStorage();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          24.gapColumn,
          MistMordernLayout(
            label: "User",
            children: [
              ListTile(
                onTap: () => Get.to(() => ScreenUserProfile()),
                contentPadding: EdgeInsets.all(0),
                title: Text("My Profile"),
                subtitle: "view your profile".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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
                contentPadding: EdgeInsets.all(0),
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
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
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
                contentPadding: EdgeInsets.all(0),
                title: Text("Printer Receipt Length"),
                subtitle: "${model.printerRecietLength} units".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                leading: Iconify(Bx.receipt, color: AppTheme.color(context)),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
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
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              ListTile(
                onTap: _pickImage,
                title: "Receipt Logo".text(),
                contentPadding: EdgeInsets.all(0),
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
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
              ),
              ListTile(
                onTap: () => Get.to(() => ScreenReceiptDesigner()),
                title: "Receipt Design".text(),
                contentPadding: EdgeInsets.all(0),
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
                contentPadding: EdgeInsets.all(0),
                title: Text("Decimal Places"),
                subtitle: "${model.decimalPlaces} places".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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
                            ? CircularProgressIndicator()
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
                      contentPadding: EdgeInsets.all(0),
                      title: Text("Show Sales Item Quantitiess"),
                      subtitle: "show quantities of items left in sales screen"
                          .text(
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                contentPadding: EdgeInsets.all(0),
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
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
              ),
            ],
          ),
          24.gapColumn,
          MistMordernLayout(
            label: "Data & Synchronization",
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
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
                          style: TextStyle(color: Colors.grey, fontSize: 12),
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
                            ? CircularProgressIndicator()
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
                            (_invController
                                .company
                                .value
                                ?.autoApproveAllExpenses ??
                            false),
                        shiftBasedSales:
                            _invController.company.value?.shiftBasedSales ??
                            false,
                      ),
                      contentPadding: EdgeInsets.all(0),
                      title: "Enable Credit Sale".text(),
                      subtitle: "enable cashiers to sell on credit".text(
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      leading: Iconify(
                        Bx.credit_card,
                        color: AppTheme.color(context),
                      ),
                    ),
                    ListTile(
                      trailing: Obx(
                        () => _adminController.companyLoading.value
                            ? CircularProgressIndicator()
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
                                        (_invController
                                            .company
                                            .value
                                            ?.enableCreditSale ??
                                        true),
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
                            (_invController.company.value?.enableCreditSale ??
                            true),
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
                      contentPadding: EdgeInsets.all(0),
                      title: "AutoApprove All Expenses".text(),
                      subtitle: "enable expenses to be added without approval"
                          .text(
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                      leading: Iconify(
                        Bx.credit_card,
                        color: AppTheme.color(context),
                      ),
                    ),
                    ListTile(
                      trailing: Obx(
                        () => _adminController.companyLoading.value
                            ? CircularProgressIndicator()
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
                                        (_invController
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
                                    shiftBasedSales: c,
                                  );
                                },
                              ),
                      ),
                      onTap: () => _updateCompanyModel(
                        _invController.company.value?.showSalesCount ?? false,
                        enableCreditSale:
                            (_invController.company.value?.enableCreditSale ??
                            true),
                        autoApproveAllExpenses:
                            (_invController
                                .company
                                .value
                                ?.autoApproveAllExpenses ??
                            false),
                        shiftBasedSales:
                            !(_invController.company.value?.shiftBasedSales ??
                                false),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      title: "Enable Shift Based Sales".text(),
                      subtitle: "enforce opening shifts to sell items".text(
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      leading: Iconify(Bx.time, color: AppTheme.color(context)),
                    ),
                    ListTile(
                      subtitle: "send daily reports to whatsapp".text(
                        style: TextStyle(color: Colors.grey, fontSize: 12),
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
                builder: (context, snapnshot) {
                  if (snapnshot.connectionState == ConnectionState.waiting) {
                    return MistLoader1();
                  }
                  if (snapnshot.hasError) {
                    return "Error : ${snapnshot.error}".text();
                  }
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    textColor: snapnshot.data! < 24 ? Colors.red : Colors.green,
                    title: snapnshot.data! < 24
                        ? 'Old Http Client'.text()
                        : 'New Http Client'.text(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
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
