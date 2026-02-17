import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/modifier_embedder.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/widgets/buttons/mist_default.dart';
import 'package:mistpos/controllers/items_controller.dart';

class ScreenEditModifier extends StatefulWidget {
  final ItemModifier modifier;
  const ScreenEditModifier({super.key, required this.modifier});

  @override
  State<ScreenEditModifier> createState() => _ScreenEditModifierState();
}

class _ScreenEditModifierState extends State<ScreenEditModifier> {
  final _formKey = GlobalKey<FormState>();
  final _itemsController = Get.find<ItemsController>();
  late final _itemNameController = TextEditingController(
    text: widget.modifier.name,
  );
  final _textFieldOptionsName = TextEditingController();
  final _textFieldOptionsPrice = TextEditingController();
  late final List<ModifierEmbedder> options = widget.modifier.list;
  bool _isLoading = false;
  int _currentIndexEdit = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.modifier.name}"),
        actions: [
          "Save"
              .text()
              .elevatedIconButton(
                icon: _isLoading
                    ? Padding(
                        padding: EdgeInsets.all(2),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : SizedBox.shrink(),
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.onPrimary,
                  foregroundColor: Get.theme.colorScheme.primary,
                ),
              )
              .padding(EdgeInsets.only(right: 12)),
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
                    ...options.indexed.map<Widget>((indexedElement) {
                      final e = indexedElement.$2; // The actual element
                      final index = indexedElement.$1; // The index
                      return ListTile(
                        title: e.key.text(),
                        subtitle: CurrenceConverter.selectedCurrencyInString(
                          e.value,
                        ).text(),
                        onTap: () => _editOption(e, index),
                        trailing: IconButton(
                          onPressed: () => _removeOption(e, index),
                          icon: Icon(Icons.clear),
                        ),
                      );
                    }),
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

  void _addOption() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final mod = ModifierEmbedder();
    mod.key = _textFieldOptionsName.text;
    mod.value = CurrenceConverter.baseCurrency(
      double.parse(_textFieldOptionsPrice.text),
    );
    if (_currentIndexEdit < 0) {
      setState(() {
        _textFieldOptionsName.clear();
        _textFieldOptionsPrice.clear();
        options.add(mod);
      });
      return;
    }
    if (_currentIndexEdit >= options.length) {
      Toaster.showError("invalid edit");
      return;
    }
    setState(() {
      options[_currentIndexEdit] = mod;
      _textFieldOptionsPrice.clear();
      _textFieldOptionsName.clear();
      _currentIndexEdit = -1;
    });
  }

  void _editOption(ModifierEmbedder e, int index) {
    setState(() {
      _textFieldOptionsName.text = e.key;
      _textFieldOptionsPrice.text = CurrenceConverter.selectedCurrency(
        e.value,
      ).toStringAsFixed(4);
      _currentIndexEdit = index;
    });
  }

  void _removeOption(ModifierEmbedder e, int index) {
    setState(() {
      options.removeAt(index);
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
    widget.modifier.name = _itemNameController.text.trim();
    widget.modifier.list = options;
    final result = await _itemsController.createModifier(
      widget.modifier,
      updated: true,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("modifier updated succesfully");
    }
  }
}
