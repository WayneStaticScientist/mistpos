import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/screens/basic/screen_checkout.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/layouts/cards_recent.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/layouts/layout_cashout.dart';
import 'package:mistpos/screens/basic/screen_manual_cart.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/sales_widgets/sales_app_bar.dart';
import 'package:mistpos/widgets/sales_widgets/sales_item_list.dart';
import 'package:mistpos/widgets/sales_widgets/sales_item_grid.dart';
import 'package:mistpos/widgets/sales_widgets/sales_tax_list.dart';
import 'package:mistpos/screens/basic/screen_edit_manual_cart.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:mistpos/widgets/sales_widgets/sales_discounts_list.dart';
import 'package:mistpos/widgets/sales_widgets/sales_categories_list.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

class NavSale extends StatefulWidget {
  const NavSale({super.key});

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
          final isDesktop = constraints.maxWidth > 700;
          if (isDesktop) {
            return Row(
              children: [
                Expanded(
                  flex: 65,
                  child: _buildNormalFlowLayout(isDesktop: isDesktop),
                ),
                Expanded(
                  flex: 35,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface(context),
                      border: Border(
                        left: BorderSide(color: Colors.grey.withAlpha(50)),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10,
                          offset: Offset(-5, 0),
                        ),
                      ],
                    ),
                    child: _selectedItemsList(isDesktop: isDesktop),
                  ),
                ),
              ],
            );
          }
          return _buildNormalFlowLayout(isDesktop: isDesktop);
        },
      ),
    );
  }

  Stack _buildNormalFlowLayout({bool isDesktop = false}) {
    final model = AppSettingsModel.fromStorage();
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onSecondaryTapDown: (details) =>
                _showContextMenu(context, details.globalPosition),
            child: SmartRefresher(
              key: const ValueKey('nav_sale_refresher'),
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
                  SalesAppBar(),
                  /*
              ==============================================================================
              THE SAVED ITEMS LISTS
              ==============================================================================            
              */
                  SliverToBoxAdapter(
                    child:
                        [
                              Expanded(
                                child: MistSearchField(
                                  controller: _searchController,
                                ),
                              ),
                              12.gapWidth,
                              Iconify(
                                    key: _scanKey,
                                    Bx.barcode_reader,
                                    color: AppTheme.color(context),
                                  )
                                  .padding(
                                    EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                  )
                                  .decoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(207),
                                      color: AppTheme.surface(context),
                                    ),
                                  ),
                            ]
                            .row()
                            .padding(EdgeInsets.all(14))
                            .onTapUp((e) => scanItem(e)),
                  ),

                  if (!_inSearchMode)
                    Obx(
                      () => _itemsListController.savedItems.isNotEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox(
                                height: 199,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        return CardsRecent(
                                          savedModel: _itemsListController
                                              .savedItems[index],
                                        ).onTap(
                                          () =>
                                              _itemsListController.unwrapToCart(
                                                _itemsListController
                                                    .savedItems[index],
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
                            model.prioritizeShift
                        ? _makeShifts()
                        : _buidItemList(),
                  ),
                ],
              ),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withAlpha(200),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add_shopping_cart, // 🛒 A clear "add to cart" icon
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        // --- THE TARGET BUTTON (BOTTOM STACK) ---
        Obx(
          () => _itemsListController.checkOutItems.isNotEmpty && !isDesktop
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

  Widget _selectedItemsList({bool isDesktop = false}) {
    return SafeArea(
      child: Obx(
        () => [
          if (isDesktop)
            [
                  "Current Order".text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Badge.count(
                    count: _itemsListController.checkOutItems.length,
                    child: Iconify(
                      Bx.cart_alt,
                      color: AppTheme.color(context),
                      size: 28,
                    ),
                  ),
                ]
                .row(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                .padding(EdgeInsets.all(18))
                .decoratedBox(
                  decoration: BoxDecoration(color: AppTheme.surface(context)),
                ),
          if (isDesktop) Divider(height: 1, color: Colors.grey.withAlpha(50)),

          Expanded(
            child: _itemsListController.checkOutItems.isEmpty && isDesktop
                ? [
                    Iconify(
                      Bx.cart_alt,
                      size: 64,
                      color: Colors.grey.withAlpha(80),
                    ),
                    16.gapHeight,
                    "Cart is empty".text(
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ].column(mainAxisAlignment: MainAxisAlignment.center).center()
                : SingleChildScrollView(
                    child: _itemsListController.checkOutItems
                        .map<Widget>((e) {
                          final count = e['count'] as num;
                          final model = e['item'] as ItemModel;
                          return ListTile(
                            title: Text(
                              model.name,
                              style: TextStyle(
                                fontSize: isDesktop ? 16 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.primary.withAlpha(
                                  30,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "x $count",
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 20,
                                  color: Get.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () =>
                                Get.to(() => ScreenEditManualCart(map: e)),
                            subtitle: Text(
                              CurrenceConverter.getCurrenceFloatInStrings(
                                model.price,
                                _userController.user.value?.baseCurrence ?? '',
                              ),
                            ),
                            trailing:
                                CurrenceConverter.getCurrenceFloatInStrings(
                                  model.price * count,
                                  _userController.user.value?.baseCurrence ??
                                      '',
                                ).text(
                                  style: TextStyle(
                                    fontSize: isDesktop ? 16 : 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          );
                        })
                        .toList()
                        .column(),
                  ),
          ),

          if (_itemsListController.checkOutItems.isNotEmpty) ...[
            12.gapHeight,
            Divider(height: 1, color: Colors.grey.withAlpha(50)),
            ListTile(
              tileColor: isDesktop ? Colors.transparent : Colors.green,
              textColor: isDesktop ? AppTheme.color(context) : Colors.white,
              title: Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 20 : 24,
                ),
              ),
              trailing:
                  CurrenceConverter.getCurrenceFloatInStrings(
                    _itemsListController.totalPrice.value,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 20 : 24,
                      color: isDesktop
                          ? Get.theme.colorScheme.primary
                          : Colors.white,
                    ),
                  ),
            ),
            if (isDesktop)
              "Checkout"
                  .text(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .textButton(
                    onPressed: () => Get.to(() => ScreenCheckout()),
                    style: TextButton.styleFrom(
                      backgroundColor: Get.theme.colorScheme.primary,
                      minimumSize: Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                  .padding(
                    EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 8),
                  ),
          ],
        ].column(mainAxisSize: MainAxisSize.max),
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

  void _showContextMenu(BuildContext context, Offset position) async {
    final RenderObject? overlay = Overlay.of(
      context,
    ).context.findRenderObject();
    if (overlay == null) return;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.semanticBounds.size,
      ),
      items: [
        PopupMenuItem(
          value: 'refresh',
          child: Row(
            children: [
              Icon(Icons.refresh, color: Get.theme.colorScheme.primary),
              SizedBox(width: 12),
              Text('Refresh Data'),
            ],
          ),
        ),
      ],
    );

    if (result == 'refresh') {
      _refreshController.requestRefresh();
    }
  }
}
