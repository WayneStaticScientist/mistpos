import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/settings/screens/screen_devices_section.dart';
import 'package:mistpos/features/settings/screens/screen_settings_page.dart';
import 'package:mistpos/features/settings/screens/screen_shifts_screen.dart';
import 'package:mistpos/features/settings/screens_gateways/automated_screen.dart';

class MistMainNavigationSidebar extends StatelessWidget {
  final Function(String value) onTap;
  final String selectedNav;
  final bool isExtended;
  final User? user;

  const MistMainNavigationSidebar({
    super.key,
    required this.onTap,
    required this.selectedNav,
    required this.isExtended,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    final userController = Get.find<UserController>();
    final invController = Get.find<InventoryController>();

    final isAdmin =
        userController.user.value?.role.toLowerCase() == 'admin' ||
        userController.user.value?.role.toLowerCase() == 'manager';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExtended ? 240.0 : 72.0,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1117) : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Scrollable items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _SidebarItem(
                  icon: Bx.store_alt,
                  label: 'Point of Sale',
                  isSelected: selectedNav == 'sales',
                  isExtended: isExtended,
                  onTap: () => onTap('sales'),
                ),
                _SidebarItem(
                  icon: Bx.receipt,
                  label: 'Receipts',
                  isSelected: selectedNav == 'receipts',
                  isExtended: isExtended,
                  onTap: () => onTap('receipts'),
                ),
                if (isAdmin) ...[
                  _SidebarItem(
                    icon: Carbon.shopping_cart,
                    label: 'Items',
                    isSelected: selectedNav == 'items',
                    isExtended: isExtended,
                    onTap: () => onTap('items'),
                  ),
                ],
                _SidebarItem(
                  icon: Bx.wallet,
                  label: 'Expenses',
                  isSelected: selectedNav == 'Expenses',
                  isExtended: isExtended,
                  onTap: () => onTap('Expenses'),
                ),
                if (isAdmin) ...[
                  _SidebarItem(
                    icon: Bx.bar_chart,
                    label: 'Admin Console',
                    isSelected: selectedNav == 'admin',
                    isExtended: isExtended,
                    onTap: () => onTap('admin'),
                  ),
                ],
                Divider(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                  height: 24,
                  indent: 8,
                  endIndent: 8,
                ),
                _SidebarItem(
                  icon: Bx.time,
                  label: 'Shift',
                  isSelected: false,
                  isExtended: isExtended,
                  onTap: () => Get.to(() => ScreenShiftsScreen()),
                ),
                _SidebarItem(
                  icon: Bx.devices,
                  label: 'Devices',
                  isSelected: false,
                  isExtended: isExtended,
                  onTap: () => Get.to(() => ScreenDevicesSection()),
                ),
                _SidebarItem(
                  icon: Bx.bxl_whatsapp,
                  label: 'WhatsApp',
                  isSelected: false,
                  isExtended: isExtended,
                  onTap: () {
                    if (invController.company.value == null) return;
                    Get.to(
                      () => AutomatedSyncScreen(
                        company: invController.company.value!,
                      ),
                    );
                  },
                ),
                _SidebarItem(
                  icon: Bx.cog,
                  label: 'Settings',
                  isSelected: false,
                  isExtended: isExtended,
                  onTap: () => Get.to(() => ScreenSettingsPage()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final bool isExtended;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExtended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final itemWidget = Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? primary.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: isExtended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Iconify(
                icon,
                size: 22,
                color: isSelected ? primary : AppTheme.color(context),
              ),
              if (isExtended) ...[
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? primary : AppTheme.color(context),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!isExtended) {
      return Tooltip(
        message: label,
        preferBelow: false,
        verticalOffset: 20,
        child: itemWidget,
      );
    }

    return itemWidget;
  }
}
