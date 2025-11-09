import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/color_list.dart';
import 'package:mistpos/utils/icons_list.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as rg;
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenAddItem extends StatefulWidget {
  const ScreenAddItem({super.key});

  @override
  State<ScreenAddItem> createState() => _ScreenAddItemState();
}

class _ScreenAddItemState extends State<ScreenAddItem> {
  final _soldByGroup = RadioGroupController();
  final _itemRepresentation = RadioGroupController();
  final _itemsController = Get.find<ItemsController>();
  bool _isCompositeItem = false;
  bool _useProduction = false;
  final _formKey = GlobalKey<FormState>();
  final _userController = Get.find<UserController>();
  final _itemSKUController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemCostController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemBarcodeController = TextEditingController();
  final _initialStockController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  final _inventorController = Get.find<InventoryController>();
  final List<String> _modifiers = [];
  bool _isLoading = false;
  String? _selectedCategory;
  bool _isTrackingInventory = false;
  String _selectedIcon = IconsList.icons.first;
  Color _selectedColor = ColorList.colors.first;
  bool _isForSale = true;
  @override
  void dispose() {
    _modifiers.clear();
    _itemSKUController.dispose();
    _itemNameController.dispose();
    _itemCostController.dispose();
    _itemPriceController.dispose();
    _itemBarcodeController.dispose();
    _initialStockController.dispose();
    _reorderLevelController.dispose();
    _inventorController.selectedInvItems.clear();
    _selectedCategory = null;
    super.dispose();
  }

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
            _makeItemInformationSection(),
            32.gapHeight,
            _inventoryManagementSection(),
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
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            32.gapHeight,
            MistMordernLayout(
              label: "Item Appearance on POS Screen",
              children: [
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
                _iconPicker(),
              ],
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

  void _scanBarCode() async {
    String barcodeScanResult;
    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Line color
        'Cancel',
        true,
        ScanMode.BARCODE, // Scan mode
      );
    } catch (e) {
      Toaster.showError("Error : $e");
      return;
    }

