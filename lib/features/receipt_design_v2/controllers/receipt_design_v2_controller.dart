import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/utils/mist_esc_pos_builder.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import '../data/default_v2_templates.dart';
import '../engine/receipt_template_engine.dart';
import '../models/receipt_template_v2_model.dart';

class ReceiptDesignV2Controller extends GetxController {
  final GetStorage _box = GetStorage();

  late Rx<ReceiptTemplateV2Model> activeTemplate;
  final RxList<ReceiptTemplateV2Model> localTemplates =
      <ReceiptTemplateV2Model>[].obs;
  final RxList<ReceiptTemplateV2Model> cloudTemplates =
      <ReceiptTemplateV2Model>[].obs;

  final RxBool isLoadingCloud = false.obs;
  final RxBool isPublishing = false.obs;
  final RxBool isSaving = false.obs;
  final RxString selectedCategory = 'all'.obs;
  final RxString cloudSearchQuery = ''.obs;

  // Pagination for cloud community templates
  final RxInt cloudPage = 1.obs;
  final RxBool hasMoreCloud = true.obs;
  final RxBool isLoadingMoreCloud = false.obs;
  final RxInt totalCloudCount = 0.obs;
  final int cloudPageLimit = 10;

  // Visual animation feedback for template activation & downloading
  final RxnString justActivatedTemplateId = RxnString();
  final RxnString applyingTemplateId = RxnString();
  final RxnString downloadingTemplateId = RxnString();

  bool isTemplateActive(ReceiptTemplateV2Model t) {
    final active = activeTemplate.value;
    if (active.id == t.id) return true;
    return active.name.trim().toLowerCase() == t.name.trim().toLowerCase();
  }

  @override
  void onInit() {
    super.onInit();
    _loadTemplates();
    fetchCompanyReceiptDesignFromServer();
  }

  /// Apply a remote company receiptDesignV2 map from server to local storage & controller
  static void applyRemoteReceiptDesignMap(Map<String, dynamic>? designMap) {
    if (designMap == null) return;
    final rawContent = designMap['templateContent']?.toString().trim() ?? '';
    if (rawContent.isEmpty) return;

    try {
      final box = GetStorage();
      final mapCopy = Map<String, dynamic>.from(designMap);
      if ((mapCopy['id'] == null || mapCopy['id'].toString().trim().isEmpty) &&
          mapCopy['name'] != null) {
        final nameLower = mapCopy['name'].toString().toLowerCase();
        if (nameLower.contains('zimra')) {
          mapCopy['id'] = 'preset_zimra_fiscal';
        } else if (nameLower.contains('modern')) {
          mapCopy['id'] = 'preset_modern_retail';
        } else if (nameLower.contains('grocery') ||
            nameLower.contains('supermarket')) {
          mapCopy['id'] = 'preset_express_grocery';
        } else if (nameLower.contains('cafe') || nameLower.contains('bistro')) {
          mapCopy['id'] = 'preset_cafe_bistro';
        } else if (nameLower.contains('compact') ||
            nameLower.contains('58mm')) {
          mapCopy['id'] = 'preset_compact_minimal';
        }
      }

      final parsed = ReceiptTemplateV2Model.fromJson(mapCopy);
      if (parsed.blocks.isEmpty && parsed.templateContent.trim().isNotEmpty) {
        parsed.syncBlocksFromMarkup(parsed.templateContent);
      }
      box.write('active_receipt_template_v2', parsed.toJson());

      final appSettings = AppSettingsModel.fromStorage();
      if (designMap['enabled'] is bool) {
        appSettings.useReceiptDesignV2 = designMap['enabled'] as bool;
      }
      if (parsed.paperWidth >= 16) {
        appSettings.printerRecietLength = parsed.paperWidth;
      }
      appSettings.saveToStorage();

      if (Get.isRegistered<ReceiptDesignV2Controller>()) {
        final ctrl = Get.find<ReceiptDesignV2Controller>();
        final sanitized = ctrl.sanitizeTemplateModel(parsed);
        ctrl.activeTemplate.value = sanitized;
        final idx = ctrl.localTemplates.indexWhere(
          (t) =>
              t.id == sanitized.id ||
              t.name.trim().toLowerCase() ==
                  sanitized.name.trim().toLowerCase(),
        );
        if (idx != -1) {
          ctrl.localTemplates[idx] = sanitized.copyWith();
        } else {
          ctrl.localTemplates.add(sanitized.copyWith());
        }
        ctrl.localTemplates.refresh();
        ctrl._persistCustomLocalTemplates();
        ctrl.activeTemplate.refresh();
      }
    } catch (e) {
      debugPrint("Failed to apply remote receiptDesignV2: $e");
    }
  }

