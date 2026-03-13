import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/models/receit_extras_model.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenReceiptDesigner extends StatefulWidget {
  const ScreenReceiptDesigner({super.key});

  @override
  State<ScreenReceiptDesigner> createState() => _ScreenReceiptDesignerState();
}

class _ScreenReceiptDesignerState extends State<ScreenReceiptDesigner> {
  late AppSettingsModel _model;
  final _invController = Get.find<InventoryController>();
  @override
  void initState() {
    super.initState();
    _model = AppSettingsModel.fromStorage();
  }

  void _save() async {
    if (await _invController.updateCompanyExtras(_model.extras)) {
      setState(() {
        _model = AppSettingsModel.fromStorage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Visual Designer"),
        actions: [
          IconButton(
            tooltip: "Add Custom Field",
            onPressed: () => _showFieldDialog(),
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            tooltip: "Save Layout",
            onPressed: () {
              _save();
            },
            icon: Obx(
              () => _invController.updatingCompanyExtrass.value
                  ? MistLoader1()
                  : const Icon(Icons.done_all),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: InfoCard(
              text:
                  "Long-press and drag any item to reorder. System blocks define core receipt sections.",
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _model.extras.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _model.extras.removeAt(oldIndex);
                  _model.extras.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final item = _model.extras[index];
                return _buildReorderableItem(item, index, themeColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReorderableItem(
    ReceitExtrasModel item,
    int index,
    Color themeColor,
  ) {
    final bool isSystem = item.type == "system";

    return Container(
      key: ValueKey("item_${item.key}_$index"),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSystem
              ? themeColor.withAlpha(110)
              : Colors.grey.withAlpha(50),
          width: isSystem ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ReorderableDragStartListener(
          index: index,
          child: Icon(
            Icons.drag_handle_rounded,
            color: isSystem ? themeColor : Colors.grey.shade400,
          ),
        ),
        title: Text(
          item.key,
          style: TextStyle(
            fontWeight: item.isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
            color: isSystem ? themeColor : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _badge(item.align.toUpperCase()),
              _badge(
                item.type.toUpperCase(),
                color: isSystem ? themeColor : null,
              ),
              if (item.isBold) _badge("BOLD"),
            ],
          ),
        ),
        trailing: isSystem
            ? _buildSystemTrailing(item, themeColor)
            : _buildCustomTrailing(item, index),
      ),
    );
  }

  Widget _badge(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color?.withAlpha(200) ?? Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildSystemTrailing(ReceitExtrasModel item, Color themeColor) {
    return Switch(
      activeThumbColor: themeColor,
      value: item.enabled,
      onChanged: (v) {
        final index = _model.extras.indexOf(item);
        setState(() {
          _model.extras[index].enabled = v;
        });
      },
    );
  }

  Widget _buildCustomTrailing(ReceitExtrasModel item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: () => _showFieldDialog(model: item, index: index),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 20,
          ),
          onPressed: () {
            setState(() => _model.extras.removeAt(index));
            _model.saveToStorage();
          },
        ),
      ],
    );
  }

  void _showFieldDialog({ReceitExtrasModel? model, int? index}) {
    final keyCtrl = TextEditingController(text: model?.key);
    final valCtrl = TextEditingController(text: model?.value);

    RxString align = (model?.align ?? "left").obs;
    RxString type = (model?.type ?? ReceitExtrasModel.EXTRA_NORMAL).obs;
    RxBool isBold = (model?.isBold ?? false).obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model == null ? "Add Custom Block" : "Edit Block",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MistFormInput(
                label: "Display Label (e.g. Address)",
                controller: keyCtrl,
              ),
              const SizedBox(height: 16),
              MistFormInput(label: "Value/Content", controller: valCtrl),
              const SizedBox(height: 24),
              const Text(
                "Text Alignment",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Obx(
                () => Row(
                  children: ["left", "center", "right"].map((e) {
                    return Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(e, style: const TextStyle(fontSize: 12)),
                        value: e,
                        groupValue: align.value,
                        onChanged: (v) => align.value = v!,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Printer Behavior",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: type.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: ReceitExtrasModel.RECEIT_EXTRAS.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.capitalizeFirst!),
                    );
                  }).toList(),
                  onChanged: (v) => type.value = v!,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Make text bold"),
                  value: isBold.value,
                  onChanged: (v) => isBold.value = v!,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (keyCtrl.text.trim().isEmpty) {
                      Toaster.showError("Label is required");
                      return;
                    }
                    final newModel = ReceitExtrasModel(
                      key: keyCtrl.text.trim(),
                      value: valCtrl.text.trim(),
                      align: align.value,
                      isBold: isBold.value,
                      type: type.value,
                    );
                    setState(() {
                      if (index != null) {
                        _model.extras[index] = newModel;
                      } else {
                        _model.extras.add(newModel);
                      }
                    });
                    _model.saveToStorage();
                    Get.back();
                  },
                  child: const Text(
                    "Save Configuration",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  const InfoCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(45)),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates_outlined, color: color, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withAlpha(200),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
