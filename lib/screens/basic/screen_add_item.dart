import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/color_list.dart';
import 'package:mistpos/utils/icons_list.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as rg;
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';

class ScreenAddItem extends StatefulWidget {
  const ScreenAddItem({super.key});

  @override
  State<ScreenAddItem> createState() => _ScreenAddItemState();
}

class _ScreenAddItemState extends State<ScreenAddItem> {
  final _soldByGroup = RadioGroupController();
  final _itemRepresentation = RadioGroupController();
  final _itemsController = Get.find<ItemsController>();

  final _formKey = GlobalKey<FormState>();
  final _itemSKUController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemCostController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemBarcodeController = TextEditingController();

  final _initialStockController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  final List<String> _modifiers = [];
  bool _isLoading = false;
  String? _selectedCategory;
  bool _isTrackingInventory = false;
  String _selectedIcon = IconsList.icons.first;
  Color _selectedColor = ColorList.colors.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text('Add Item'),
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
                  32.gapHeight,
                  Obx(
                    () => DropdownButton(
                      value: _selectedCategory,
                      isDense: true,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
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
                    ).sizedBox(width: double.infinity),
                  ),

                  24.gapHeight,
                  "Sold By".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  rg.RadioGroup(
                    controller: _soldByGroup,
                    values: ["Each", "Weight"],
                    indexOfDefault: 0,
                    orientation: rg.RadioGroupOrientation.horizontal,
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
                  "Leaving this blank will make it price on sale".text(
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
                      _isTrackingInventory = !_isTrackingInventory;
                    }),
                    contentPadding: EdgeInsets.zero,
                    title: "Track Inventory".text(),
                    trailing: Switch(
                      value: _isTrackingInventory,
                      onChanged: (val) {
                        setState(() {
                          _isTrackingInventory = val;
                        });
                      },
                      activeThumbColor: Get.theme.colorScheme.primary,
                    ),
                  ),
                  if (_isTrackingInventory) ...[
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
                  Obx(
                    () => _itemsController.modifiersLoading.value
                        ? MistLoader1()
                        : SizedBox.shrink(),
                  ),
                  ..._itemsController.modifiers.map<Widget>(
                    (mod) => ListTile(
                      onTap: () => setState(() {
                        setState(() {
                          if (_modifiers.contains(mod.hexId)) {
                            _modifiers.remove(mod.hexId);
                          } else {
                            _modifiers.add(mod.hexId);
                          }
                        });
                      }),
                      contentPadding: EdgeInsets.zero,
                      title: mod.name.text(),
                      trailing: Switch(
                        value: _modifiers.contains(mod.hexId),
                        onChanged: (val) {
                          setState(() {
                            if (_modifiers.contains(mod.hexId)) {
                              _modifiers.remove(mod.hexId);
                            } else {
                              _modifiers.add(mod.hexId);
                            }
                          });
                        },
                        activeThumbColor: Get.theme.colorScheme.primary,
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
                  rg.RadioGroup(
                    controller: _itemRepresentation,
                    values: ["Icons And Color", "Image Only"],
                    indexOfDefault: 0,
                    orientation: rg.RadioGroupOrientation.horizontal,
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
            onPressed: () async {
              final categoryName = categoryNameController.text.trim();
              if (categoryName.isEmpty) {
                Toaster.showError('Category name cannot be empty');
                return;
              }
              Get.back();
              setState(() {
                _isLoading = true;
              });
              await _itemsController.createCategory(
                ItemCategoryModel(name: categoryName),
                update: false,
              );
              if (!mounted) return;
              setState(() {
                _isLoading = false;
              });
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
    );
  }

  Widget _iconPicker() {
    return Wrap(
      children: IconsList.icons
          .map(
            (iconPath) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = iconPath;
                });
              },
              child: Iconify(
                iconPath,
                size: 40,
                color: _selectedIcon == iconPath ? _selectedColor : Colors.grey,
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
    double price = double.tryParse(_itemPriceController.text.trim()) ?? 0.0;
    final soldBy = _soldByGroup.value as String;
    final itemModel = ItemModel(
      name: _itemNameController.text.trim(),
      category: _selectedCategory ?? "",
      price: price,
      cost: cost,
      soldBy: soldBy,
      modifiers: _modifiers,
      sku: _itemSKUController.text.trim(),
      barcode: _itemBarcodeController.text.trim(),
      trackStock: _isTrackingInventory,
      stockQuantity: int.tryParse(_initialStockController.text.trim()) ?? 0,
      lowStockThreshold: int.tryParse(_reorderLevelController.text.trim()) ?? 0,
      color: _selectedColor.toARGB32(),
      shape: _selectedIcon,
      avatar: "",
    );
    final response = await _itemsController.createItem(
      itemModel,
      update: false,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess('Item created successfully');
    }
  }
}