  /// Fetch company's saved Receipt Design V2 from server so all devices stay in sync
  Future<void> fetchCompanyReceiptDesignFromServer() async {
    try {
      final response = await Net.get("/admin/company/receipt-design-v2");
      if (!response.hasError &&
          response.body is Map &&
          response.body['receiptDesignV2'] is Map) {
        applyRemoteReceiptDesignMap(
          Map<String, dynamic>.from(response.body['receiptDesignV2']),
        );
        return;
      }
      final companyRes = await Net.get("/company");
      if (!companyRes.hasError &&
          companyRes.body is Map &&
          companyRes.body['update'] is Map &&
          companyRes.body['update']['receiptDesignV2'] is Map) {
        applyRemoteReceiptDesignMap(
          Map<String, dynamic>.from(
            companyRes.body['update']['receiptDesignV2'],
          ),
        );
      }
    } catch (e) {
      debugPrint("Failed to fetch company receipt design v2 from server: $e");
    }
  }

  ReceiptTemplateV2Model sanitizeTemplateModel(ReceiptTemplateV2Model t) {
    if (t.name.toLowerCase().contains('stargiven') ||
        t.id.toLowerCase().contains('stargiven') ||
        t.description.toLowerCase().contains('stargiven')) {
      t.name = t.name
          .replaceAll(
            RegExp(
              r'stargiven(\s+enterprises)?(\s+style)?',
              caseSensitive: false,
            ),
            'Standard',
          )
          .trim();
      t.id = t.id.replaceAll('stargiven', 'standard');
      t.description = t.description.replaceAll(
        RegExp(r'stargiven(\s+enterprises)?(\s+style)?', caseSensitive: false),
        'retail enterprises',
      );
      t.tags = t.tags
          .where((tag) => !tag.toLowerCase().contains('stargiven'))
          .toList();
      if (!t.tags.contains('standard')) t.tags.add('standard');
    }
    return t;
  }

