import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';

class ScreenViewStockAdjustment extends StatefulWidget {
  final StockAdjustmentModel model;
  const ScreenViewStockAdjustment({super.key, required this.model});

  @override
  State<ScreenViewStockAdjustment> createState() =>
      _ScreenViewStockAdjustmentState();
}

class _ScreenViewStockAdjustmentState extends State<ScreenViewStockAdjustment> {
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

  _buildProductSummary() {
    final totalProductPrice = widget.model.inventoryItems.fold(
      0.0,
      (prev, current) => prev + current.amount,
    );
    final totalItems = widget.model.inventoryItems.fold(
      0,
      (prev, current) => prev + current.quantity,
    );
    return [
          "Summary ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              if (widget.model.reason == 'add')
                CardOverview(
                  label: "Total Price ",
                  value: CurrenceConverter.getCurrenceFloatInStrings(
                    totalProductPrice,
                  ),
                ),
              CardOverview(
                label: _getProperLabel(),
                value: totalItems.toString(),
              ),
            ],
          ),
          Iconify(Bx.pencil),
          widget.model.notes.text(),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        );
  }

  _buildProductInformation() {
    return [
          "Product Information ".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ExpansionTile(
            shape: RoundedRectangleBorder(),
            title: "Products".text(),
            children: widget.model.inventoryItems
                .map(
                  (e) => ListTile(
                    leading: CircleAvatar(child: _getPrefix(e.quantity).text()),
                    title: e.name.text(),
                    subtitle: widget.model.reason == "add"
                        ? "Prop ${CurrenceConverter.getCurrenceFloatInStrings(e.cost)}"
                              .text(style: TextStyle(fontSize: 12))
                        : null,
                  ),
                )
                .toList(),
          ),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        );
  }

  String _getProperLabel() {
    if (widget.model.reason == "add") return "Total Added";
    if (widget.model.reason == "count") return "Total revaluated";
    return "Total removed";
  }

  String _getPrefix(int size) {
    if (widget.model.reason == "add") {
      return "+ $size";
    }
    if (widget.model.reason == "count") {
      return "= $size";
    }
    return "- $size";
  }
}
