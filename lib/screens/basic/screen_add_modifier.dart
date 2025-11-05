import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/modifier_embedder.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_default.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class ScreenAddModifier extends StatefulWidget {
  const ScreenAddModifier({super.key});

  @override
  State<ScreenAddModifier> createState() => _ScreenAddModifierState();
}

class _ScreenAddModifierState extends State<ScreenAddModifier> {
  final _formKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();
  final _itemsController = Get.find<ItemsController>();
  final _itemNameController = TextEditingController();
  final _textFieldOptionsName = TextEditingController();
  final _textFieldOptionsPrice = TextEditingController();
  final List<Map<String, dynamic>> options = [];
  bool _isLoading = false;
  int _currentIndexEdit = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Modifier"),
        actions: [
          MistLoadIconButton(
            label: 'Save',
            isLoading: _isLoading,
            onPressed: _saveItem,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Modifier".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Modifier Name is required",
                    label: "Modifier Name",
                    icon: Iconify(Bx.abacus, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _itemNameController,
                  ),
                  14.gapHeight,
                ]
                .column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                )
                .padding(EdgeInsets.all(12))
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            if (options.isNotEmpty) ...[
              32.gapHeight,
              [
                    18.gapHeight,
                    "Options".text(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ...options.map<Widget>(
                      (e) => ListTile(
                        title: "${e['key']}".text(),
                        subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                          (e['value'] as num?)?.toDouble() ?? 0.0,
                          _userController.user.value?.baseCurrence ?? '',
                        ).text(),
                        onTap: () => _editOption(e),
                        trailing: IconButton(
                          onPressed: () => _removeOption(e),
                          icon: Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ]
                  .column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                  )
                  .padding(EdgeInsets.all(12))
                  .decoratedBox(
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
            ],
            32.gapHeight,
            [
                  18.gapHeight,
                  "Options".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  MistFormInput(
                    validateString: "Option Name is required",
                    label: "Option Name",
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _textFieldOptionsName,
                  ),
                  18.gapHeight,
                  MistFormInput(
                    label: "Price",
                    validateString: "Option Price is required",
                    keyboardType: TextInputType.number,
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _textFieldOptionsPrice,
                  ),
                  18.gapHeight,
                  MistButton(text: "Save Option", onPressed: _addOption),
                  // Implement this widget as needed
                ]
                .column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                )
                .padding(EdgeInsets.all(12))
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  _addOption() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_currentIndexEdit < 0) {
      setState(() {
        options.add({
          "index": options.length,
          "key": _textFieldOptionsName.text,
          "value": double.parse(_textFieldOptionsPrice.text),
        });
        _textFieldOptionsName.clear();
        _textFieldOptionsPrice.clear();
      });
      return;
    }
    if (_currentIndexEdit >= options.length) {
      Toaster.showError("invalid edit");
      return;
    }
    setState(() {
      options[_currentIndexEdit] = {
        "index": options.length,
        "key": _textFieldOptionsName.text,
        "value": double.parse(_textFieldOptionsPrice.text),
      };
      _textFieldOptionsPrice.clear();
      _textFieldOptionsName.clear();
      _currentIndexEdit = -1;
    });
  }

  void _editOption(Map e) {
    setState(() {
      _textFieldOptionsName.text = e['key'];
      _textFieldOptionsPrice.text = e['value'].toString();
      _currentIndexEdit = e['index'];
    });
  }

  void _removeOption(Map e) {
    setState(() {
      options.removeWhere((element) => element['index'] == e['index']);
    });
  }

  void _saveItem() async {
    if (options.isEmpty) {
      Toaster.showError("no options added");
      return;
    }
    if (_itemNameController.text.trim().isEmpty) {
      Toaster.showError("item name is required");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final result = await _itemsController.createModifier(
      ItemModifier(
        name: _itemNameController.text.trim(),
        list: options.map((e) => ModifierEmbedder.fromJson(e)).toList(),
      ),
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("modifier added succesfully");
    }
  }
}