  void _loadTemplates() {
    // 1. Load presets
    final presets = DefaultV2Templates.allPresets;

    // 2. Load custom local saved templates from storage
    final savedJsonList = _box.read<List>('custom_receipt_templates_v2');
    final customLocal = <ReceiptTemplateV2Model>[];
    if (savedJsonList != null) {
      for (final item in savedJsonList) {
        try {
          if (item is Map) {
            final t = sanitizeTemplateModel(
              ReceiptTemplateV2Model.fromJson(Map<String, dynamic>.from(item)),
            );
            customLocal.add(t);
          }
        } catch (e) {
          debugPrint("Failed to parse custom local template: $e");
        }
      }
      _box.write(
        'custom_receipt_templates_v2',
        customLocal.map((e) => e.toJson()).toList(),
      );
    }

    localTemplates.assignAll([...presets, ...customLocal]);

    // 3. Load active template from storage or fallback to ZIMRA Fiscal
    final activeJson = _box.read<Map>('active_receipt_template_v2');
    if (activeJson != null) {
      try {
        final parsed = ReceiptTemplateV2Model.fromJson(
          Map<String, dynamic>.from(activeJson),
        );

        // Sanitize legacy preset ID and name if it contained Stargiven
        if (parsed.id == 'preset_stargiven_fiscal' ||
            parsed.name.contains('Stargiven')) {
          parsed.id = 'preset_zimra_fiscal';
          parsed.name = 'ZIMRA Fiscal Thermal (Standard)';
          parsed.tags = ['zimra', 'fiscal', 'standard', 'retail', 'zimbabwe'];
        }

        // Pre-migrate any older spaced presets to {item_header} and {item_row}
        var content = parsed.templateContent;
        if (content.contains(
              'ITEM                 QTY     PRICE       TOTAL',
            ) ||
            content.contains('{itemname}\n                     {itemcount}')) {
          content = content
              .replaceAll(
                'ITEM                 QTY     PRICE       TOTAL',
                '{item_header}',
              )
              .replaceAll(
                '{itemname}\n                     {itemcount}     {itemprice}      {itemtotal}',
                '{item_row}',
              );
          parsed.templateContent = content;
        }

        activeTemplate = parsed.obs;
        _box.write('active_receipt_template_v2', parsed.toJson());

        // Also reflect the user's saved edits in localTemplates list
        final idx = localTemplates.indexWhere((p) => p.id == parsed.id);
        if (idx != -1) {
          localTemplates[idx] = parsed;
        }
      } catch (e) {
        activeTemplate = DefaultV2Templates.zimraFiscal.obs;
      }
    } else {
      activeTemplate = DefaultV2Templates.zimraFiscal.obs;
    }
  }

