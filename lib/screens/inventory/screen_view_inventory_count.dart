import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/widgets/layouts/card_overview.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_inventory_count.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenViewInventoryCount extends StatefulWidget {
  final InventoryCountModel model;
  const ScreenViewInventoryCount({super.key, required this.model});

  @override
  State<ScreenViewInventoryCount> createState() =>
      _ScreenViewInventoryCountState();
}

class _ScreenViewInventoryCountState extends State<ScreenViewInventoryCount> {
  final _inventory = Get.find<InventoryController>();
  bool _loading = true;
  bool _updatingState = false;
  String _error = "";
  User? sender;
  @override
  void initState() {
    super.initState();
    if (widget.model.status == "pending") {
      _inventory.loadInventoryCountItems(
        widget.model.countBasedOn,
        widget.model.inventoryItems.map((e) => e.id).toList(),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Get.theme.colorScheme.primary,
        title: "Inventory Count".text(),
        actions: [
          if (widget.model.status.toLowerCase() == "pending")
            MistLoadIconButton(label: "count", onPressed: _countPage),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildInventorySummary(),
          24.gapHeight,
          _buildSupplierInformation(),
          24.gapHeight,
          _buildProductInformation(),
        ],
      ).constrained(maxWidth: ScreenSizes.maxWidth).center(),
    );
  }

  _buildInventorySummary() {
    return [
          "Summary ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              CardOverview(
                label: "Total Items",
                value: widget.model.inventoryItems.length.toString(),
              ),
              [
                    "Status".text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _getStatus(widget.model.status),
                    widget.model.status.toUpperCase().text(),
                  ]
                  .column(crossAxisAlignment: CrossAxisAlignment.start)
                  .sizedBox(height: 100, width: 150)
                  .padding(EdgeInsets.all(12))
                  .decoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                  .padding(EdgeInsets.all(10)),
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
        .decoratedBox(decoration: BoxDecoration(color: AppTheme.surface));
  }

  _buildSupplierInformation() {
    return [
          "Sender Information".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (_loading)
            LoadingAnimationWidget.staggeredDotsWave(
              color: Get.theme.colorScheme.primary,
              size: 50,
            ),
          18.gapHeight,
          if (_error.isNotEmpty)
            "There was error fetching the supplier details ".text(
              style: TextStyle(color: Colors.red),
            ),
          if (sender != null) ...[
            ExpansionTile(
              shape: RoundedRectangleBorder(),
              title: "Supplier details".text(),
              children: [
                ListTile(
                  title: sender!.fullName.text(),
                  leading: Iconify(Bx.user),
                  subtitle: "Name".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: sender!.email.text(),
                  leading: Iconify(Bx.envelope),
                  subtitle: "Email".text(),
                ),
                12.gapHeight,
                ListTile(
                  title: sender!.country.text(),
                  leading: Iconify(Bx.flag),
                  subtitle: "Country".text(),
                ),

                12.gapHeight,
                ListTile(
                  title: sender!.role.text(),
                  leading: Iconify(Bx.arrow_to_top),
                  subtitle: "Role".text(),
                ),
              ],
            ),
          ],
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(decoration: BoxDecoration(color: AppTheme.surface));
  }

  _buildProductInformation() {
    return [
          "Items Information ".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          18.gapHeight,
          Obx(
            () => MistLoader1().visibleIf(
              _inventory.loadingInventoryCountItems.value,
            ),
          ),
          "There was error fetching items : ${_inventory.inventoryCountItemsError.value}"
              .text(style: TextStyle(color: Colors.red))
              .visibleIf(_inventory.inventoryCountItemsError.isNotEmpty),
          18.gapHeight,
          Obx(
            () => "No items"
                .text(style: TextStyle(color: Colors.red))
                .visibleIf(
                  _inventory.inventoryCountItems.isEmpty &&
                      !_inventory.inventoryCountItemsError.isNotEmpty &&
                      !_inventory.inventoryCountsLoading.value &&
                      widget.model.status == "pending",
                ),
          ),
          Obx(
            () => ExpansionTile(
              initiallyExpanded: true,
              shape: RoundedRectangleBorder(),
              title: "Items".text(),
              children: _inventory.inventoryCountItems
                  .map(
                    (e) => ListTile(
                      leading: CircleAvatar(
                        child: "${e.count}".text(
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: e.name.text(),
                      subtitle: "Counted ${e.count}".text(
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: CurrenceConverter.getCurrenceFloatInStrings(
                        e.cost,
                      ).text(style: TextStyle(color: Colors.green)),
                    ),
                  )
                  .toList(),
            ).visibleIfNot(_inventory.loadingInventoryCountItems.value),
          ).visibleIf(widget.model.status == "pending"),
          ListTile(
            title: "Total Cost difference".text(),
            leading: Iconify(Bx.dollar, color: AppTheme.color),
            trailing:
                CurrenceConverter.getCurrenceFloatInStrings(
                  widget.model.totalCostDifference,
                ).text(
                  style: TextStyle(
                    color: widget.model.totalCostDifference >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
          ).visibleIf(widget.model.status == "completed"),
          ListTile(
            title: "Total Item difference".text(),
            leading: Iconify(Bx.adjust, color: AppTheme.color),
            trailing: widget.model.totalDifference.toString().text(
              style: TextStyle(
                color: widget.model.totalDifference >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ).visibleIf(widget.model.status == "completed"),
          _makeTable().visibleIf(widget.model.status == "completed"),
        ]
        .column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(EdgeInsets.all(8))
        .decoratedBox(decoration: BoxDecoration(color: AppTheme.surface));
  }

  Widget _getStatus(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.orange, size: 35);
    }
    return Iconify(Bx.check_circle, color: Colors.green, size: 35);
  }

  _countPage() {
    Get.to(() => ScreenInventoryCount(model: widget.model));
  }

  Widget _makeTable() {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: ScreenSizes.maxWidth,
      columns: [
        DataColumn2(label: Text('Item Name'), size: ColumnSize.L), // Has flex
        DataColumn(label: Text('Expected Stock')),
        DataColumn(label: Text('Counted')),
        DataColumn(label: Text('Difference')),
        DataColumn(label: Text('Cost '), numeric: true),
        DataColumn(label: Text('Cost Difference'), numeric: true),
      ],
      rows: widget.model.inventoryItems
          .map(
            (e) => DataRow(
              cells: <DataCell>[
                DataCell(e.name.text()),
                DataCell(e.count.toString().text()),
                DataCell(e.counted.toString().text()),
                DataCell((e.difference).toString().text()),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(e.cost).text(),
                ),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.costDifference,
                  ).text(),
                ),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
  }
}
