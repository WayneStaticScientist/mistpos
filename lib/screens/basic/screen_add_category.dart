import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/color_list.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class ScreenAddCategory extends StatefulWidget {
  const ScreenAddCategory({super.key});

  @override
  State<ScreenAddCategory> createState() => _ScreenAddCategoryState();
}

class _ScreenAddCategoryState extends State<ScreenAddCategory> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Color _selectedColor = ColorList.colors.first;
  final _itemNameController = TextEditingController();
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Category"),
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
                  "Category Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Category Name is required",
                    label: "Category Name",
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
            32.gapHeight,
            [
                  18.gapHeight,
                  "Select Color".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Wrap(
                    children: ColorList.colors
                        .map(
                          (color) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: color,
                              child: _selectedColor == color
                                  ? Icon(Icons.check, color: Colors.white)
                                  : null,
                            ).padding(EdgeInsets.all(4)),
                          ),
                        )
                        .toList(),
                  ), // Implement this widget as needed
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
      ).constrained(maxWidth: 600).center(),
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final result = await _itemsController.createCategory(
      ItemCategoryModel(
        name: _itemNameController.text,
        color: _selectedColor.toARGB32(),
      ),
      update: false,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (result) {
        Get.back();
        Toaster.showSuccess("category added succesfully");
      }
    }
  }
}
