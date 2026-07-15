import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens/screen_add_item.dart';
import 'package:mistpos/features/sales/screens/nav_items_list.dart';
import 'package:mistpos/features/sales/screens/nav_category_list.dart';
import 'package:mistpos/features/settings/screens/screen_add_modifier.dart';
import 'package:mistpos/features/settings/screens/screen_add_category.dart';
import 'package:mistpos/features/settings/screens/screen_add_discounts.dart';
import 'package:mistpos/features/sales/screens/nav_modifiers_list.dart';
import 'package:mistpos/features/sales/screens/nav_discounts_list.dart';
import 'package:mistpos/features/settings/screens/screen_subscription.dart';

class NavItems extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final int initialIndex;
  const NavItems({super.key, this.scaffoldKey, this.initialIndex = 0});

  @override
  State<NavItems> createState() => _NavItemsState();
}

class _NavItemsState extends State<NavItems> {
  late int _selectedIndex = widget.initialIndex;
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
        leading: widget.scaffoldKey != null
            ? DrawerButton(
                onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
              )
            : const BackButton(),
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        height: 72,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(Get.isDarkMode ? 40 : 15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Bx.cart_alt, 'Items'),
              _buildNavItem(1, Bx.category, 'Categories'),
              _buildNavItem(2, Bx.edit_alt, 'Modifiers'),
              _buildNavItem(3, Bx.tag, 'Discounts'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = _selectedIndex == index;
    final isDark = Get.isDarkMode;
    final activeColor = Get.theme.colorScheme.primary;
    final inactiveColor = isDark ? Colors.grey.shade500 : Colors.grey.shade600;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? activeColor.withAlpha(25) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Iconify(
                  iconPath,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _add() {
    final company = CompanyModel.fromStorage();
    if (company?.subscriptionType.type == MistSubscriptionUtils.freePlan ||
        company?.subscriptionType.type == null) {
      Toaster.showError("Please upgrade subscription to add/edit/remove items");
      Get.to(() => ScreenSubscription());
      return;
    }

    if (_selectedIndex == 0) {
      Get.to(() => ScreenAddItem());
    } else if (_selectedIndex == 1) {
      Get.to(() => ScreenAddCategory());
    } else if (_selectedIndex == 2) {
      Get.to(() => ScreenAddModifier());
    } else if (_selectedIndex == 3) {
      Get.to(() => ScreenAddDiscounts());
    }
  }
}
