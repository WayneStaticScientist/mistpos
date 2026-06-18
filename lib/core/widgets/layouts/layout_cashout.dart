import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens/screen_checkout.dart';
import 'package:mistpos/features/settings/screens/screen_selected_items_readjust.dart';

class LayoutCashout extends StatelessWidget {
  final GlobalKey bottomBarKey;
  const LayoutCashout({super.key, required this.bottomBarKey});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final itemsController = Get.find<ItemsController>();
    final primary = Get.theme.colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final totalPrice = itemsController.totalPrice.value;
      final itemCount = itemsController.checkOutItems.length;
      final activeTaxes = itemsController.salesTaxes
          .where((t) => t.activated)
          .toList();
      final currency = userController.user.value?.baseCurrence ?? '';

      return Container(
        key: bottomBarKey,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tax indicator — subtle inline chip above the bar
            if (activeTaxes.isNotEmpty)
              GestureDetector(
                onTap: () => Get.to(() => ScreenCheckout()),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.amber.withAlpha(20)
                        : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.amber.withAlpha(60),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${activeTaxes.length} tax${activeTaxes.length > 1 ? 'es' : ''} applied to this sale',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.amber.shade300
                              : Colors.amber.shade800,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 200.ms)
                    .slideY(begin: 0.3, end: 0, duration: 200.ms),
              ),

            // Main checkout bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark
                    ? Colors.white.withAlpha(6)
                    : Colors.black.withAlpha(4),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withAlpha(10)
                      : Colors.black.withAlpha(8),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Left: price + item count pill
                  GestureDetector(
                    onTap: () => Get.to(() => ScreenSelectedItemsReadjust()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withAlpha(50),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Item count badge
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            CurrenceConverter.getCurrenceFloatInStrings(
                              totalPrice,
                              currency,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right: checkout action
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(() => ScreenCheckout()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Checkout',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: isDark
                                    ? Colors.white.withAlpha(220)
                                    : Colors.black.withAlpha(200),
                              ),
                            ),
                            Iconify(
                              Bx.chevron_right,
                              size: 22,
                              color: isDark
                                  ? Colors.white.withAlpha(160)
                                  : Colors.black.withAlpha(120),
                            )
                                .animate(
                                  onComplete: (c) =>
                                      c.repeat(reverse: true),
                                )
                                .moveX(
                                  begin: 0,
                                  end: 5,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
