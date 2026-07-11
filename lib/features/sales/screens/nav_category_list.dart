import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/data/models/item_categories_model.dart';
import 'package:mistpos/features/settings/screens/screen_subscription.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/widgets/buttons/card_buttons.dart';
import 'package:mistpos/features/settings/screens/screen_edit_category.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class NavCategoryList extends StatefulWidget {
  const NavCategoryList({super.key});

  @override
  State<NavCategoryList> createState() => _NavCategoryListState();
}

class _NavCategoryListState extends State<NavCategoryList> {
  final _itemsController = Get.find<ItemsController>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _itemsController.loadCategoriesAsync();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => _itemsController.categories.isEmpty
          ? SmartRefresher(
              controller: _refreshController,
              header: const WaterDropHeader(),
              onRefresh: _onRefresh,
              child: [
                Iconify(
                  Carbon.no_ticket,
                  size: 60,
                  color: Get.theme.colorScheme.primary,
                ),
                18.gapHeight,
                "No Categories click new to add one".text(),
              ]
              .column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              )
              .center(),
            )
          : SmartRefresher(
              controller: _refreshController,
              header: const WaterDropHeader(),
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemBuilder: (context, index) {
                  final item = _itemsController.categories[index];
                  Color? catColor;
                  if (item.color != null) {
                    try {
                      catColor = Color(int.parse('${item.color!}'));
                    } catch (_) {}
                  }
                  catColor ??= Get.theme.colorScheme.primary;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 30 : 10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openEditor(item),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              // Beautiful Color Tag with glow shadow
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: catColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: catColor.withAlpha(80),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.category_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Category Name
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _itemsController.categories.length,
              ),
            ),
    );
  }

  void _openEditor(ItemCategoryModel model) {
    final company = CompanyModel.fromStorage();
    if (company?.subscriptionType.type == MistSubscriptionUtils.freePlan ||
        company?.subscriptionType.type == null) {
      Toaster.showError("Please upgrade subscription to add/edit/remove items");
      Get.to(() => ScreenSubscription());
      return;
    }
    Get.bottomSheet(
      [
        CardButtons(
          onTap: () => _openDeleteDialog(model),
          icon: Iconify(Carbon.delete),
          label: "Delete",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          icon: Iconify(Bx.bxs_edit),
          label: "Edit Item",
          color: Get.theme.colorScheme.secondary.withAlpha(50),
          onTap: () {
            Get.back();
            Get.to(() => ScreenEditCategory(itemCategoryModel: model));
          },
        ).expanded1,
      ].row().padding(EdgeInsets.only(top: 18)).safeArea(),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  void _openDeleteDialog(ItemCategoryModel model) {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: Text("Delete ${model.name}"),
        content: Text("are you sure to delete category"),
        actions: [
          "close".text().textButton(onPressed: () => Get.back()),
          "delete".text().textButton(
            onPressed: () {
              Get.back();
              _itemsController.deleteCategory(model.hexId);
            },
          ),
        ],
      ),
    );
  }
}
