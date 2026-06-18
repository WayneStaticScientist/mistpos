import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/widgets/layouts/cards_category.dart';

class SalesCategoriesList extends StatefulWidget {
  final Function(String) changeCategory;
  final Function(dynamic) onChange;
  final String value;
  const SalesCategoriesList({
    super.key,
    required this.changeCategory,
    required this.onChange,
    required this.value,
  });
  @override
  State<SalesCategoriesList> createState() => _SalesCategoriesListState();
}

class _SalesCategoriesListState extends State<SalesCategoriesList> {
  final _itemsListController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Categories label + dropdown pill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.4,
                  ),
                ),
                const Spacer(),
                // Dropdown as a compact pill
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withAlpha(40),
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.value,
                      isDense: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "*",
                          child: Text(
                            "All Items",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "discounts",
                          child: Row(
                            children: [
                              Icon(Icons.local_offer_outlined, size: 14, color: Colors.orange),
                              const SizedBox(width: 6),
                              Text("Discounts", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "tax",
                          child: Row(
                            children: [
                              Icon(Icons.receipt_outlined, size: 14, color: Colors.teal),
                              const SizedBox(width: 6),
                              Text("Taxes", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                      onChanged: widget.onChange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Horizontal scrollable category chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                Obx(
                  () => CardsCategory(
                    onTap: () => widget.changeCategory(""),
                    isSelected:
                        _itemsListController.selectedCategory.value == "",
                    category: "All",
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _itemsListController.categories.map((category) {
                      return CardsCategory(
                        onTap: () => widget.changeCategory(category.hexId),
                        category: category.name,
                        isSelected:
                            _itemsListController.selectedCategory.value ==
                            category.hexId,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
