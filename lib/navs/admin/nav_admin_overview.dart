import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';

class NavAdminOverView extends StatefulWidget {
  const NavAdminOverView({super.key});

  @override
  State<NavAdminOverView> createState() => _NavAdminOverViewState();
}

class _NavAdminOverViewState extends State<NavAdminOverView> {
  final _adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        18.gapHeight,
        "Product Overview".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        18.gapHeight,
        Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CardOverview(
                label: "Total Products",
                value: _adminController.totalProducts.value.toString(),
              ),
              18.gapWidth,
              CardOverview(
                label: "Total Items In Stock",
                value:
                    _adminController.statsPoducts.value?.totalStock
                        .toString() ??
                    "0",
              ),
              18.gapWidth,
              CardOverview(
                label: "Total Expense",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsPoducts.value?.totalCost ?? 0,
                ),
              ),
            ],
          ).sizedBox(height: 110, width: double.infinity),
        ),
        18.gapHeight,
        "Sales Overview".text(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        18.gapHeight,
        Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CardOverview(
                label: "Profit ",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  (_adminController.statsSales.value?.totalSales ?? 0) -
                      (_adminController.statsSales.value?.totalCost ?? 0),
                ),
              ),
              18.gapWidth,
              CardOverview(
                label: "Total Sales",
                value: CurrenceConverter.getCurrenceFloatInStrings(
                  _adminController.statsSales.value?.totalSales ?? 0,
                ),
              ),
              18.gapWidth,
              CardOverview(
                label: "Active Cashiers",
                value:
                    _adminController.statsSales.value?.numberOfCashiers
                        .toString() ??
                    "0",
              ),
            ],
          ).sizedBox(height: 110, width: double.infinity),
        ),

        Obx(
          () =>
              _adminController.statsSales.value?.cashiers != null &&
                  _adminController.statsSales.value!.cashiers.isNotEmpty
              ? [
                  18.gapHeight,
                  "Active Cashiers".text(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  18.gapHeight,
                  ..._adminController.statsSales.value!.cashiers.map(
                    (e) => Card(child: ListTile(title: e.name.text())),
                  ),
                ].column(crossAxisAlignment: CrossAxisAlignment.start)
              : SizedBox(),
        ),
      ],
    ).sizedBox(width: double.infinity);
  }
}
