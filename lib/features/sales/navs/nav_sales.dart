import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/core/widgets/inputs/input_form.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/core/widgets/layouts/cards_recent.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/widgets/layouts/layout_cashout.dart';
import 'package:mistpos/features/settings/screens/screen_manual_cart.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/sales/widgets/sales_app_bar.dart';
import 'package:mistpos/features/sales/widgets/sales_item_list.dart';
import 'package:mistpos/features/sales/widgets/sales_item_grid.dart';
import 'package:mistpos/features/sales/widgets/sales_tax_list.dart';
import 'package:mistpos/features/settings/screens/screen_edit_manual_cart.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:mistpos/features/sales/widgets/sales_discounts_list.dart';
import 'package:mistpos/features/sales/widgets/sales_categories_list.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

class NavSale extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavSale({super.key, this.scaffoldKey});

  @override
  State<NavSale> createState() => _NavSaleState();
}

class _NavSaleState extends State<NavSale> {
  Timer? _debounce;
  String _searchTerm = "";
  int _animationSpeed = 0;
  double _leftPosition = 0.0; // Left position
  bool _inSearchMode = false;
  double _topPosition = 1000.0; // Off-screen initial position
  double _animatedOpacity = 0.0;
  String _selectedListGroup = "*";
  final GlobalKey _scanKey = GlobalKey();
  final GlobalKey _bottomBarKey = GlobalKey();
  final _scrollController = ScrollController();
  final _refreshController = RefreshController();
  final _userController = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();
  final _itemsListController = Get.find<ItemsController>();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _itemsListController.loadDiscounts(page: 1);
    _scrollController.addListener(_scrollListener);
  }

  @override
  dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = AppSettingsModel.fromStorage();
    return BarcodeKeyboardListener(
      bufferDuration: const Duration(milliseconds: 200),
      onBarcodeScanned: (String p1) {
        if (model.externalBarCodeEnabled) {
          _scanBarCode(p1);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            return Row(
              children: [
                Expanded(child: _buildNormalFlowLayout()),
                SizedBox(
                  width: constraints.maxWidth * 0.5,
                  child: _selectedItemsList(),
                ),
              ],
            );
          }
          return _buildNormalFlowLayout();
        },
      ),
    );
  }

  Stack _buildNormalFlowLayout() {
    final model = AppSettingsModel.fromStorage();
    return Stack(
      children: [
        Positioned.fill(
          child: SmartRefresher(
            onLoading: () async {
              _refreshController.loadComplete();
            },
            enablePullUp: true,
            onRefresh: () async {
              await _itemsListController.syncCartItemsOnBackground();
              await _itemsListController.updateUnsyncedReceits();
              _invController.loadCompany();
              _refreshController.refreshCompleted();
              setState(() {
                _searchTerm = '';
              });
            },
            controller: _refreshController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                /*
                ==================================================================================
                    THE APP TOB BAR
                ==================================================================================
                */
                SalesAppBar(scaffoldKey: widget.scaffoldKey),
                /*
              ==============================================================================
              THE SAVED ITEMS LISTS
              ==============================================================================            
              */
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: Row(
                      children: [
                        // Search field
                        Expanded(
                          child: MistSearchField(
                            controller: _searchController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Scan button — blended, modern
                        GestureDetector(
                          onTapUp: (e) => scanItem(e),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            key: _scanKey,
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Get.theme.colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.primary
                                      .withAlpha(60),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Iconify(
                                Bx.barcode_reader,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                if (!_inSearchMode)
                  Obx(
                    () => _itemsListController.savedItems.isNotEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              height: 199,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardsRecent(
                                    savedModel:
                                        _itemsListController.savedItems[index],
                                  ).onTap(
                                    () => _itemsListController.unwrapToCart(
                                      _itemsListController.savedItems[index],
                                    ),
                                  );
                                },
                                itemCount:
                                    _itemsListController.savedItems.length,
                              ),
                            ).padding(EdgeInsets.symmetric(horizontal: 18)),
                          )
                        : SliverToBoxAdapter(child: SizedBox.shrink()),
                  ),
                /*
                  ============================================================================================
                  THE APP CATEGORIES
                  ============================================================================================
                  */
                SliverToBoxAdapter(child: SizedBox(height: 18)),
                if (!_inSearchMode) _buidCategoriesLayout(),

                /*
                ===============================================================================================
                The items LIST 
                ===============================================================================================
              */
                Obx(
                  () =>
                      _itemsListController.selectedShift.value == null &&
                          (_invController.company.value?.shiftBasedSales ?? false)
                      ? _makeShifts()
                      : _buidItemList(),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: _animationSpeed),
          curve: Curves.easeIn,
          top: _topPosition,
          left: _leftPosition,
          child: AnimatedOpacity(
            opacity: _animatedOpacity,
            duration: Duration(milliseconds: _animationSpeed),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Get.theme.colorScheme.secondary,
                    Get.theme.colorScheme.secondary.withAlpha(200),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.secondary.withAlpha(100),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  )
                ],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_bag_outlined, // 🛒 A clear "add to cart" icon
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        // --- THE TARGET BUTTON (BOTTOM STACK) ---
        Obx(
          () => _itemsListController.checkOutItems.isNotEmpty
              ? Positioned(
                  bottom: 24,
                  right: 24,
                  left: 24,
                  child: LayoutCashout(bottomBarKey: _bottomBarKey),
                )
              : Positioned.fill(child: SizedBox.shrink()),
        ),
      ],
    );
  }

  SalesCategoriesList _buidCategoriesLayout() {
    return SalesCategoriesList(
      value: _selectedListGroup,
      changeCategory: (e) => _changeCategory(e),
      onChange: (e) {
        setState(() {
          _selectedListGroup = e as String;
        });
      },
    );
  }

  StatefulWidget _buidItemList() {
    if (_selectedListGroup == "discounts") return SalesDiscountsList();
    if (_selectedListGroup == "tax") return SalesTaxList();
    final model = AppSettingsModel.fromStorage();
    if (model.useGridViewForItems) {
      return SalesItemGrid(onTap: (a, b) => _handleWidgetClick(a, b));
    }
    return SalesItemList(onTap: (a, b) => _handleWidgetClick(a, b));
  }

  SafeArea _selectedItemsList() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Obx(
          () => [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Iconify(Bx.shopping_bag, color: Get.theme.colorScheme.primary, size: 28),
                  12.gapWidth,
                  Text(
                    "Current Order",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.withAlpha(30)),
            SingleChildScrollView(
              child: _itemsListController.checkOutItems
                  .map<Widget>((e) {
                    final count = e['count'] as num;
                    final model = e['item'] as ItemModel;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      title: Text(model.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      leading: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text("x$count", style: TextStyle(color: Get.theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      onTap: () => Get.to(() => ScreenEditManualCart(map: e)),
                      subtitle: Text(
                        CurrenceConverter.getCurrenceFloatInStrings(
                          model.price,
                          _userController.user.value?.baseCurrence ?? '',
                        ),
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: CurrenceConverter.getCurrenceFloatInStrings(
                        model.price * count,
                        _userController.user.value?.baseCurrence ?? '',
                      ).text(style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    );
                  })
                  .toList()
                  .column(),
            ).expanded1,
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Get.theme.colorScheme.primary,
                    Get.theme.colorScheme.primary.withAlpha(220),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                  ),
                  CurrenceConverter.getCurrenceFloatInStrings(
                    _itemsListController.totalPrice.value,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white)),
                ],
              ),
            ),
          ].column(mainAxisSize: MainAxisSize.max),
        ),
      ),
    );
  }

  void _changeCategory(String id) {
    _itemsListController.selectedCategory.value = id;
    _itemsListController.loadCartItems(
      search: _searchTerm,
      page: 1,
      category: id,
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        _itemsListController.loadCartItems(search: _searchTerm, page: 1);
      }
      if (searchTerm.isNotEmpty && !_inSearchMode) {
        setState(() {
          _inSearchMode = true;
        });
      } else if (searchTerm.isEmpty && _inSearchMode) {
        setState(() {
          _inSearchMode = false;
        });
        _itemsListController.loadCartItems(page: 1);
      }
    });
  }

  void _handleWidgetClick(
    TapUpDetails? details,
    ItemModel model, {
    double x = 0,
    double y = 0,
  }) async {
    if (model.price == 0 ||
        (model.modifiers != null && model.modifiers!.isNotEmpty)) {
      Get.to(() => ScreenManualCart(item: model));
      return;
    }
    _itemsListController.addSelectedItem(model);
    final RenderBox? renderBox =
        _bottomBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final Offset bottomBarTopLeft = renderBox.localToGlobal(Offset.zero);
    final double targetTopPosition = bottomBarTopLeft.dy;

    final double clickX = details?.globalPosition.dx ?? x;
    final double clickY = details?.globalPosition.dy ?? y;

    setState(() {
      _topPosition = clickY;
      _leftPosition = clickX;
      _animationSpeed = 0;
      _animatedOpacity = 1;
    });

    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _topPosition = targetTopPosition;
        _leftPosition = 50;
        _animationSpeed = 400;
        _animatedOpacity = 0;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        _itemsListController.itemsPage.value <
            _itemsListController.totalPages.value) {
      _itemsListController.loadCartItems(
        page: _itemsListController.itemsPage.value + 1,
        search: _searchTerm,
      );
    }
  }

  void scanItem(TapUpDetails details) async {
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
    ItemModel? model = await _itemsListController.findModelByBarCode(
      barcodeScanResult,
    );
    if (model == null) return;
    _handleWidgetClick(details, model);
  }

  void _scanBarCode(String barcodeScanResult) async {
    if (!mounted) return;
    ItemModel? model = await _itemsListController.findModelByBarCode(
      barcodeScanResult,
    );
    if (model == null) return;
    final RenderBox? renderBox =
        _bottomBarKey.currentContext?.findRenderObject() as RenderBox?;
    _handleWidgetClick(
      null,
      model,
      x: renderBox?.localToGlobal(Offset.zero).dx ?? 150,
      y: renderBox?.localToGlobal(Offset.zero).dy ?? 100,
    );
  }

  Widget _makeShifts() {
    return SliverToBoxAdapter(
      child: [
        18.gapHeight,
        "No shifts Opened ".text(),
        32.gapHeight,
        "Open Shift".text().textButton(
          onPressed: _initiateAlertShift,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Get.theme.colorScheme.primary,
          ),
        ),
      ].column(),
    );
  }

  void _initiateAlertShift() {
    final shiftAmount = TextEditingController();
    if (_itemsListController.selectedShift.value != null) {
      Toaster.showError("shift already opened");
      return;
    }
    if (_userController.user.value == null) {
      Toaster.showError("User underegister");
      return;
    }
    Get.defaultDialog(
      title: "Open Shift",
      content:
          [
            "Specify Amount in drawer at start of shift".text(
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            8.gapHeight,
            MistFormInput(
              label: "Amount in drawer",
              controller: shiftAmount,
              icon: (_userController.user.value?.baseCurrence ?? 'USD').text(
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
      actions: [
        "Cancel".text().textButton(onPressed: () => Get.back()),
        "open".text().textButton(
          onPressed: () {
            final amount = double.tryParse(shiftAmount.text);
            if (amount == null || amount < 0) {
              Toaster.showError("invalid number");
              return;
            }
            Get.back();
            _itemsListController.openShift(amount, _userController.user.value!);
          },
        ),
      ],
    );
  }
}
