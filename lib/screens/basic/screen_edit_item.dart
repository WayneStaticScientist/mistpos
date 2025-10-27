import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/sold_by.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/color_list.dart';
import 'package:mistpos/utils/icons_list.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';

class ScreenEditItem extends StatefulWidget {
  final ItemModel model;
  const ScreenEditItem({super.key, required this.model});

  @override
  State<ScreenEditItem> createState() => _ScreenEditItemState();
}

class _ScreenEditItemState extends State<ScreenEditItem> {
  final _soldByGroup = RadioGroupController();
  final _itemRepresentation = RadioGroupController();
  final _itemsController = Get.find<ItemsController>();

  final _formKey = GlobalKey<FormState>();
  late final _itemNameController = TextEditingController(
    text: widget.model.name,
  );
  late final _itemPriceController = TextEditingController(
    text: widget.model.price.toStringAsFixed(2),
  );
  late final _itemCostController = TextEditingController(
    text: widget.model.cost.toStringAsFixed(2),
  );
  late final _itemSKUController = TextEditingController(text: widget.model.sku);
  late final _itemBarcodeController = TextEditingController(
    text: widget.model.barcode,
  );

  late final _initialStockController = TextEditingController(
    text: widget.model.stockQuantity.toString(),
  );
  late final _reorderLevelController = TextEditingController(
    text: widget.model.lowStockThreshold.toString(),
  );
  late final List<int> _modifiers = widget.model.modifierIds ?? [];

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    int selectedIndex = SellingMethods.methods.indexOf(widget.model.category);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.primary,
        title: Text('Edit ${widget.model.name}'),
        titleTextStyle: TextStyle(
          color: Get.theme.colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
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
        iconTheme: IconThemeData(color: Get.theme.colorScheme.onPrimary),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "Item Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Item Name is required",
                    label: "Item Name",
                    icon: Iconify(Bx.abacus, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _itemNameController,
                  ),
                  14.gapHeight,
                  Obx(
                    () => DropdownButton(
                      value:
                          _itemsController.categories.any(
                            (e) => e.hexId == widget.model.category,
                          )
                          ? widget.model.category
                          : null,
                      onChanged: (value) {
                        setState(() {
                          widget.model.category = value ?? '';
                        });
                      },
                      items: List.generate(
                        _itemsController.categories.length + 1,
                        (index) {
                          if (index == _itemsController.categories.length) {
                            return DropdownMenuItem(
                              value: "",
                              child: "Add New Category".text().elevatedButton(
                                onPressed: _addItem,
                              ),
                            );
                          }
                          final category = _itemsController.categories[index];
                          return DropdownMenuItem(
                            value: category.hexId,
                            child: Text(category.name),
                          );
                        },
                      ),
                      hint: Text("Select Category"),
                    ),
                  ),

                  18.gapHeight,
                  "Sold By".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  RadioGroup(
                    controller: _soldByGroup,
                    values: SellingMethods.methods,
                    indexOfDefault: selectedIndex < 0 ? 0 : selectedIndex,
                    orientation: RadioGroupOrientation.horizontal,
                    decoration: RadioGroupDecoration(
                      spacing: 10.0,
                      activeColor: Get.theme.colorScheme.primary,
                    ),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Item Price",
                    icon: Iconify(Bx.money, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _itemPriceController,
                  ),
                  "Leaving this blank will default to item cost".text(
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    label: "Item Cost",
                    validateString: "Item Cost is required",
                    icon: Iconify(Bx.wallet, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _itemCostController,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    controller: _itemSKUController,
                    label: "SKU",
                    icon: Iconify(
                      Bx.barcode,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                  ),
                  "Unique Identifier for Stock Keeping".text(
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    controller: _itemBarcodeController,
                    label: "Barcode",
                    icon: Iconify(
                      Bx.barcode_reader,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
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
            32.gapHeight,
            [
                  "Inventory Management".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  ListTile(
                    onTap: () => setState(() {
                      widget.model.trackStock = !widget.model.trackStock;
                    }),
                    contentPadding: EdgeInsets.zero,
                    title: "Track Inventory".text(),
                    trailing: Switch(
                      value: widget.model.trackStock,
                      onChanged: (val) {
                        setState(() {
                          widget.model.trackStock = val;
                        });
                      },
                      activeColor: Get.theme.colorScheme.primary,
                    ),
                  ),
                  if (widget.model.trackStock) ...[
                    MistFormInput(
                      label: "Initial Stock Quantity",
                      underLineColor: Colors.grey.withAlpha(200),
                      icon: Iconify(Bx.cube, color: Colors.grey.withAlpha(200)),
                      controller: _initialStockController,
                    ),
                    14.gapHeight,
                    MistFormInput(
                      label: "Reorder Level",
                      icon: Iconify(
                        Bx.refresh,
                        color: Colors.grey.withAlpha(200),
                      ),
                      underLineColor: Colors.grey.withAlpha(200),
                      controller: _reorderLevelController,
                    ),
                  ],
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
                  "Modifiers".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ..._itemsController.modifiers.map<Widget>(
                    (mod) => ListTile(
                      onTap: () => setState(() {
                        setState(() {
                          if (_modifiers.contains(mod.id)) {
                            _modifiers.remove(mod.id);
                          } else {
                            _modifiers.add(mod.id);
                          }
                        });
                      }),
                      contentPadding: EdgeInsets.zero,
                      title: mod.name.text(),
                      trailing: Switch(
                        value: _modifiers.contains(mod.id),
                        onChanged: (val) {
                          setState(() {
                            if (_modifiers.contains(mod.id)) {
                              _modifiers.remove(mod.id);
                            } else {
                              _modifiers.add(mod.id);
                            }
                          });
                        },
                        activeColor: Get.theme.colorScheme.primary,
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
            32.gapHeight,
            [
                  "Item Appearance on POS Screen".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  18.gapHeight,
                  "Sold By".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  RadioGroup(
                    controller: _itemRepresentation,
                    values: ["Icons And Color", "Image Only"],
                    indexOfDefault: 0,
                    orientation: RadioGroupOrientation.horizontal,
                    decoration: RadioGroupDecoration(
                      spacing: 10.0,
                      activeColor: Get.theme.colorScheme.primary,
                    ),
                  ),
                  32.gapHeight,
                  _itemAndColorPicker(),
                  _iconPicker(), // Implement this widget as needed
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

  void _addItem() {
    final categoryNameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('Add New Category'),
        content: MistFormInput(
          controller: categoryNameController,
          label: "Category Name",
          icon: Iconify(Bx.category, color: Colors.grey.withAlpha(200)),
          underLineColor: Colors.grey.withAlpha(200),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final categoryName = categoryNameController.text.trim();
              if (categoryName.isEmpty) {
                Toaster.showError('Category name cannot be empty');
                return;
              }
              _itemsController.createCategory(
                ItemCategoryModel(name: categoryName),
              );
              Get.back();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _itemAndColorPicker() {
    return Wrap(
      children: ColorList.colors
          .map(
            (color) => GestureDetector(
              onTap: () {
                setState(() {
                  widget.model.color = color.toARGB32();
                });
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: widget.model.color == color.toARGB32()
                    ? Icon(Icons.check, color: Colors.white)
                    : null,
              ).padding(EdgeInsets.all(4)),
            ),
          )
          .toList(),
    );
  }

  Widget _iconPicker() {
    return Wrap(
      children: IconsList.icons
          .map(
            (iconPath) => GestureDetector(
              onTap: () {
                setState(() {
                  widget.model.shape = iconPath;
                });
              },
              child: Iconify(
                iconPath,
                size: 40,
                color: widget.model.shape == iconPath
                    ? Color(int.parse('0x${widget.model.color!}'))
                    : Colors.grey,
              ).padding(EdgeInsets.all(4)),
            ),
          )
          .toList(),
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final cost = double.tryParse(_itemCostController.text.trim()) ?? 0.0;
    if (cost <= 0) {
      Toaster.showError('Item Cost must be greater than zero');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    double price = 0;
    if (_itemPriceController.text.isNotEmpty) {
      price = double.tryParse(_itemPriceController.text.trim()) ?? 0.0;
    } else {
      price = cost;
    }
    widget.model.modifierIds = _modifiers;
    widget.model.price = price;
    widget.model.cost = cost;
    widget.model.name = _itemNameController.text;
    widget.model.sku = _itemSKUController.text;
    widget.model.barcode = _itemBarcodeController.text;
    widget.model.lowStockThreshold =
        int.tryParse(_reorderLevelController.text) ?? 0;
    widget.model.stockQuantity =
        int.tryParse(_initialStockController.text) ?? 0;
    final soldBy = _soldByGroup.value as String;
    widget.model.soldBy = soldBy;
    final response = await _itemsController.createItem(widget.model);
    setState(() {
      _isLoading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess('Item created successfully');
    }
  }
}
