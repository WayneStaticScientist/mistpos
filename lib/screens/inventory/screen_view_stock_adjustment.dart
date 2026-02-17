import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/inventory/constants.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';

class ScreenViewStockAdjustment extends StatefulWidget {
  final StockAdjustmentModel model;
  const ScreenViewStockAdjustment({super.key, required this.model});

  @override
  State<ScreenViewStockAdjustment> createState() =>
      _ScreenViewStockAdjustmentState();
}

class _ScreenViewStockAdjustmentState extends State<ScreenViewStockAdjustment> {
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Stock Adjustment Order".text(),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildProductSummary(),
          24.gapHeight,
          _buildProductInformation(),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  MistMordernLayout _buildProductSummary() {
    return MistMordernLayout(
      label: "Summary ",
      children: [
        18.gapHeight,
        widget.model.label.text(
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        14.gapHeight,
        [
          "Date : ".text(),
          MistDateUtils.getInformalDate(widget.model.createdAt).text(),
        ].row(),
        14.gapHeight,
        [
          "Reason : ".text(),
          Inventory.adjustStockReasons
                  .firstWhere(
                    (element) => element['value'] == widget.model.reason,
                  )['label']
                  ?.text() ??
              ''.text(),
        ].row(),
      ],
    );
  }

  MistMordernLayout _buildProductInformation() {
    return MistMordernLayout(
      label: "Product Information ",
      children: [_makeTable(widget.model.inventoryItems)],
    );
  }

  Widget _makeTable(List<InvItem> inventoryItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(120.0), // Item
          1: FixedColumnWidth(80.0),
          2: FixedColumnWidth(80.0),
          3: FixedColumnWidth(
            widget.model.reason == "add" ? 100.0 : 0.0,
          ), // Cost
          4: FixedColumnWidth(80),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: AppTheme.surface(context)),
            children: [
              "Item".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "In Stock".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              _getLabel().text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ),
              "Cost"
                  .text()
                  .padding(EdgeInsets.symmetric(vertical: 10, horizontal: 3))
                  .visibleIf(widget.model.reason == "add"),
              "Stock After".text().padding(
                EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              ), // This is the 5th item/column
            ],
          ),
          ...inventoryItems.map<TableRow>(
            (e) => TableRow(
              children: [
                e.name.text().padding(EdgeInsets.symmetric(vertical: 15)),
                e.inStock.toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ),
                e.quantity.toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ),
                CurrenceConverter.getCurrenceFloatInStrings(
                      e.cost,
                      _userController.user.value?.baseCurrence ?? '',
                    )
                    .text()
                    .padding(EdgeInsets.symmetric(vertical: 15))
                    .visibleIf(widget.model.reason == "add"),
                (_getStockAfter(e)).toString().text().padding(
                  EdgeInsets.symmetric(vertical: 15),
                ), // This is the 5th item's data
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel() {
    if (widget.model.reason == "add") {
      return "Added Stock";
    }
    if (widget.model.reason == "count") {
      return "Counteded";
    }
    return "Removed Stock";
  }

  double _getStockAfter(InvItem e) {
    if (widget.model.reason == "add") {
      return e.inStock + e.quantity;
    }
    if (widget.model.reason == "count") {
      return e.quantity;
    }
    return e.inStock - e.quantity;
  }
}