    if (!mounted) return;
    setState(() {
      _itemBarcodeController.text = barcodeScanResult;
    });
  }

  _inventoryManagementSection() {
    return MistMordernLayout(
      label: "Inventory Management",
      children: [
        14.gapHeight,
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: "Composite Item".text(),
          trailing: Switch(
            value: _isCompositeItem,
            onChanged: (e) {
              setState(() {
                _isCompositeItem = e;
              });
            },
          ),
        ),
        14.gapHeight,
        if (_isCompositeItem) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: "Use Production".text(),
            subtitle: "track stock on this item as whole".text(
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: Switch(
              value: _useProduction,
              onChanged: (e) {
                setState(() {
                  _useProduction = e;
                });
              },
            ),
          ),
          14.gapHeight,
        ],
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
        if ((_isTrackingInventory && _useProduction) ||
            (!_isCompositeItem && _isTrackingInventory)) ...[
          MistFormInput(
            label: "Initial Stock Quantity",
            underLineColor: Colors.grey.withAlpha(200),
            icon: Iconify(Bx.cube, color: Colors.grey.withAlpha(200)),
            controller: _initialStockController,
          ),
          14.gapHeight,
          MistFormInput(
            label: "Reorder Level",
            icon: Iconify(Bx.refresh, color: Colors.grey.withAlpha(200)),
            underLineColor: Colors.grey.withAlpha(200),
            controller: _reorderLevelController,
          ),
        ],
        if (_isCompositeItem) _compositeListItem(),
      ],
    );
  }

  _makeItemInformationSection() {
    return MistMordernLayout(
      label: "Item Information",
      children: [
        14.gapHeight,
        MistFormInput(
          validateString: "Item Name is required",
          label: "Item Name",
          icon: Iconify(Bx.abacus, color: Colors.grey.withAlpha(200)),
          underLineColor: Colors.grey.withAlpha(200),
          controller: _itemNameController,
        ),
        14.gapHeight,
        ListTile(
          onTap: () => setState(() {
            _isForSale = !_isForSale;
          }),
          contentPadding: EdgeInsets.zero,
          title: "Item is available for sale".text(),
          leading: Checkbox(
            value: _isForSale,
            onChanged: (e) {
              setState(() {
                _isForSale = e ?? false;
              });
            },
          ),
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
            items: List.generate(_itemsController.categories.length + 1, (
              index,
            ) {
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
            }),
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
          icon: (_userController.user.value?.baseCurrence ?? 'USD').text(
            style: TextStyle(fontSize: 8),
          ),
          underLineColor: Colors.grey.withAlpha(200),
          controller: _itemPriceController,
        ),
        "Leaving this blank will make it price on sale".text(
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (!_isCompositeItem) ...[
          14.gapHeight,
          MistFormInput(
            label: "Item Cost",
            validateString: "Item Cost is required",
            icon: (_userController.user.value?.baseCurrence ?? 'USD').text(
              style: TextStyle(fontSize: 8),
            ),
            underLineColor: Colors.grey.withAlpha(200),
            controller: _itemCostController,
          ),
        ],
        14.gapHeight,
        MistFormInput(
          controller: _itemSKUController,
          label: "SKU",
          icon: Iconify(Bx.barcode, color: Colors.grey.withAlpha(200)),
          underLineColor: Colors.grey.withAlpha(200),
        ),
        "Unique Identifier for Stock Keeping".text(
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        14.gapHeight,
        MistFormInput(
          controller: _itemBarcodeController,
          label: "Barcode",
          icon: Iconify(Bx.barcode_reader, color: Colors.grey.withAlpha(200)),
          underLineColor: Colors.grey.withAlpha(200),
          suffixIcon: IconButton(
            onPressed: _scanBarCode,
            icon: Iconify(Bx.barcode_reader, color: Colors.red),
          ),
        ),
      ],
    );
  }

  _compositeListItem() {
    return Obx(
      () =>
          [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: "Composite Items".text(),
              trailing: IconButton(
                onPressed: () => Get.to(() => ScreenSelectPurchaseOrderItems()),
                icon: Icon(Icons.add),
              ),
            ),
            "tap on items to adjust their quantity"
                .text(style: TextStyle(fontSize: 12, color: Colors.grey))
                .visibleIf(_inventorController.selectedInvItems.isNotEmpty),
            "There are no composite items selected , please select one"
                .text(style: TextStyle(color: Colors.red))
                .visibleIf(_inventorController.selectedInvItems.isEmpty),
            ..._inventorController.selectedInvItems.map(
              (e) => ListTile(
                onTap: () => _editItem(e),
                title: e.name.text(),
                leading: CircleAvatar(
                  child: e.quantity.toString().text(
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => _removeItem(e),
                  icon: Icon(Icons.close),
                ),
                subtitle: CurrenceConverter.getCurrenceFloatInStrings(
                  e.cost * e.quantity,
                  _userController.user.value?.baseCurrence ?? '',
                ).text(style: TextStyle(color: Colors.green)),
              ),
            ),
            ListTile(
              title: "Total Cost".text(),
              trailing: CurrenceConverter.getCurrenceFloatInStrings(
                _inventorController.selectedInvItems
                    .map((e) => e.cost * e.quantity)
                    .fold(0.0, (value, element) => value + element),
                _userController.user.value?.baseCurrence ?? '',
              ).text(style: TextStyle(color: Colors.green, fontSize: 16)),
            ),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
    );
  }

  _editItem(InvItem e) {
    final itemCountController = TextEditingController(
      text: e.quantity.toString(),
    );
    Get.defaultDialog(
      title: "Edit Item",
      content: MistFormInput(
        label: "Item Count",
        controller: itemCountController,
      ),
      actions: [
        'cancel'.text().textButton(onPressed: () => Get.back()),
        'save'.text().textButton(
          onPressed: () {
            final quantity = double.tryParse(itemCountController.text.trim());
            if (quantity == null || quantity <= 0) {
              Toaster.showError("Invalid quantity");
              return;
            }
            e.quantity = quantity;
            _inventorController.updateInvItem(e);
            Get.back();
          },
        ),
      ],
    );
  }

  void _removeItem(InvItem e) {
    _inventorController.removeodel(e);
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    double cost = (_isCompositeItem)
        ? _inventorController.selectedInvItems
              .map((e) => e.cost * e.quantity)
              .fold(0.0, (value, element) => value + element)
        : double.tryParse(_itemCostController.text.trim()) ?? 0.0;
    if (cost <= 0) {
      Toaster.showError('Item Cost must be greater than zero');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (_isCompositeItem && _inventorController.selectedInvItems.isEmpty) {
      Toaster.showError('Please select at least one compisite item');
      return;
    }
    double price = double.tryParse(_itemPriceController.text.trim()) ?? 0.0;
    final soldBy = _soldByGroup.value as String;
    final itemModel = ItemModel(
      price: price,
      cost: cost,
      avatar: "",
      soldBy: soldBy,
      shape: _selectedIcon,
      isForSale: _isForSale,
      modifiers: _modifiers,
      useProduction: _useProduction,
      trackStock: _isTrackingInventory,
      color: _selectedColor.toARGB32(),
      category: _selectedCategory ?? "",
      isCompositeItem: _isCompositeItem,
      sku: _itemSKUController.text.trim(),
      name: _itemNameController.text.trim(),
      barcode: _itemBarcodeController.text.trim(),
      compositeItems: _inventorController.selectedInvItems,
      stockQuantity: int.tryParse(_initialStockController.text.trim()) ?? 0,
      lowStockThreshold: int.tryParse(_reorderLevelController.text.trim()) ?? 0,
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
      _inventorController.selectedInvItems.clear();

      Get.back();
      Toaster.showSuccess('Item created successfully');
    }
  }
}
