import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
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
import 'package:mistpos/widgets/sales_widgets/sales_app_bar.dart';
import 'package:mistpos/widgets/sales_widgets/sales_item_list.dart';
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

  _buildNormalFlowLayout() {
    final model = AppSettingsModel.fromStorage();
    return Stack(
      children: [
        Positioned.fill(
          child: SmartRefresher(
            enablePullUp: true,
            onRefresh: () async {
              await _itemsListController.syncCartItemsOnBackground();
              await _itemsListController.updateUnsyncedReceits();
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
                          model.prioritizeShift
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

  _buidCategoriesLayout() {
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

  _buidItemList() {
    if (_selectedListGroup == "discounts") return SalesDiscountsList();
    if (_selectedListGroup == "tax") return SalesTaxList();
    return SalesItemList(onTap: (a, b) => _handleWidgetClick(a, b));
  }

  _selectedItemsList() {
    return SafeArea(
      child: Obx(
        () => [
          SingleChildScrollView(
            child: _itemsListController.checkOutItems
                .map<Widget>((e) {
                  final count = e['count'] as int;
                  final model = e['item'] as ItemModel;
                  return ListTile(
                    title: Text(model.name, style: TextStyle(fontSize: 24)),
                    leading: Text("x $count"),
                    onTap: () => Get.to(() => ScreenEditManualCart(map: e)),
                    subtitle: Text(
                      CurrenceConverter.getCurrenceFloatInStrings(
                        model.price,
                        _userController.user.value?.baseCurrence ?? '',
                      ),
                    ),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      model.price * count,
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(style: TextStyle(fontSize: 24)),
                  );
                })
                .toList()
                .column(),
          ).expanded1,
          12.gapHeight,
          ListTile(
            tileColor: Colors.green,
            textColor: Colors.white,
            title: Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            trailing: CurrenceConverter.getCurrenceFloatInStrings(
              _itemsListController.totalPrice.value,
              _userController.user.value?.baseCurrence ?? '',
            ).text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ),
        ].column(mainAxisSize: MainAxisSize.max),
      ),
    );
  }

  _changeCategory(String id) {
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
            Toaster.showSuccess("shift opened");
            _itemsListController.openShift(amount, _userController.user.value!);
          },
        ),
      ],
    );
  }
}
