import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/color_list.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/item_categories_model.dart';

class ScreenEditCategory extends StatefulWidget {
  final ItemCategoryModel itemCategoryModel;
  const ScreenEditCategory({super.key, required this.itemCategoryModel});

  @override
  State<ScreenEditCategory> createState() => _ScreenEditCategoryState();
}

class _ScreenEditCategoryState extends State<ScreenEditCategory> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late final _itemNameController = TextEditingController(
    text: widget.itemCategoryModel.name,
  );
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.itemCategoryModel.name}"),
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
                                widget.itemCategoryModel.color = color
                                    .toARGB32();
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: color,
                              child:
                                  widget.itemCategoryModel.color ==
                                      color.toARGB32()
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
      ),
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    widget.itemCategoryModel.name = _itemNameController.text;
    final result = await _itemsController.createCategory(
      widget.itemCategoryModel,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (result) {
        Get.back();
        Toaster.showSuccess("category updated succesfully");
      }
    }
  }
}
