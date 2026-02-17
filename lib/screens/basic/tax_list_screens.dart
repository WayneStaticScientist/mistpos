import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_add_tax.dart';
import 'package:mistpos/screens/basic/screen_edit_tax.dart';
import 'package:mistpos/screens/basic/screen_subscription.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class TaxListScreens extends StatefulWidget {
  const TaxListScreens({super.key});

  @override
  State<TaxListScreens> createState() => _TaxListScreensState();
}

class _TaxListScreensState extends State<TaxListScreens> {
  final _itemsController = Get.find<ItemsController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _itemsController.loadTaxes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Taxes".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (_itemsController.syncingTaxes.value) {
          return MistLoader1().center();
        }
        if (_itemsController.taxes.isEmpty) {
          return [
                Iconify(Carbon.percentage, color: Colors.grey),
                14.gapHeight,
                "No taxes found".text(
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ]
              .column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              )
              .center();
        }
        return ListView.builder(
          itemCount: _itemsController.taxes.length,
          itemBuilder: (context, index) =>
              _buildItem(_itemsController.taxes[index]),
        );
      }),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          final company = CompanyModel.fromStorage();
          if (company?.subscriptionType.type ==
                  MistSubscriptionUtils.freePlan ||
              company?.subscriptionType.type == null) {
            Toaster.showError(
              "Please upgrade subscription to add/edit/remove items",
            );
            Get.to(() => ScreenSubscription());
            return;
          }
          Get.to(() => ScreenAddTax());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ListTile _buildItem(TaxModel tax) {
    return ListTile(
      onLongPress: () => _confirmDelete(tax),
      trailing: (tax.activated
          ? Iconify(Bx.check, color: Colors.green)
          : Iconify(Bx.x, color: Colors.red)),
      onTap: () {
        final company = CompanyModel.fromStorage();
        if (company?.subscriptionType.type == MistSubscriptionUtils.freePlan ||
            company?.subscriptionType.type == null) {
          Toaster.showError(
            "Please upgrade subscription to add/edit/remove items",
          );
          Get.to(() => ScreenSubscription());
          return;
        }
        Get.to(() => ScreenEditTax(tax: tax));
      },
      subtitle:
          (tax.selectedIds.isEmpty
                  ? "All items"
                  : "${tax.selectedIds.length} items")
              .text(style: TextStyle(color: Colors.grey, fontSize: 12)),
      leading: Iconify(Carbon.percentage, color: Colors.grey, size: 16),
      title: tax.label.text(),
    );
  }

  void _confirmDelete(TaxModel tax) {
    Get.defaultDialog(
      title: "Delete Tax",
      content: "Are you sure you want to delete this tax?".text(),
      actions: [
        TextButton(onPressed: () => Get.back(), child: "Cancel".text()),
        TextButton(onPressed: () => _deleteTax(tax), child: "Delete".text()),
      ],
    );
  }

  void _deleteTax(TaxModel tax) async {
    Get.back();
    final result = await _itemsController.deleteTax(tax.hexId);
    if (result) {
      Toaster.showSuccess("Tax deleted successfully");
    }
  }
}
