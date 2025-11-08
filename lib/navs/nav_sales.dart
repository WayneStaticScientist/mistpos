import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/layouts/cards_recent.dart';
import 'package:mistpos/widgets/layouts/layout_cashout.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/layouts/list_tile_item.dart';
import 'package:mistpos/widgets/layouts/cards_category.dart';
import 'package:mistpos/screens/basic/screen_manual_cart.dart';
import 'package:mistpos/screens/basic/screen_settings_page.dart';
import 'package:mistpos/screens/basic/screen_edit_manual_cart.dart';
import 'package:mistpos/screens/basic/screens_select_customers.dart';
import 'package:mistpos/screens/basic/screen_view_selected_customer.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

class NavSale extends StatefulWidget {
  const NavSale({super.key});

  @override
  State<NavSale> createState() => _NavSaleState();
}

class _NavSaleState extends State<NavSale> {
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  final TextEditingController _searchController = TextEditingController();
  final _refreshController = RefreshController();
  bool _inSearchMode = false;
  String _searchTerm = "";
  int _animationSpeed = 0;
  double _leftPosition = 0.0; // Left position
  double _topPosition = 1000.0; // Off-screen initial position
  double _animatedOpacity = 0.0;
  final GlobalKey _bottomBarKey = GlobalKey();
  final _scrollController = ScrollController();

  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _initializeTimer();
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
    return LayoutBuilder(
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
    );
  }

  _buildNormalFlowLayout() {
    return Stack(
      children: [
        Positioned.fill(
          child: SmartRefresher(
            enablePullUp: true,
            onRefresh: () async {
              await _itemsListController.loadCartItems(
                page: 1,
                search: _searchTerm,
              );
              _refreshController.refreshCompleted();
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
                SliverAppBar(
                  elevation: 0,
                  floating: true,
                  title: "MistPos".text(),
                  backgroundColor: Get.theme.scaffoldBackgroundColor,
                  actions: [
                    Obx(
                      () => (_itemsListController.syncingItems.value)
                          ? IconButton(
                              onPressed: () {},
                              icon: const CircularProgressIndicator(
                                strokeWidth: 3,
                              ).sizedBox(height: 16, width: 16),
                            )
                          : SizedBox.shrink(),
                    ),
                    Obx(
                      () =>
                          (_itemsListController
                              .syncingItemsFailed
                              .value
                              .isNotEmpty)
                          ? IconButton(
                              onPressed: _displayError,
                              icon: Iconify(Bx.error, color: Colors.red),
                            )
                          : SizedBox.shrink(),
                    ),
                    Obx(() {
                      bool selected =
                          _itemsListController.selectedCustomer.value != null;
                      return IconButton(
                        onPressed: () => selected
                            ? Get.to(() => ScreenViewSelectedCustomer())
                            : Get.to(() => ScreensListCustomers()),
                        icon: Iconify(
                          selected ? Bx.user_check : Bx.user_plus,
                          color: selected
                              ? Colors.green
                              : AppTheme.color(context),
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () => Get.to(() => ScreenSettingsPage()),
                      icon: Iconify(Bx.cog, color: AppTheme.color(context)),
                    ),
                  ],
                ),
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
                _buidItemList(),
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
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Obx(
              () => CardsCategory(
                onTap: () => _changeCategory(""),
                isSelected: _itemsListController.selectedCategory.value == "",
                category: "All",
              ),
            ),
            Obx(
              () => _itemsListController.categories
                  .map<Widget>((category) {
                    return CardsCategory(
                      onTap: () => _changeCategory(category.hexId),
                      category: category.name,
                      isSelected:
                          _itemsListController.selectedCategory.value ==
                          category.hexId,
                    ).sizedBox(height: 60);
                  })
                  .toList()
                  .row(mainAxisSize: MainAxisSize.min),
            ),
          ],
        ).sizedBox().padding(EdgeInsets.symmetric(horizontal: 18)),
      ),
    );
  }

  _buidItemList() {
    return Obx(
      () => _itemsListController.cartItems.isNotEmpty
          ? SliverList.builder(
              itemBuilder: (context, index) =>
                  index >= _itemsListController.cartItems.length
                  ? _makeLastList()
                  : MistListTileItem(
                          item: _itemsListController.cartItems[index],
                        )
                        .padding(EdgeInsets.symmetric(horizontal: 18))
                        .onTapUp(
                          (e) => _handleWidgetClick(
                            e,
                            _itemsListController.cartItems[index],
                          ),
                        )
                        .padding(
                          EdgeInsets.only(
                            bottom:
                                index ==
                                    _itemsListController.cartItems.length - 1
                                ? 100
                                : 0,
                          ),
                        ),
              itemCount: _itemsListController.cartItems.length + 1,
            )
          : SliverFillRemaining(
              child:
                  [
                        Iconify(Bx.cart_alt, color: AppTheme.color(context)),
                        12.gapHeight,
                        "no items".text(),
                      ]
                      .column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                      .center(),
            ),
    );
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

  void _handleWidgetClick(TapUpDetails details, ItemModel model) async {
    if (_itemsListController.syncingItems.value) {
      Toaster.showError("items syncing please wait");
      return;
    }
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

    final double clickX = details.globalPosition.dx;
    final double clickY = details.globalPosition.dy;

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

  void _displayError() {
    Toaster.showError(_itemsListController.syncingItemsFailed.value);
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

  Widget _makeLastList() {
    if (_itemsListController.itemsPage.value <
        _itemsListController.totalPages.value) {
      return [
        CircularProgressIndicator().sizedBox(width: 20, height: 20),
      ].row(mainAxisAlignment: MainAxisAlignment.center);
    }
    return SizedBox.shrink();
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
}
