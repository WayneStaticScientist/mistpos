import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/screens/basic/screen_subscription.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/screens/basic/screen_edit_category.dart';

class NavCategoryList extends StatefulWidget {
  const NavCategoryList({super.key});

  @override
  State<NavCategoryList> createState() => _NavCategoryListState();
}

class _NavCategoryListState extends State<NavCategoryList> {
  final _itemsController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsController.categories.isEmpty
          ? [
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
                .center()
          : ListView.builder(
              itemBuilder: (context, index) {
                final item = _itemsController.categories[index];
                return InkWell(
                  onTap: () => _openEditor(item),
                  child: Card(
                    child: ListTile(
                      title: Text(item.name),
                      leading: CircleAvatar(
                        backgroundColor: item.color == null
                            ? Get.theme.colorScheme.primary
                            : Color(int.parse('${item.color!}')),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _itemsController.categories.length,
            ),
    );
  }

  _openEditor(ItemCategoryModel model) {
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

  _openDeleteDialog(ItemCategoryModel model) {
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
