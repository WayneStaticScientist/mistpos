import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class SalesTaxList extends StatefulWidget {
  const SalesTaxList({super.key});

  @override
  State<SalesTaxList> createState() => _SalesTaxListState();
}

class _SalesTaxListState extends State<SalesTaxList> {
  final _itemsListController = Get.find<ItemsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsListController.salesTaxes.isNotEmpty
          ? SliverList.builder(
              itemBuilder: (context, index) {
                return Obx(() {
                  final tax = _itemsListController.salesTaxes[index];
                  return ListTile(
                    title: tax.label.text(),
                    leading: Iconify(
                      Carbon.percentage,
                      color: AppTheme.color(context),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _itemsListController.removeSalesTax(tax);
                      },
                      icon: Iconify(Bx.x, color: AppTheme.color(context)),
                    ),
                    subtitle: ("${tax.value}%").text(),
                  ).padding(EdgeInsets.symmetric(vertical: 12));
                });
              },
              itemCount: _itemsListController.salesTaxes.length,
            )
          : SliverFillRemaining(
              child:
                  [
                        Iconify(Bx.cart_alt, color: AppTheme.color(context)),
                        12.gapHeight,
                        "no taxs".text(),
                        12.gapHeight,
                        MistFormButton(
                          label: "Restore tax",
                          onTap: () {
                            _itemsListController.restoreTaxs();
                          },
                        ),
                      ]
                      .column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                      .center(),
            ),
    );
  }
}
