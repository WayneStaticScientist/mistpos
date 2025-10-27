import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/widgets/layouts/cards_recent.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_checkout.dart';
import 'package:mistpos/widgets/layouts/list_tile_item.dart';
import 'package:mistpos/widgets/layouts/cards_category.dart';
import 'package:mistpos/screens/basic/screen_manual_cart.dart';
import 'package:mistpos/screens/basic/screen_edit_manual_cart.dart';

class NavSale extends StatefulWidget {
  const NavSale({super.key});

  @override
  State<NavSale> createState() => _NavSaleState();
}

class _NavSaleState extends State<NavSale> {
  final _itemsListController = Get.find<ItemsController>();
  final TextEditingController _searchController = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              SizedBox(width: 600, child: _buildNormalFlowLayout()),
              Expanded(child: _selectedItemsList()),
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
                  IconButton(onPressed: () {}, icon: Iconify(Bx.cog)),
                ],
              ),
              /*
            ==============================================================================
            THE SAVED ITEMS LISTS
            ==============================================================================            
            */
              SliverToBoxAdapter(
                child: [
                  Expanded(
                    child: MistSearchField(controller: _searchController),
                  ),
                  12.gapWidth,
                  Iconify(Bx.slider_alt)
                      .padding(
                        EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      )
                      .decoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(207),
                          color: Get.isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                ].row().padding(EdgeInsets.all(14)),
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
                              itemCount: _itemsListController.savedItems.length,
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
                  child: Container(
                    key: _bottomBarKey,
                    child:
                        Row(
                              children: [
                                [
                                  "\$${_itemsListController.totalPrice.value.toStringAsFixed(2)}"
                                      .text(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                      .textButton(
                                        onPressed: _showSelectedItems,
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Get.theme.colorScheme.onPrimary,
                                          foregroundColor:
                                              Get.theme.colorScheme.primary,
                                        ),
                                      ),
                                  18.gapWidth,
                                  "${_itemsListController.checkOutItems.length} items"
                                      .text(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                ].row().expanded1,
                                12.gapWidth,
                                "Checkout"
                                    .text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    .textButton(
                                      onPressed: () =>
                                          Get.to(() => ScreenCheckout()),
                                    ),
                              ],
                            )
                            .padding(EdgeInsets.all(18))
                            .decoratedBox(
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                  ),
                )
              : Positioned.fill(child: SizedBox.shrink()),
        ),
      ],
    );
  }

  _buidCategoriesLayout() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child:
            ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Obx(
                      () => CardsCategory(
                        onTap: () => _changeCategory(""),
                        isSelected:
                            _itemsListController.selectedCategory.value == "",
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
                )
                .sizedBox()
                .padding(EdgeInsets.symmetric(horizontal: 18))
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
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
                        .decoratedBox(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode ? Colors.black : Colors.white,
                          ),
                        )
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
              child: [Iconify(Bx.cart_alt), 12.gapHeight, "no items".text()]
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
                      CurrenceConverter.getCurrenceFloatInStrings(model.price),
                    ),
                    trailing: CurrenceConverter.getCurrenceFloatInStrings(
                      model.price * count,
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
        (model.modifierIds != null && model.modifierIds!.isNotEmpty)) {
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

  void _showSelectedItems() {
    Get.bottomSheet(
      SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: [
            "Items".text(
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => _itemsListController.checkOutItems
                  .map<Widget>((e) {
                    final count = e['count'] as int;
                    final model = e['item'] as ItemModel;
                    return Card(
                      child: ListTile(
                        title: Text(model.name),
                        leading: Text("x $count"),
                        trailing: IconButton(
                          onPressed: () =>
                              _itemsListController.removeSelectedItem(e),
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ).onTap(() => Get.to(() => ScreenEditManualCart(map: e)));
                  })
                  .toList()
                  .column(mainAxisSize: MainAxisSize.min),
            ),
          ].column(crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ).padding(EdgeInsets.all(14)),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
    );
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
}
