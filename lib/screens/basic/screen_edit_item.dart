import 'dart:developer';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/sold_by.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:mistpos/utils/color_list.dart';
import 'package:mistpos/utils/icons_list.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/item_unsaved_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/layouts/list_of_all_icons.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:mistpos/controllers/items_unsaved_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart' as rg;
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:mistpos/screens/inventory/screen_select_purchase_order_items.dart';

class ScreenEditItem extends StatefulWidget {
  final ItemUnsavedModel model;
  const ScreenEditItem({super.key, required this.model});

  @override
  State<ScreenEditItem> createState() => _ScreenEditItemState();
}

class _ScreenEditItemState extends State<ScreenEditItem> {
  final _soldByGroup = RadioGroupController();
  final _itemRepresentation = RadioGroupController();
  final _itemsController = Get.find<ItemsController>();
  final _itemsUsavedController = Get.find<ItemsUnsavedController>();
  final _userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  late final _wholesalePriceController = TextEditingController(
    text: (CurrenceConverter.selectedCurrency(
      widget.model.wholesalePrice,
    )).toStringAsFixed(4),
  );
  late final _miniItemsController = TextEditingController(
    text: widget.model.miniItems.toString(),
  );

  late final _itemNameController = TextEditingController(
    text: widget.model.name,
  );
  late final _itemPriceController = TextEditingController(
    text: (CurrenceConverter.selectedCurrency(
      widget.model.price,
    )).toStringAsFixed(4),
  );
  late final _itemCostController = TextEditingController(
    text: (CurrenceConverter.selectedCurrency(
      widget.model.cost,
    )).toStringAsFixed(4),
  );
  late final _itemSKUController = TextEditingController(text: widget.model.sku);
  late final _itemBarcodeController = TextEditingController(
    text: widget.model.barcode,
  );
  final _inventorController = Get.find<InventoryController>();

