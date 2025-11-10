import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/widgets/layouts/cards_category.dart';

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
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: [
          DropdownButton(
                value: widget.value,
                underline: SizedBox.shrink(),
                items: [
                  DropdownMenuItem(value: "*", child: "All".text()),
                  DropdownMenuItem(
                    value: "discounts",
                    child: "Discounts".text(),
                  ),
                ],
                onChanged: widget.onChange,
              ).paddingZero
              .padding(EdgeInsets.symmetric(horizontal: 18, vertical: 1))
              .decoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
          ListView(
            scrollDirection: Axis.horizontal,
            children: [
              14.gapHeight,
              Obx(
                () => CardsCategory(
                  onTap: () => widget.changeCategory(""),
                  isSelected: _itemsListController.selectedCategory.value == "",
                  category: "All",
                ),
              ),
              Obx(
                () => _itemsListController.categories
                    .map<Widget>((category) {
                      return CardsCategory(
                        onTap: () => widget.changeCategory(category.hexId),
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
          ).expanded1,
        ].row().sizedBox().padding(EdgeInsets.symmetric(horizontal: 18)),
      ),
    );
  }
}