  /// Set and persist active template with animation and haptic feedback
  Future<void> setActiveTemplate(ReceiptTemplateV2Model template) async {
    applyingTemplateId.value = template.id;
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 260));

    final updated = template.copyWith();
    if (updated.blocks.isEmpty && updated.templateContent.trim().isNotEmpty) {
      updated.syncBlocksFromMarkup(updated.templateContent);
    }

    activeTemplate.value = updated;
    applyingTemplateId.value = null;
    justActivatedTemplateId.value = template.id;

    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    activeTemplate.refresh();
    localTemplates.refresh();
    cloudTemplates.refresh();
    syncActiveTemplateToCompanyServer();
    Toaster.showSuccess("✓ Active template set to '${template.name}'");

    // Clear the active pulse animation after 2.5s
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (justActivatedTemplateId.value == template.id) {
        justActivatedTemplateId.value = null;
      }
    });
  }

  /// Persist current active template locally and sync to company server
  Future<void> saveActiveTemplate() async {
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    final idx = localTemplates.indexWhere(
      (t) => t.id == activeTemplate.value.id,
    );
    if (idx != -1) {
      localTemplates[idx] = activeTemplate.value.copyWith();
      _persistCustomLocalTemplates();
    }
    await syncActiveTemplateToCompanyServer();
  }

  /// Save current active template as a new local custom template
  void saveCurrentAsCustom(String name, {String description = ''}) {
    final newId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final customTemplate = activeTemplate.value.copyWith(
      id: newId,
      name: name.trim().isNotEmpty
          ? name.trim()
          : "Custom ${DateTime.now().hour}:${DateTime.now().minute}",
      description: description,
      isCloud: false,
    );

    // Save to list
    localTemplates.add(customTemplate);
    _persistCustomLocalTemplates();
    Toaster.showSuccess("Saved '${customTemplate.name}' to Local Templates!");
  }

  void deleteLocalTemplate(ReceiptTemplateV2Model template) {
    if (template.id.startsWith('preset_')) {
      Toaster.showError("Pre-built system templates cannot be deleted");
      return;
    }
    localTemplates.removeWhere((t) => t.id == template.id);
    _persistCustomLocalTemplates();
    if (activeTemplate.value.id == template.id) {
      setActiveTemplate(DefaultV2Templates.zimraFiscal);
    }
    Toaster.showSuccess("Template deleted locally from device");
  }

  void _persistCustomLocalTemplates() {
    final customList = localTemplates
        .where((t) => !t.id.startsWith('preset_'))
        .map((t) => t.toJson())
        .toList();
    _box.write('custom_receipt_templates_v2', customList);
  }

  /// Update raw template content in active template and synchronize blocks
  void updateActiveTemplateContent(String markup) {
    activeTemplate.update((val) {
      if (val != null) {
        val.templateContent = markup;
        val.syncBlocksFromMarkup(markup);
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    final idx = localTemplates.indexWhere(
      (t) => t.id == activeTemplate.value.id,
    );
    if (idx != -1) {
      localTemplates[idx] = activeTemplate.value.copyWith();
      _persistCustomLocalTemplates();
    }
    activeTemplate.refresh();
  }

  /// Bidirectional sync: sync structured visual blocks from raw markup
  void syncBlocksFromMarkup(String markup) {
    activeTemplate.update((val) {
      if (val != null) {
        val.syncBlocksFromMarkup(markup);
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    final idx = localTemplates.indexWhere(
      (t) => t.id == activeTemplate.value.id,
    );
    if (idx != -1) {
      localTemplates[idx] = activeTemplate.value.copyWith();
      _persistCustomLocalTemplates();
    }
    activeTemplate.refresh();
  }

  /// Bidirectional sync: sync raw markup from structured visual blocks
  void syncMarkupFromBlocks() {
    activeTemplate.update((val) {
      if (val != null) {
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    final idx = localTemplates.indexWhere(
      (t) => t.id == activeTemplate.value.id,
    );
    if (idx != -1) {
      localTemplates[idx] = activeTemplate.value.copyWith();
      _persistCustomLocalTemplates();
    }
    activeTemplate.refresh();
  }

  /// Update paper width
  void setPaperWidth(int width) {
    activeTemplate.update((val) {
      if (val != null) {
        val.paperWidth = width;
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    final idx = localTemplates.indexWhere(
      (t) => t.id == activeTemplate.value.id,
    );
    if (idx != -1) {
      localTemplates[idx].paperWidth = width;
      localTemplates.refresh();
      _persistCustomLocalTemplates();
    }
    activeTemplate.refresh();
    try {
      final appSettings = AppSettingsModel.fromStorage();
      appSettings.printerRecietLength = width;
      appSettings.saveToStorage();
    } catch (_) {}
    syncActiveTemplateToCompanyServer();
    Toaster.showSuccess("Paper width set to $width characters");
  }

  /// Block manipulations
  void addBlock(ReceiptBlockV2 block) {
    activeTemplate.update((val) {
      if (val != null) {
        val.blocks.add(block);
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  void removeBlock(int index) {
    if (index < 0 || index >= activeTemplate.value.blocks.length) return;
    activeTemplate.update((val) {
      if (val != null) {
        val.blocks.removeAt(index);
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  void reorderBlocks(int oldIndex, int newIndex) {
    activeTemplate.update((val) {
      if (val != null) {
        if (newIndex > oldIndex) newIndex -= 1;
        final item = val.blocks.removeAt(oldIndex);
        val.blocks.insert(newIndex, item);
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  void swapBlocks(int indexA, int indexB) {
    if (indexA < 0 || indexA >= activeTemplate.value.blocks.length) return;
    if (indexB < 0 || indexB >= activeTemplate.value.blocks.length) return;
    activeTemplate.update((val) {
      if (val != null) {
        final temp = val.blocks[indexA];
        val.blocks[indexA] = val.blocks[indexB];
        val.blocks[indexB] = temp;
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  void toggleBlock(int index) {
    if (index < 0 || index >= activeTemplate.value.blocks.length) return;
    activeTemplate.update((val) {
      if (val != null) {
        val.blocks[index].enabled = !val.blocks[index].enabled;
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  void updateBlock(int index, ReceiptBlockV2 updated) {
    if (index < 0 || index >= activeTemplate.value.blocks.length) return;
    activeTemplate.update((val) {
      if (val != null) {
        val.blocks[index] = updated;
        val.syncMarkupFromBlocks();
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  /// Custom Week and Month Names
  void setCustomWeekNames(List<String> names) {
    activeTemplate.update((val) {
      if (val != null) {
        val.customWeekNames = names;
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  void setCustomMonthNames(List<String> names) {
    activeTemplate.update((val) {
      if (val != null) {
        val.customMonthNames = names;
      }
    });
    _box.write('active_receipt_template_v2', activeTemplate.value.toJson());
    syncActiveTemplateToCompanyServer();
  }

  /// Cloud API: Fetch community templates with pagination support
  Future<void> fetchCloudTemplates({
    String? category,
    String? search,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (!hasMoreCloud.value || isLoadingMoreCloud.value) return;
      isLoadingMoreCloud.value = true;
    } else {
      isLoadingCloud.value = true;
      cloudPage.value = 1;
      hasMoreCloud.value = true;
    }

    try {
      final cat = category ?? selectedCategory.value;
      final q = search ?? cloudSearchQuery.value;
      final pageToLoad = loadMore ? cloudPage.value + 1 : 1;

      var url =
          "/admin/receipt-templates?sort=popular&page=$pageToLoad&limit=$cloudPageLimit";
      if (cat != 'all') url += "&category=$cat";
      if (q.trim().isNotEmpty) {
        url += "&search=${Uri.encodeComponent(q.trim())}";
      }

      final response = await Net.get(url);
      if (!response.hasError && response.body['templates'] != null) {
        final total = response.body['total'] ?? 0;
        totalCloudCount.value = total;

        final list = (response.body['templates'] as List)
            .map(
              (e) => sanitizeTemplateModel(
                ReceiptTemplateV2Model.fromJson(Map<String, dynamic>.from(e)),
              ),
            )
            .toList();

        if (loadMore) {
          cloudTemplates.addAll(list);
          cloudPage.value = pageToLoad;
        } else {
          cloudTemplates.assignAll(list);
          cloudPage.value = 1;
        }
        hasMoreCloud.value = cloudTemplates.length < total;
      }
    } catch (e) {
      debugPrint("Error fetching cloud templates: $e");
    } finally {
      isLoadingCloud.value = false;
      isLoadingMoreCloud.value = false;
    }
  }

  /// Cloud API: Download template from cloud to local templates
  Future<void> downloadCloudTemplate(
    ReceiptTemplateV2Model template, {
    bool applyImmediately = true,
  }) async {
    if (downloadingTemplateId.value == template.id) return;
    downloadingTemplateId.value = template.id;
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}

    try {
      final response = await Net.post(
        "/admin/receipt-templates/${template.id}/download",
        data: {},
      );

      ReceiptTemplateV2Model downloaded;
      if (!response.hasError &&
          response.body is Map &&
          response.body['template'] != null) {
        downloaded = sanitizeTemplateModel(
          ReceiptTemplateV2Model.fromJson(
            Map<String, dynamic>.from(response.body['template']),
          ),
        );
      } else {
        // Fallback to the cloud template model directly if endpoint returned error
        downloaded = sanitizeTemplateModel(template.copyWith());
        downloaded.downloads = template.downloads + 1;
      }

      if (downloaded.blocks.isEmpty &&
          downloaded.templateContent.trim().isNotEmpty) {
        downloaded.syncBlocksFromMarkup(downloaded.templateContent);
      }
      downloaded.isCloud = true;

      // Update download count in cloudTemplates list
      final cloudIdx = cloudTemplates.indexWhere((c) => c.id == template.id);
      if (cloudIdx != -1) {
        cloudTemplates[cloudIdx] = downloaded.copyWith(id: template.id);
      }

      // Check if already in local templates
      final existingIdx = localTemplates.indexWhere(
        (t) =>
            t.id == downloaded.id ||
            t.name.trim().toLowerCase() == downloaded.name.trim().toLowerCase(),
      );
      final wasExisting = existingIdx != -1;
      if (wasExisting) {
        // Keep preset ID if overwriting a system preset so IDs stay consistent
        if (localTemplates[existingIdx].id.startsWith('preset_')) {
          downloaded.id = localTemplates[existingIdx].id;
        }
        localTemplates[existingIdx] = downloaded;
      } else {
        localTemplates.add(downloaded);
      }
      localTemplates.refresh();
      cloudTemplates.refresh();
      _persistCustomLocalTemplates();

      downloadingTemplateId.value = null;

      if (applyImmediately) {
        await setActiveTemplate(downloaded);
        justActivatedTemplateId.value = template.id;
      } else {
        if (wasExisting) {
          Toaster.showSuccess(
            "Updated local copy of '${downloaded.name}' from Cloud Marketplace!",
          );
        } else {
          Toaster.showSuccess(
            "Downloaded and saved '${downloaded.name}' to local device storage!",
          );
        }
      }
    } catch (e) {
      downloadingTemplateId.value = null;
      Toaster.showError("Failed to download template: $e");
    }
  }

  /// Cloud API: Publish current active template to cloud
  Future<bool> publishToCloud({
    required String name,
    required String description,
    required String category,
    required List<String> tags,
  }) async {
    if (isPublishing.value) return false;
    isPublishing.value = true;
    try {
      final payload = {
        "name": name.trim(),
        "description": description.trim(),
        "category": category,
        "paperWidth": activeTemplate.value.paperWidth,
        "templateContent": activeTemplate.value.templateContent,
        "blocks": activeTemplate.value.blocks.map((b) => b.toJson()).toList(),
        "tags": tags,
        "customWeekNames": activeTemplate.value.customWeekNames,
        "customMonthNames": activeTemplate.value.customMonthNames,
        "isPublic": true,
      };

      final response = await Net.post(
        "/admin/receipt-templates",
        data: payload,
      );
      isPublishing.value = false;

      if (response.hasError) {
        Toaster.showError(response.response.toString());
        return false;
      }

      Toaster.showSuccess("Template published to Cloud Marketplace!");
      fetchCloudTemplates();
      return true;
    } catch (e) {
      isPublishing.value = false;
      Toaster.showError("Error publishing: $e");
      return false;
    }
  }

  /// Sync active template to company on server
  Future<void> syncActiveTemplateToCompanyServer() async {
    try {
      final designPayload = {
        "enabled": true,
        "id": activeTemplate.value.id,
        "name": activeTemplate.value.name,
        "description": activeTemplate.value.description,
        "category": activeTemplate.value.category,
        "author": activeTemplate.value.author,
        "paperWidth": activeTemplate.value.paperWidth,
        "templateContent": activeTemplate.value.templateContent,
        "blocks": activeTemplate.value.blocks.map((b) => b.toJson()).toList(),
        "tags": activeTemplate.value.tags,
        "customWeekNames": activeTemplate.value.customWeekNames,
        "customMonthNames": activeTemplate.value.customMonthNames,
      };
      final payload = {"receiptDesignV2": designPayload};
      await Net.post("/admin/company/receipt-design-v2", data: payload);
    } catch (e) {
      debugPrint("Failed to sync receipt design v2 to company: $e");
    }
  }

  /// Print test receipt to connected thermal printer
  Future<void> printTestReceipt() async {
    try {
      final b = EscPosBuilder();
      b.init();

      final mockReceipt = ReceiptTemplateV2Engine.getMockReceipt();
      final mockUser = ReceiptTemplateV2Engine.getMockUser();
      final mockCustomer = ReceiptTemplateV2Engine.getMockCustomer();
      final mockCompany = ReceiptTemplateV2Engine.getMockCompany();

      ReceiptTemplateV2Engine.printToEscPosBuilder(
        b: b,
        template: activeTemplate.value,
        itemReceitModel: mockReceipt,
        user: mockUser,
        customer: mockCustomer,
        company: mockCompany,
      );

      await DevicesController.dispatchPrint(b);
      Toaster.showSuccess("Test print sent to printer!");
    } catch (e) {
      Toaster.showError("Print failed: $e (Make sure printer is connected)");
    }
  }
}
