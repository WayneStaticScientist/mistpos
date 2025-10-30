import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_add_item.dart';
import 'package:mistpos/navs/items_navs/nav_items_list.dart';
import 'package:mistpos/navs/items_navs/nav_category_list.dart';
import 'package:mistpos/screens/basic/screen_add_modifier.dart';
import 'package:mistpos/screens/basic/screen_add_category.dart';
import 'package:mistpos/navs/items_navs/nav_modifiers_list.dart';
import 'package:mistpos/navs/items_navs/nav_discounts_list.dart';

class NavItems extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavItems({super.key, this.scaffoldKey});

  @override
  State<NavItems> createState() => _NavItemsState();
}

class _NavItemsState extends State<NavItems> {
  int _selectedIndex = 0;
  final List<Widget> _navOptions = [
    NavItemsList(),
    NavCategoryList(),
    NavModifiersList(),
    NavDiscountsList(),
  ];
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerButton(
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
        ),
        title: Text('Items'),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(
            () => _itemsController.deleting.value
                ? CircularProgressIndicator(color: Colors.white)
                      .center()
                      .sizedBox(width: 16, height: 16)
                      .padding(EdgeInsets.symmetric(horizontal: 8))
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: _navOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        fixedColor: Get.theme.colorScheme.primary,
        unselectedItemColor: Get.isDarkMode ? Colors.white70 : Colors.black54,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Iconify(
              Bx.cart_alt,
              color: _selectedIndex == 0
                  ? Get.theme.colorScheme.primary
                  : Get.isDarkMode
                  ? Colors.white70
                  : Colors.black54,
            ),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Bx.category,
              color: _selectedIndex == 1
                  ? Get.theme.colorScheme.primary
                  : Get.isDarkMode
                  ? Colors.white70
                  : Colors.black54,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Bx.edit_alt,
              color: _selectedIndex == 2
                  ? Get.theme.colorScheme.primary
                  : Get.isDarkMode
                  ? Colors.white70
                  : Colors.black54,
            ),
            label: 'Modifiers',
          ),
          BottomNavigationBarItem(
            icon: Iconify(
              Bx.tag,
              color: _selectedIndex == 3
                  ? Get.theme.colorScheme.primary
                  : Get.isDarkMode
                  ? Colors.white70
                  : Colors.black54,
            ),
            label: 'Discounts',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _add() {
    if (_selectedIndex == 0) {
      Get.to(() => ScreenAddItem());
    } else if (_selectedIndex == 1) {
      Get.to(() => ScreenAddCategory());
    } else if (_selectedIndex == 2) {
      Get.to(() => ScreenAddModifier());
    } else if (_selectedIndex == 3) {
      // Add Discount
    }
  }
}