  late final _initialStockController = TextEditingController(
    text: widget.model.stockQuantity.toString(),
  );
  late final _reorderLevelController = TextEditingController(
    text: widget.model.lowStockThreshold.toString(),
  );
  late final List<String> _modifiers = List.from(widget.model.modifiers ?? []);
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    log("the item is ${widget.model.toJson()}");
    if (widget.model.isCompositeItem) {
      _inventorController.selectedInvItems.clear();
      _inventorController.selectedInvItems.addAll(widget.model.compositeItems);
    }
  }

  @override
  void dispose() {
    _itemSKUController.dispose();
    _itemNameController.dispose();
    _itemCostController.dispose();
    _miniItemsController.dispose();
    _itemPriceController.dispose();
    _itemBarcodeController.dispose();
    _initialStockController.dispose();
    _reorderLevelController.dispose();
    _wholesalePriceController.dispose();
    _inventorController.selectedInvItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.primary,
        title: Text('Edit ${widget.model.name}'),
        foregroundColor: Colors.white,
        actions: [
          MistLoadIconButton(
            label: "Save",
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
            _buildItemInformationSection(),
            32.gapHeight,
            _buildInventoryManagementSection(),
            32.gapHeight,
            _wholesaleManagement(),
            32.gapHeight,
            _buildModifiersSection(),
            32.gapHeight,
            _buildDecoratorSection(),
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
                    ? Color(int.parse('${widget.model.color!}'))
                    : Colors.grey,
              ).padding(EdgeInsets.all(4)),
            ),
          )
          .toList(),
    );
  }

  _buildItemInformationSection() {
    int selectedIndex = SellingMethods.methods.indexOf(widget.model.soldBy);

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
            widget.model.isForSale = !widget.model.isForSale;
          }),
          contentPadding: EdgeInsets.zero,
          title: "Item is available for sale".text(),
          leading: Checkbox(
            value: widget.model.isForSale,
            onChanged: (e) {
              setState(() {
                widget.model.isForSale = e ?? false;
              });
            },
          ),
        ),
        32.gapHeight,
        Obx(
          () => DropdownButton(
            isDense: true,
            isExpanded: true,
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
          ),
        ),

        18.gapHeight,
        "Sold By".text(
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        rg.RadioGroup(
          controller: _soldByGroup,
          values: SellingMethods.methods,
          indexOfDefault: selectedIndex < 0 ? 0 : selectedIndex,
          orientation: rg.RadioGroupOrientation.horizontal,
          decoration: RadioGroupDecoration(
            spacing: 10.0,
            activeColor: Get.theme.colorScheme.primary,
          ),
        ),
        if (!widget.model.isCompositeItem) ...[
          14.gapHeight,
          MistFormInput(
            label: "Item Price",
            icon: (_userController.user.value?.baseCurrence ?? 'USD').text(
              style: TextStyle(fontSize: 8),
            ),
            underLineColor: Colors.grey.withAlpha(200),
            controller: _itemPriceController,
          ),
          "Leaving this blank will default to item cost".text(
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
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

  _buildInventoryManagementSection() {
    return MistMordernLayout(
      label: "Inventory Management",
      children: [
        14.gapHeight,
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: "Composite Item".text(),
          trailing: Switch(
            value: widget.model.isCompositeItem,
            onChanged: (e) {
              setState(() {
                widget.model.isCompositeItem = e;
              });
            },
          ),
        ),
        14.gapHeight,
        if (widget.model.isCompositeItem) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: "Use Production".text(),
            subtitle: "track stock on this item as whole".text(
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: Switch(
              value: widget.model.useProduction,
              onChanged: (e) {
                setState(() {
                  widget.model.useProduction = e;
                });
              },
            ),
          ),
          14.gapHeight,
        ],
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
            activeThumbColor: Get.theme.colorScheme.primary,
          ),
        ),
        if ((widget.model.trackStock && widget.model.useProduction) ||
            (!widget.model.isCompositeItem && widget.model.trackStock)) ...[
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
        if (widget.model.isCompositeItem) _compositeListItem(),
      ],
    );
  }

  _buildModifiersSection() {
    return MistMordernLayout(
      label: 'Modifiers',
      children: [
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
      ],
    );
  }

  _buildDecoratorSection() {
    return MistMordernLayout(
      label: "Item Appearance on POS Screen",
      children: [
        18.gapHeight,
        "Sold By".text(
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        rg.RadioGroup(
          controller: _itemRepresentation,
          values: ["Icons And Color"],
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
        'PickMore Icons'.text().textIconButton(
          onPressed: () async {
            final result = await pickListIcon();
            if (result != null) {
              setState(() {
                widget.model.shape = result;
              });
            }
          },
        ),
        16.gapHeight,
        'Selected Icon'.text(),
        8.gapHeight,
        if (widget.model.shape != null)
          [
            Iconify(
              widget.model.shape!,
              size: 60,
              color: Color(int.parse('${widget.model.color!}')),
            ),
          ].row(),
        // Implement this widget as needed
      ],
    );
  }

  _wholesaleManagement() {
    return MistMordernLayout(
      label: "WholeSale Management",
      children: [
        14.gapHeight,
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: "Wholesale Activated".text(),
          trailing: Switch(
            value: widget.model.wholesaleActivated,
            onChanged: (e) {
              setState(() {
                widget.model.wholesaleActivated = e;
              });
            },
          ),
        ),
        14.gapHeight,
        if (widget.model.wholesaleActivated) ...[
          14.gapHeight,
          MistFormInput(
            label: "WholeSale price",
            icon: Iconify(Bx.tag, color: Colors.grey.withAlpha(200)),
            underLineColor: Colors.grey.withAlpha(200),
            controller: _wholesalePriceController,
          ),
          14.gapHeight,
          MistFormInput(
            label: "Min items",
            icon: Iconify(Bx.hash, color: Colors.grey.withAlpha(200)),
            underLineColor: Colors.grey.withAlpha(200),
            controller: _miniItemsController,
          ),
        ],
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
    double miniItems = 0.0;
    double wholeSalePrice = 0.0;
    if (widget.model.wholesaleActivated) {
      final mValue = double.tryParse(_miniItemsController.text);
      if (mValue == null || mValue < 0) {
        Toaster.showError('Invalid number of mini items in wholesale sections');
        return;
      }

      final wValue = double.tryParse(_wholesalePriceController.text);
      if (wValue == null || wValue < 0) {
        Toaster.showError(
          'Invalid number of wholesaleprice in wholesale sections',
        );
        return;
      }
      miniItems = mValue;
      wholeSalePrice = wValue;
    }
    if (widget.model.isCompositeItem &&
        _inventorController.selectedInvItems.isEmpty) {
      Toaster.showError('Please select at least one composite item');
      return;
    }
    final cost = (widget.model.isCompositeItem)
        ? _inventorController.selectedInvItems
              .map((e) => e.cost * e.quantity)
              .fold(0.0, (value, element) => value + element)
        : double.tryParse(_itemCostController.text.trim()) ?? 0.0;
    if (cost < 0) {
      Toaster.showError('Item Cost must be greater or equal to zero');
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
    widget.model.miniItems = miniItems;
    widget.model.wholesalePrice = wholeSalePrice;
    widget.model.soldBy = _soldByGroup.value as String;
    widget.model.compositeItems = _inventorController.selectedInvItems;
    widget.model.modifiers = _modifiers;
    widget.model.price = CurrenceConverter.baseCurrency(price);
    widget.model.cost = CurrenceConverter.baseCurrency(cost);
    widget.model.name = _itemNameController.text;
    widget.model.sku = _itemSKUController.text;
    widget.model.barcode = _itemBarcodeController.text;
    widget.model.lowStockThreshold =
        int.tryParse(_reorderLevelController.text) ?? 0;
    widget.model.stockQuantity =
        int.tryParse(_initialStockController.text) ?? 0;
    final soldBy = _soldByGroup.value as String;
    widget.model.soldBy = soldBy;
    final response = await _itemsUsavedController.createItem(widget.model);
    if (!mounted) {
      return;
    }
    _itemsController.syncCartItemsOnBackground();
    setState(() {
      _isLoading = false;
    });

    if (response) {
      Get.back();
      Toaster.showSuccess('Item created successfully');
    }
  }
}
