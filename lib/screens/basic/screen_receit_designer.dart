import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';

class ScreenReceiptDesigner extends StatefulWidget {
  const ScreenReceiptDesigner({super.key});

  @override
  State<ScreenReceiptDesigner> createState() => _ScreenReceiptDesignerState();
}

class _ScreenReceiptDesignerState extends State<ScreenReceiptDesigner> {
  final _model = AppSettingsModel.fromStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Designer"),
        actions: [
          IconButton(
            onPressed: () {
              _model.saveToStorage();
              Toaster.showSuccess("Receipt settings saved");
              Get.back();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MistMordernLayout(
            label: "Visual Elements",
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Iconify(Bx.image, color: AppTheme.color(context)),
                title: const Text("Show Company Logo"),
                subtitle: const Text(
                  "Display logo at the top of receipt",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Switch(
                  value: _model.receitLogoPath.isNotEmpty,
                  onChanged: (val) {
                    Toaster.showError(
                      "Please use the main settings to upload/remove the logo image file.",
                    );
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Iconify(Bx.qr_scan, color: AppTheme.color(context)),
                title: const Text("Receipt QR Code"),
                subtitle: const Text(
                  "Print QR for verification",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Switch(
                  value: _model.enableQrCode,
                  onChanged: (val) {
                    setState(() => _model.enableQrCode = val);
                    _model.saveToStorage();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          MistMordernLayout(
            label: "Custom Receipt Fields (Extras)",
            children: [
              ..._model.extras.map(
                (entry) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.key),
                  subtitle: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showFieldDialog(
                          key: entry.key,
                          value: entry.value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => _removeExtra(entry.key),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _showFieldDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Add Custom Field (e.g. Address)"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const InfoCard(
            text:
                "These 'Extras' will be printed sequentially at the header or footer of your receipt depending on your printer template.",
          ),
        ],
      ),
    );
  }

  void _showFieldDialog({String? key, String? value}) {
    final keyController = TextEditingController(text: key);
    final valueController = TextEditingController(text: value);

    Get.defaultDialog(
      title: key == null ? "Add Field" : "Edit Field",
      content: Column(
        children: [
          MistFormInput(
            label: "Label (e.g. Address, TIN)",
            controller: keyController,
            enabled: key == null,
          ),
          const SizedBox(height: 10),
          MistFormInput(label: "Value", controller: valueController),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            if (keyController.text.trim().isEmpty ||
                valueController.text.trim().isEmpty) {
              Toaster.showError("Both fields are required");
              return;
            }
            setState(() {});
            _model.saveToStorage();
            Get.back();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  void _removeExtra(String key) {
    setState(() {
      _model.extras.remove(key);
    });
    _model.saveToStorage();
    Toaster.showSuccess("Field removed");
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  const InfoCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.color(context).withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}
