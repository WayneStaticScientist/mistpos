import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../controllers/receipt_design_v2_controller.dart';
import '../models/receipt_template_v2_model.dart';
import '../widgets/receipt_guide_modal.dart';
import '../widgets/thermal_receipt_preview.dart';

class ScreenReceiptDesignerV2 extends StatefulWidget {
  const ScreenReceiptDesignerV2({super.key});

  @override
  State<ScreenReceiptDesignerV2> createState() =>
      _ScreenReceiptDesignerV2State();
}

class _ScreenReceiptDesignerV2State extends State<ScreenReceiptDesignerV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ReceiptDesignV2Controller _controller;
  final TextEditingController _codeController = TextEditingController();

  String _safeTemplateName(String name) {
    if (name.toLowerCase().contains('stargiven')) {
      return name
          .replaceAll(
            RegExp(
              r'stargiven(\s+enterprises)?(\s+style)?',
              caseSensitive: false,
            ),
            'Standard',
          )
          .trim();
    }
    return name;
  }

  String _safeTemplateDesc(String desc) {
    if (desc.toLowerCase().contains('stargiven')) {
      return desc
          .replaceAll(
            RegExp(
              r'stargiven(\s+enterprises)?(\s+style)?',
              caseSensitive: false,
            ),
            'retail enterprises',
          )
          .trim();
    }
    return desc;
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ReceiptDesignV2Controller());
    _tabController = TabController(length: 6, vsync: this);

    _codeController.text = _controller.activeTemplate.value.templateContent;

    // Bidirectional sync between tabs: Visual Blocks <-> Code Editor <-> Live Preview
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          // Visual Blocks: sync structured blocks from latest Code Editor markup
          _controller.syncBlocksFromMarkup(_codeController.text);
        } else if (_tabController.index == 1) {
          // Code Editor: sync raw markup from active template blocks
          _controller.syncMarkupFromBlocks();
          if (_codeController.text !=
              _controller.activeTemplate.value.templateContent) {
            _codeController.text =
                _controller.activeTemplate.value.templateContent;
          }
        } else if (_tabController.index == 2) {
          // Live Preview: sync blocks from latest Code Editor text
          _controller.syncBlocksFromMarkup(_codeController.text);
        }
      }
    });

    _controller.activeTemplate.listen((template) {
      if (_codeController.text != template.templateContent) {
        _codeController.text = template.templateContent;
      }
    });

    _controller.fetchCloudTemplates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _showLivePreview() {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _controller.activeTemplate.value.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Live Thermal Printer Simulation",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Print Test Receipt",
                        onPressed: () => _controller.printTestReceipt(),
                        icon: const Icon(Icons.print_outlined),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => ThermalReceiptPreview(
                    template: _controller.activeTemplate.value,
                    onPrintTest: () => _controller.printTestReceipt(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showGuideModal() {
    Get.bottomSheet(
      ReceiptGuideModal(
        onInsertTag: (tag) {
          final text = _codeController.text;
          final selection = _codeController.selection;
          final start = selection.start >= 0 ? selection.start : text.length;
          final end = selection.end >= 0 ? selection.end : text.length;
          final newText = text.replaceRange(start, end, tag);
          _codeController.text = newText;
          _codeController.selection = TextSelection.collapsed(
            offset: start + tag.length,
          );
          _controller.updateActiveTemplateContent(newText);
        },
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              child: Text(
                "Receipt Designer",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: themeColor.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: themeColor.withAlpha(80)),
              ),
              child: Text(
                "V2",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Paper width chip (tap to customize or enter custom width)
          Obx(() {
            final width = _controller.activeTemplate.value.paperWidth;
            final label = width == 32
                ? "58mm (32)"
                : (width == 42 ? "80mm (42)" : "$width chars");
            return Tooltip(
              message: "Paper width: $width characters (tap to customize)",
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => _showPaperWidthDialog(themeColor),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: themeColor.withAlpha(120)),
                    borderRadius: BorderRadius.circular(6),
                    color: themeColor.withAlpha(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.tune_rounded, size: 12, color: themeColor),
                    ],
                  ),
                ),
              ),
            );
          }),
          // Live preview button
          IconButton(
            tooltip: "Live Thermal Preview",
            icon: const Icon(Icons.remove_red_eye_outlined),
            onPressed: _showLivePreview,
          ),
          // More options menu (Test print, Guide, Save)
          PopupMenuButton<String>(
            tooltip: "More Options",
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == 'test_print') {
                _controller.printTestReceipt();
              } else if (val == 'guide') {
                _showGuideModal();
              } else if (val == 'save_copy') {
                _showSaveCustomDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'test_print',
                child: Row(
                  children: [
                    Icon(Icons.print_outlined, size: 18),
                    SizedBox(width: 10),
                    Text("Test Print Receipt"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'guide',
                child: Row(
                  children: [
                    Icon(Icons.help_outline_rounded, size: 18),
                    SizedBox(width: 10),
                    Text("Tag Guide & Dictionary"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'save_copy',
                child: Row(
                  children: [
                    Icon(Icons.bookmark_add_outlined, size: 18),
                    SizedBox(width: 10),
                    Text("Save Copy as Custom"),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: themeColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: themeColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.view_agenda_outlined, size: 18),
              text: "Visual Blocks",
            ),
            Tab(icon: Icon(Icons.code_rounded, size: 18), text: "Code Editor"),
            Tab(
              icon: Icon(Icons.remove_red_eye_outlined, size: 18),
              text: "Live Preview",
            ),
            Tab(
              icon: Icon(Icons.dashboard_customize_outlined, size: 18),
              text: "Local Gallery",
            ),
            Tab(
              icon: Icon(Icons.cloud_download_outlined, size: 18),
              text: "Cloud Store",
            ),
            Tab(
              icon: Icon(Icons.menu_book_rounded, size: 18),
              text: "Documentation",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVisualBlocksTab(themeColor),
          _buildCodeEditorTab(themeColor),
          _buildLivePreviewTab(themeColor),
          _buildLocalGalleryTab(themeColor),
          _buildCloudStoreTab(themeColor),
          _buildDocumentationTab(themeColor),
        ],
      ),
      bottomNavigationBar: _buildBottomStatusBar(themeColor),
    );
  }

  Widget _buildBottomStatusBar(Color themeColor) {
    return Obx(
      () => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(top: BorderSide(color: Colors.grey.withAlpha(40))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _controller.activeTemplate.value.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _showSaveCustomDialog(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_add_outlined, size: 15),
                    SizedBox(width: 4),
                    Text("Copy", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  _controller.updateActiveTemplateContent(_codeController.text);
                  await _controller.saveActiveTemplate();
                  Toaster.showSuccess(
                    "Receipt Design V2 saved & synced to company!",
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save_rounded, size: 15),
                    SizedBox(width: 4),
                    Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TAB 1: VISUAL BLOCKS =================
  Widget _buildVisualBlocksTab(Color themeColor) {
    return Obx(() {
      final blocks = _controller.activeTemplate.value.blocks;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: themeColor.withAlpha(15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Drag & drop blocks to reorder. Swipe to remove.",
                    style: TextStyle(fontSize: 11.5, color: themeColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => _showAddBlockBottomSheet(themeColor),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text(
                    "Add Block",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: blocks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.dashboard_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "No structured visual blocks in current template.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "You can edit via Code Editor or load a prebuilt visual template.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _showAddBlockBottomSheet(themeColor),
                          icon: const Icon(Icons.add),
                          label: const Text("Add First Block"),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: blocks.length,
                    onReorder: (oldIndex, newIndex) =>
                        _controller.reorderBlocks(oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final block = blocks[index];
                      return Dismissible(
                        key: ValueKey("block_${block.id}_$index"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.redAccent,
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) => _controller.removeBlock(index),
                        child: _buildBlockTile(block, index, themeColor),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildBlockTile(ReceiptBlockV2 block, int index, Color themeColor) {
    IconData icon;
    String title;
    switch (block.type) {
      case ReceiptBlockType.logo:
        icon = Icons.photo_outlined;
        title = "Receipt Logo {logo}";
        break;
      case ReceiptBlockType.customerInfo:
        icon = Icons.person_outline;
        title = "Customer Details";
        break;
      case ReceiptBlockType.fiscalHeader:
        icon = Icons.receipt_long_outlined;
        title = "Fiscal Receipt Header";
        break;
      case ReceiptBlockType.list:
        icon = Icons.format_list_bulleted_rounded;
        title = "Items Repeat Loop {list}";
        break;
      case ReceiptBlockType.totals:
        icon = Icons.monetization_on_outlined;
        title = "Totals & Taxes Summary";
        break;
      case ReceiptBlockType.line:
        icon = Icons.horizontal_rule_rounded;
        title = "Divider Line ('${block.char}')";
        break;
      case ReceiptBlockType.barcode:
        icon = Icons.barcode_reader;
        title = "Barcode (Code128)";
        break;
      case ReceiptBlockType.qrcode:
        icon = Icons.qr_code_2_rounded;
        title = "QR Code";
        break;
      case ReceiptBlockType.zimraQr:
        icon = Icons.qr_code_scanner_rounded;
        title = "ZIMRA Fiscal QR Code";
        break;
      case ReceiptBlockType.spacer:
        icon = Icons.space_bar_rounded;
        title = "Spacer Feed (${block.lines} lines)";
        break;
      case ReceiptBlockType.text:
        icon = Icons.text_fields_rounded;
        title = block.content.length > 25
            ? "${block.content.substring(0, 25)}..."
            : (block.content.isEmpty ? "Text Block" : block.content);
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: block.enabled
              ? themeColor.withAlpha(50)
              : Colors.grey.withAlpha(40),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Icon(
                Icons.drag_indicator_rounded,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: themeColor.withAlpha(25),
              child: Icon(icon, size: 16, color: themeColor),
            ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: block.isBold ? FontWeight.bold : FontWeight.w600,
            color: block.enabled ? null : Colors.grey,
          ),
        ),
        subtitle: Row(
          children: [
            _badge(block.align.toUpperCase()),
            const SizedBox(width: 6),
            if (block.isBold) _badge("BOLD"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: () => _showEditBlockDialog(block, index, themeColor),
            ),
            Switch(
              value: block.enabled,
              onChanged: (_) => _controller.toggleBlock(index),
              activeThumbColor: themeColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ================= TAB 2: CODE & MARKUP EDITOR =================
  Widget _buildCodeEditorTab(Color themeColor) {
    final quickTags = [
      '{logo}',
      '{customer}',
      '{receipt_no}',
      '{date_formatted}',
      '{time}',
      '{list}',
      '{itemname}',
      '{itemcount}',
      '{itemprice}',
      '{itemtotal}',
      '{subtotal}',
      '{vat_rate}',
      '{tax_amount}',
      '{total}',
      '{currency}',
      '{payment_method}',
      '{change}',
      '{zimra_qr}',
      '{zimra_verification_code}',
      '{zimra_manual_url}',
      '{line:-}',
      '{line:=}',
      '{barcode}',
      '{qrcode}',
      '{align:center}',
      '{align:right}',
      '{bold}',
      '{feed:2}',
    ];

    return Column(
      children: [
        // Quick Variable Insertion Tray
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: themeColor.withAlpha(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Quick Variable Tag Tray (tap to insert):",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _showGuideModal,
                    child: Text(
                      "View All Tags ↗",
                      style: TextStyle(
                        fontSize: 11,
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: quickTags.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 0,
                        ),
                        label: Text(
                          tag,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: themeColor,
                          ),
                        ),
                        onPressed: () {
                          final text = _codeController.text;
                          final selection = _codeController.selection;
                          final start = selection.start >= 0
                              ? selection.start
                              : text.length;
                          final end = selection.end >= 0
                              ? selection.end
                              : text.length;
                          final newText = text.replaceRange(start, end, tag);
                          _codeController.text = newText;
                          _codeController.selection = TextSelection.collapsed(
                            offset: start + tag.length,
                          );
                          _controller.updateActiveTemplateContent(newText);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Monospace Code Editor
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.4,
              ),
              onChanged: (text) {
                _controller.updateActiveTemplateContent(text);
              },
              decoration: InputDecoration(
                hintText: "Enter receipt markup tags here...",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= TAB 3: LIVE PREVIEW =================
  Widget _buildLivePreviewTab(Color themeColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Center(
        child: Obx(
          () => ThermalReceiptPreview(
            template: _controller.activeTemplate.value,
            onPrintTest: () => _controller.printTestReceipt(),
          ),
        ),
      ),
    );
  }

  // ================= TAB 4: LOCAL GALLERY =================
  Widget _buildLocalGalleryTab(Color themeColor) {
    return Obx(() {
      final templates = _controller.localTemplates;

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final t = templates[index];
          return Obx(() {
            final isActive = _controller.isTemplateActive(t);
            final isApplying = _controller.applyingTemplateId.value == t.id;
            final isJustActivated =
                _controller.justActivatedTemplateId.value == t.id;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green.withAlpha(14)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive
                      ? Colors.green
                      : (isApplying || isJustActivated
                            ? themeColor
                            : Colors.grey.withAlpha(45)),
                  width: isActive ? 2.2 : (isApplying ? 1.8 : 1),
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.green.withAlpha(45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withAlpha(25)
                                : themeColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isActive
                                ? Icons.check_circle_rounded
                                : (t.category == 'fiscal'
                                      ? Icons.verified_user_outlined
                                      : Icons.receipt_long_outlined),
                            color: isActive ? Colors.green : themeColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _safeTemplateName(t.name),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, anim) =>
                                        ScaleTransition(
                                          scale: anim,
                                          child: child,
                                        ),
                                    child: isActive
                                        ? Container(
                                            key: const ValueKey("active_badge"),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withAlpha(35),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 1.2,
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 12,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "ACTIVATED & IN USE",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.green,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(
                                            key: ValueKey("inactive_badge"),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _safeTemplateDesc(t.description),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dedicated Local Device Management Status Banner
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withAlpha(18)
                            : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withAlpha(8)
                                  : Colors.grey.withAlpha(16)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? Colors.green.withAlpha(80)
                              : Colors.grey.withAlpha(30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isActive
                                ? Icons.check_circle_outline_rounded
                                : (t.id.startsWith('preset_')
                                      ? Icons.verified_outlined
                                      : Icons.sd_storage_outlined),
                            size: 14,
                            color: isActive
                                ? Colors.green
                                : (t.id.startsWith('preset_')
                                      ? Colors.blueGrey
                                      : Colors.teal),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              isActive
                                  ? "Currently Active Template • Synced to POS & Cloud"
                                  : (t.id.startsWith('preset_')
                                        ? "Pre-built System Template • Stored locally • Ready offline"
                                        : "Managed Locally • Saved in Device Storage • Deletable anytime"),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isActive
                                    ? Colors.green.shade700
                                    : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withAlpha(180),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        _tagBadge(
                          "${t.paperWidth} chars (${t.paperWidth <= 32 ? '58mm' : '80mm'})",
                        ),
                        _tagBadge(t.category.toUpperCase()),
                        _tagBadge("By: ${t.author}"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Inline interactive thermal receipt preview directly on card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.withAlpha(40)),
                        ),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.85,
                                  alignment: Alignment.topCenter,
                                  child: ThermalReceiptPreview(
                                    template: t,
                                    compact: true,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(160),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.unfold_more,
                                      size: 10,
                                      color: Colors.white70,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      "Scroll Preview",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 20),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.85,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: ThermalReceiptPreview(template: t),
                                ),
                              ),
                              isScrollControlled: true,
                            );
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 16,
                          ),
                          label: const Text("Preview"),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: isApplying
                              ? ElevatedButton.icon(
                                  key: const ValueKey("applying_btn"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor.withAlpha(200),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: null,
                                  icon: const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  label: const Text(
                                    "Applying...",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : (!isActive
                                    ? ElevatedButton.icon(
                                        key: const ValueKey("apply_btn"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: themeColor,
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                        ),
                                        onPressed: () =>
                                            _controller.setActiveTemplate(t),
                                        icon: const Icon(
                                          Icons.touch_app_rounded,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          "Apply This Template",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        key: const ValueKey("applied_badge"),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withAlpha(25),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.withAlpha(120),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "Activated & Ready to Print",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                        ),
                        if (isActive)
                          OutlinedButton.icon(
                            onPressed: () => _showPublishCloudDialog(t),
                            icon: const Icon(
                              Icons.cloud_upload_outlined,
                              size: 16,
                            ),
                            label: const Text("Share to Cloud"),
                          ),
                        if (!t.id.startsWith('preset_'))
                          IconButton(
                            tooltip: "Delete template from local storage",
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            onPressed: () => _confirmDeleteLocalTemplate(t),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }

  void _confirmDeleteLocalTemplate(ReceiptTemplateV2Model t) {
    Get.defaultDialog(
      title: "Delete Local Template?",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText:
          "Are you sure you want to delete '${t.name}' from your local device storage?\n\nThis will remove it from your device without affecting cloud copies.",
      textConfirm: "Delete Locally",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      textCancel: "Cancel",
      onConfirm: () {
        Get.back();
        _controller.deleteLocalTemplate(t);
      },
    );
  }

  // ================= TAB 4: CLOUD MARKETPLACE =================
  Widget _buildCloudStoreTab(Color themeColor) {
    return Column(
      children: [
        // Search & Category Filters
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) {
                    _controller.cloudSearchQuery.value = v;
                    _controller.fetchCloudTemplates(search: v);
                  },
                  decoration: InputDecoration(
                    hintText: "Search community templates...",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onPressed: () =>
                    _showPublishCloudDialog(_controller.activeTemplate.value),
                icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                label: const Text("Publish Mine"),
              ),
            ],
          ),
        ),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Obx(() {
            final cats = [
              'all',
              'fiscal',
              'retail',
              'grocery',
              'restaurant',
              'minimal',
            ];
            return Row(
              children: cats.map((cat) {
                final isSel = _controller.selectedCategory.value == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(
                      cat.capitalizeFirst!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSel ? Colors.white : null,
                      ),
                    ),
                    selected: isSel,
                    selectedColor: themeColor,
                    showCheckmark: false,
                    onSelected: (val) {
                      _controller.selectedCategory.value = cat;
                      _controller.fetchCloudTemplates(category: cat);
                    },
                  ),
                );
              }).toList(),
            );
          }),
        ),
        const Divider(height: 16),

        // Community templates count & pagination summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Obx(
            () => Row(
              children: [
                Icon(Icons.cloud_done_outlined, size: 14, color: themeColor),
                const SizedBox(width: 6),
                Text(
                  "Showing ${_controller.cloudTemplates.length} of ${_controller.totalCloudCount.value} community templates",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_controller.isLoadingMoreCloud.value)
                  const SizedBox(
                    width: 13,
                    height: 13,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),

        // Cloud templates list
        Expanded(
          child: Obx(() {
            if (_controller.isLoadingCloud.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final templates = _controller.cloudTemplates;
            if (templates.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No cloud templates found.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _controller.fetchCloudTemplates(),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Refresh Marketplace"),
                    ),
                  ],
                ),
              );
            }

            final hasMore = _controller.hasMoreCloud.value;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: templates.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == templates.length) {
                  return Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: _controller.isLoadingMoreCloud.value
                            ? const CircularProgressIndicator()
                            : OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => _controller
                                    .fetchCloudTemplates(loadMore: true),
                                icon: const Icon(Icons.expand_more_rounded),
                                label: Text(
                                  "Load More Templates (${_controller.totalCloudCount.value - templates.length} more)",
                                ),
                              ),
                      ),
                    ),
                  );
                }

                final t = templates[index];
                return Obx(() {
                  // Check if already in local templates
                  final localMatch = _controller.localTemplates
                      .firstWhereOrNull(
                        (lt) =>
                            lt.id == t.id ||
                            lt.name.trim().toLowerCase() ==
                                t.name.trim().toLowerCase(),
                      );
                  final isDownloaded = localMatch != null;
                  final isActive =
                      _controller.isTemplateActive(t) ||
                      (localMatch != null &&
                          _controller.isTemplateActive(localMatch));
                  final isDownloading =
                      _controller.downloadingTemplateId.value == t.id;
                  final isApplying =
                      _controller.applyingTemplateId.value == t.id ||
                      (localMatch != null &&
                          _controller.applyingTemplateId.value ==
                              localMatch.id);
                  final isBusy = isDownloading || isApplying;
                  final isJustActivated =
                      _controller.justActivatedTemplateId.value == t.id ||
                      (localMatch != null &&
                          _controller.justActivatedTemplateId.value ==
                              localMatch.id);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withAlpha(14)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive
                            ? Colors.green
                            : (isBusy || isJustActivated
                                  ? themeColor
                                  : (isDownloaded
                                        ? Colors.blue.withAlpha(100)
                                        : Colors.grey.withAlpha(45))),
                        width: isActive ? 2.2 : (isBusy ? 1.8 : 1),
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.green.withAlpha(45),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? Colors.green.withAlpha(25)
                                      : (isDownloaded
                                            ? Colors.blue.withAlpha(25)
                                            : themeColor.withAlpha(25)),
                                ),
                                child: Icon(
                                  isActive
                                      ? Icons.check_circle_rounded
                                      : (isDownloaded
                                            ? Icons.download_done_rounded
                                            : Icons.cloud_outlined),
                                  size: 20,
                                  color: isActive
                                      ? Colors.green
                                      : (isDownloaded
                                            ? Colors.blue
                                            : themeColor),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _safeTemplateName(t.name),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          transitionBuilder: (child, anim) =>
                                              ScaleTransition(
                                                scale: anim,
                                                child: child,
                                              ),
                                          child: (isActive || isDownloaded)
                                              ? Container(
                                                  key: ValueKey(
                                                    isActive
                                                        ? "cloud_active"
                                                        : "cloud_installed",
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? Colors.green
                                                              .withAlpha(35)
                                                        : Colors.blue.withAlpha(
                                                            30,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    border: Border.all(
                                                      color: isActive
                                                          ? Colors.green
                                                          : Colors.blue,
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        isActive
                                                            ? Icons
                                                                  .check_circle_rounded
                                                            : Icons
                                                                  .download_done_rounded,
                                                        size: 11,
                                                        color: isActive
                                                            ? Colors.green
                                                            : Colors.blue,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        isActive
                                                            ? "ACTIVATED & IN USE"
                                                            : "INSTALLED",
                                                        style: TextStyle(
                                                          fontSize: 9.5,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: isActive
                                                              ? Colors.green
                                                              : Colors.blue,
                                                          letterSpacing: 0.4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox.shrink(
                                                  key: ValueKey("cloud_none"),
                                                ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _safeTemplateDesc(t.description),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _tagBadge("${t.downloads} Downloads"),
                              _tagBadge(t.category.toUpperCase()),
                              _tagBadge("By ${t.author}"),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Inline interactive thermal receipt preview directly on card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 230,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withAlpha(40),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Center(
                                      child: Transform.scale(
                                        scale: 0.85,
                                        alignment: Alignment.topCenter,
                                        child: ThermalReceiptPreview(
                                          template: t,
                                          compact: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(160),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.unfold_more,
                                            size: 10,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            "Scroll Preview",
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 20),
                          Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  Get.bottomSheet(
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.85,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(24),
                                            ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: ThermalReceiptPreview(
                                          template: t,
                                        ),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 16,
                                ),
                                label: const Text("Preview"),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: isBusy
                                    ? ElevatedButton.icon(
                                        key: const ValueKey("cloud_busy_btn"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: themeColor.withAlpha(
                                            200,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                        ),
                                        onPressed: null,
                                        icon: const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        label: Text(
                                          isDownloading
                                              ? "Downloading & Applying..."
                                              : "Applying...",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : (isActive
                                          ? Container(
                                              key: const ValueKey(
                                                "cloud_active_badge",
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withAlpha(
                                                  25,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.green.withAlpha(
                                                    120,
                                                  ),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_rounded,
                                                    size: 16,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Activated & Ready to Print",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : (isDownloaded
                                                ? ElevatedButton.icon(
                                                    key: const ValueKey(
                                                      "cloud_apply_installed_btn",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.teal,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 10,
                                                          ),
                                                    ),
                                                    onPressed: () => _controller
                                                        .setActiveTemplate(
                                                          localMatch,
                                                        ),
                                                    icon: const Icon(
                                                      Icons.touch_app_rounded,
                                                      size: 16,
                                                    ),
                                                    label: const Text(
                                                      "Apply Installed Template",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : ElevatedButton.icon(
                                                    key: const ValueKey(
                                                      "cloud_download_btn",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          themeColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 2,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 10,
                                                          ),
                                                    ),
                                                    onPressed: () => _controller
                                                        .downloadCloudTemplate(
                                                          t,
                                                        ),
                                                    icon: const Icon(
                                                      Icons.download_rounded,
                                                      size: 16,
                                                    ),
                                                    label: const Text(
                                                      "Download & Apply",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ))),
                              ),
                              if ((isActive || isDownloaded) && !isBusy)
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _controller.downloadCloudTemplate(t),
                                  icon: const Icon(
                                    Icons.sync_rounded,
                                    size: 16,
                                  ),
                                  label: const Text("Re-download"),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }

  // ================= TAB 5: DOCUMENTATION =================
  Widget _buildDocumentationTab(Color themeColor) {
    return ReceiptGuideModal(
      onInsertTag: (tag) {
        _tabController.animateTo(1); // switch to code editor
        final text = _codeController.text;
        final newText = "$text\n$tag";
        _codeController.text = newText;
        _controller.updateActiveTemplateContent(newText);
      },
    );
  }

  Widget _tagBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ================= DIALOGS =================
  void _showAddBlockBottomSheet(Color themeColor) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Receipt Section Block",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.photo_outlined, color: themeColor),
                title: const Text("Receipt Logo Block {logo}"),
                subtitle: const Text(
                  "Shows company logo image uploaded in Settings or here",
                ),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.logo,
                      align: 'center',
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: themeColor),
                title: const Text("Customer Details Block"),
                subtitle: const Text("Customer Name, Phone, Email"),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.customerInfo,
                      align: 'left',
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long_outlined, color: themeColor),
                title: const Text("Fiscal Receipt Title Header"),
                subtitle: const Text("FISCAL RECEIPT title with counter"),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.fiscalHeader,
                      align: 'center',
                      isBold: true,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.format_list_bulleted_rounded,
                  color: themeColor,
                ),
                title: const Text("Items List Loop Block {list}"),
                subtitle: const Text(
                  "Repeats each sold product with qty and price",
                ),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.list,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.monetization_on_outlined,
                  color: themeColor,
                ),
                title: const Text("Totals & Taxes Summary Block"),
                subtitle: const Text("Subtotal, VAT, Net Total, Paid, Change"),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.totals,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.horizontal_rule_rounded, color: themeColor),
                title: const Text("Divider Line"),
                subtitle: const Text("Full or half line (-, =, *, .)"),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.line,
                      char: '-',
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner_rounded, color: themeColor),
                title: const Text("ZIMRA Fiscal QR Code Block"),
                subtitle: const Text(
                  "Official FDMS QR code + verification code",
                ),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.zimraQr,
                      align: 'center',
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.text_fields_rounded, color: themeColor),
                title: const Text("Custom Text Block"),
                subtitle: const Text("Any custom text or variable tags"),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.text,
                      content: "Thank you for your business!",
                      align: 'center',
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.space_bar_rounded, color: themeColor),
                title: const Text("Blank Line Feed (Spacer)"),
                subtitle: const Text("Paper feeds before cut"),
                onTap: () {
                  Get.back();
                  _controller.addBlock(
                    ReceiptBlockV2(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: ReceiptBlockType.spacer,
                      lines: 2,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditBlockDialog(ReceiptBlockV2 block, int index, Color themeColor) {
    final contentCtrl = TextEditingController(text: block.content);
    String align = block.align;
    bool isBold = block.isBold;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Section Block",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (block.type == ReceiptBlockType.logo) ...[
                    StatefulBuilder(
                      builder: (context, setLogoState) {
                        final settings = AppSettingsModel.fromStorage();
                        final hasLogo =
                            settings.receitLogoPath.isNotEmpty &&
                            File(settings.receitLogoPath).existsSync();

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (hasLogo) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(settings.receitLogoPath),
                                    height: 70,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Current: ${p.basename(settings.receitLogoPath)}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        minimumSize: Size.zero,
                                      ),
                                      icon: const Icon(
                                        Icons.sync_rounded,
                                        size: 14,
                                      ),
                                      label: const Text(
                                        "Change Logo",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      onPressed: () async {
                                        await _pickReceiptLogoDirectly();
                                        setLogoState(() {});
                                        setModalState(() {});
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        minimumSize: Size.zero,
                                        foregroundColor: Colors.redAccent,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 14,
                                      ),
                                      label: const Text(
                                        "Remove",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      onPressed: () {
                                        final s =
                                            AppSettingsModel.fromStorage();
                                        try {
                                          File(s.receitLogoPath).deleteSync();
                                        } catch (_) {}
                                        s.receitLogoPath = "";
                                        s.saveToStorage();
                                        _controller.activeTemplate.refresh();
                                        setLogoState(() {});
                                        setModalState(() {});
                                        Toaster.showSuccess("Logo removed");
                                      },
                                    ),
                                  ],
                                ),
                              ] else ...[
                                const Icon(
                                  Icons.photo_outlined,
                                  size: 36,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "No receipt logo uploaded yet",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Upload a logo image to print at the top of your receipts",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                  ),
                                  icon: const Icon(
                                    Icons.upload_file_rounded,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    "Upload Receipt Logo",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () async {
                                    await _pickReceiptLogoDirectly();
                                    setLogoState(() {});
                                    setModalState(() {});
                                  },
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  if (block.type == ReceiptBlockType.text ||
                      block.type == ReceiptBlockType.customerInfo) ...[
                    TextField(
                      controller: contentCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Block Content (tags supported)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    "Alignment",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['left', 'center', 'right'].map((a) {
                      final isSel = align == a;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(a.capitalizeFirst!),
                          selected: isSel,
                          onSelected: (val) {
                            setModalState(() => align = a);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  if (block.type != ReceiptBlockType.logo) ...[
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Bold Text"),
                      value: isBold,
                      onChanged: (v) => setModalState(() => isBold = v),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () {
                      final updated = block.copyWith(
                        content: contentCtrl.text,
                        align: align,
                        isBold: isBold,
                      );
                      _controller.updateBlock(index, updated);
                      Get.back();
                      Toaster.showSuccess("Block updated");
                    },
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _pickReceiptLogoDirectly() async {
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
      _controller.activeTemplate.refresh();
      Toaster.showSuccess("Receipt logo updated!");
    } catch (e) {
      Toaster.showError("Failed to pick image: $e");
    }
  }

  void _showPaperWidthDialog(Color themeColor) {
    final currentWidth = _controller.activeTemplate.value.paperWidth;
    final ctrl = TextEditingController(text: currentWidth.toString());

    bool isApplying = false;
    bool isSuccess = false;
    int? appliedWidth;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> applyWidth(int width) async {
            if (width < 16 || width > 120) {
              Toaster.showError(
                "Please enter a valid character width between 16 and 120",
              );
              return;
            }
            setSheetState(() {
              isApplying = true;
              isSuccess = false;
              appliedWidth = width;
            });
            _controller.setPaperWidth(width);
            try {
              HapticFeedback.mediumImpact();
            } catch (_) {}

            await Future.delayed(const Duration(milliseconds: 300));
            setSheetState(() {
              isApplying = false;
              isSuccess = true;
            });
            try {
              HapticFeedback.lightImpact();
            } catch (_) {}

            await Future.delayed(const Duration(milliseconds: 450));
            if (Get.isBottomSheetOpen == true) {
              Get.back();
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.straighten_rounded,
                              color: themeColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Paper Character Width",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "Current: ${_controller.activeTemplate.value.paperWidth} characters per line",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Quick Presets",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.receipt_long, size: 16),
                            label: const Text("58mm (32 chars)"),
                            onPressed: isApplying || isSuccess
                                ? null
                                : () {
                                    ctrl.text = "32";
                                    applyWidth(32);
                                  },
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.receipt, size: 16),
                            label: const Text("80mm (42 chars)"),
                            onPressed: isApplying || isSuccess
                                ? null
                                : () {
                                    ctrl.text = "42";
                                    applyWidth(42);
                                  },
                          ),
                          ActionChip(
                            avatar: const Icon(
                              Icons.view_column_outlined,
                              size: 16,
                            ),
                            label: const Text("80mm Wide (48 chars)"),
                            onPressed: isApplying || isSuccess
                                ? null
                                : () {
                                    ctrl.text = "48";
                                    applyWidth(48);
                                  },
                          ),
                          ActionChip(
                            avatar: const Icon(
                              Icons.compress_rounded,
                              size: 16,
                            ),
                            label: const Text("Compact (28 chars)"),
                            onPressed: isApplying || isSuccess
                                ? null
                                : () {
                                    ctrl.text = "28";
                                    applyWidth(28);
                                  },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Enter Custom Width",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: ctrl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofocus: false,
                        enabled: !isApplying && !isSuccess,
                        onSubmitted: (val) {
                          final parsed = int.tryParse(val.trim());
                          if (parsed != null) {
                            applyWidth(parsed);
                          } else {
                            Toaster.showError(
                              "Please enter a valid character width between 16 and 120",
                            );
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Character count (16 - 120)",
                          hintText: "e.g. 32, 40, 42, 48, 56",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.edit_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSuccess ? Colors.green : themeColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: (isSuccess ? Colors.green : themeColor)
                                  .withAlpha(80),
                              blurRadius: isSuccess ? 10 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isApplying || isSuccess
                              ? null
                              : () {
                                  final parsed = int.tryParse(ctrl.text.trim());
                                  if (parsed == null ||
                                      parsed < 16 ||
                                      parsed > 120) {
                                    Toaster.showError(
                                      "Please enter a valid character width between 16 and 120",
                                    );
                                    return;
                                  }
                                  applyWidth(parsed);
                                },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isApplying
                                ? const Row(
                                    key: ValueKey("loading"),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Applying Character Width...",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : isSuccess
                                ? Row(
                                    key: const ValueKey("success"),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Applied $appliedWidth Characters!",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    key: ValueKey("idle"),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        "Apply Custom Width",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showSaveCustomDialog() {
    final nameCtrl = TextEditingController(
      text: "${_controller.activeTemplate.value.name} Copy",
    );
    final descCtrl = TextEditingController(
      text: _controller.activeTemplate.value.description,
    );

    Get.defaultDialog(
      title: "Save as Local Template",
      content: Column(
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: "Template Name"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descCtrl,
            decoration: const InputDecoration(
              labelText: "Description (optional)",
            ),
          ),
        ],
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        _controller.saveCurrentAsCustom(
          nameCtrl.text,
          description: descCtrl.text,
        );
        Get.back();
      },
    );
  }

  void _showPublishCloudDialog(ReceiptTemplateV2Model template) {
    final nameCtrl = TextEditingController(text: template.name);
    final descCtrl = TextEditingController(text: template.description);
    String category = template.category;
    final tagsCtrl = TextEditingController(text: template.tags.join(', '));

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Publish Template to Cloud Marketplace",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Share your receipt design with other MistPOS stores and community members.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Template Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    items:
                        [
                              'fiscal',
                              'retail',
                              'grocery',
                              'restaurant',
                              'minimal',
                              'custom',
                            ]
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.capitalizeFirst!),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setModalState(() => category = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tagsCtrl,
                    decoration: const InputDecoration(
                      labelText: "Tags (comma-separated, e.g. zimra, retail)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: _controller.isPublishing.value
                          ? null
                          : () async {
                              final tags = tagsCtrl.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList();
                              final ok = await _controller.publishToCloud(
                                name: nameCtrl.text,
                                description: descCtrl.text,
                                category: category,
                                tags: tags,
                              );
                              if (ok) Get.back();
                            },
                      child: _controller.isPublishing.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Publish to Cloud"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
