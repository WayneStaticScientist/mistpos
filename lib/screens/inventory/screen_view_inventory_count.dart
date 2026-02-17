import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';
import 'package:mistpos/screens/inventory/screen_inventory_count.dart';

class ScreenViewInventoryCount extends StatefulWidget {
  final InventoryCountModel model;
  const ScreenViewInventoryCount({super.key, required this.model});

  @override
  State<ScreenViewInventoryCount> createState() =>
      _ScreenViewInventoryCountState();
}

class _ScreenViewInventoryCountState extends State<ScreenViewInventoryCount> {
  final _inventory = Get.find<InventoryController>();
  User? sender;
  String _error = "";
  bool _loading = true;
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    if (widget.model.status == "pending") {
      _inventory.loadInventoryCountItems(
        widget.model.countBasedOn,
        widget.model.inventoryItems.map((e) => e.id).toList(),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await _userController.getUserById(widget.model.senderId);
      if (mounted) {
        setState(() {
          sender = response.user;
          _loading = false;
          _error = response.error;
        });
      }
    });
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

  MistMordernLayout _buildInventorySummary() {
    return MistMordernLayout(
      label: "Summary",
      children: [
        14.gapHeight,
        widget.model.label.text(
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        widget.model.status.toUpperCase().text(),
        _getStatus(widget.model.status),
        18.gapHeight,
        [
          "Date Created: ".text(style: TextStyle(fontWeight: FontWeight.bold)),
          MistDateUtils.getInformalDate(widget.model.createdAt!).text(),
        ].row(),
        12.gapHeight,
        [
          "Date Completed: ".text(
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          MistDateUtils.getInformalDate(widget.model.updatedAt!).text(),
        ].row().visibleIfNot(widget.model.status == 'pending'),
      ],
    );
  }

  MistMordernLayout _buildSupplierInformation() {
    return MistMordernLayout(
      label: "Sender",
      children: [
        if (_loading) MistLoader1(),
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
                leading: Iconify(Bx.user, color: AppTheme.color(context)),
                subtitle: "Name".text(),
              ),
              12.gapHeight,
              ListTile(
                title: sender!.email.text(),
                leading: Iconify(Bx.envelope, color: AppTheme.color(context)),
                subtitle: "Email".text(),
              ),
              12.gapHeight,
              ListTile(
                title: sender!.country.text(),
                leading: Iconify(Bx.flag, color: AppTheme.color(context)),
                subtitle: "Country".text(),
              ),

              12.gapHeight,
              ListTile(
                title: sender!.role.text(),
                leading: Iconify(
                  Bx.arrow_to_top,
                  color: AppTheme.color(context),
                ),
                subtitle: "Role".text(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  MistMordernLayout _buildProductInformation() {
    return MistMordernLayout(
      label: "Items Information ",
      children: [
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
                      _userController.user.value?.baseCurrence ?? '',
                    ).text(style: TextStyle(color: Colors.green)),
                  ),
                )
                .toList(),
          ).visibleIfNot(_inventory.loadingInventoryCountItems.value),
        ).visibleIf(widget.model.status == "pending"),
        ListTile(
          title: "Total Cost difference".text(),
          leading: Iconify(Bx.dollar, color: AppTheme.color(context)),
          trailing:
              CurrenceConverter.getCurrenceFloatInStrings(
                widget.model.totalCostDifference,
                _userController.user.value?.baseCurrence ?? '',
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
          leading: Iconify(Bx.adjust, color: AppTheme.color(context)),
          trailing: widget.model.totalDifference.toString().text(
            style: TextStyle(
              color: widget.model.totalDifference >= 0
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ).visibleIf(widget.model.status == "completed"),
        _makeTable().visibleIf(widget.model.status == "completed"),
      ],
    );
  }

  Widget _getStatus(String status) {
    if (status.toLowerCase() == "pending") {
      return Iconify(Bx.timer, color: Colors.orange, size: 35);
    }
    return Iconify(Bx.check_circle, color: Colors.green, size: 35);
  }

  Future<void> _countPage() async {
    final result = await Get.to(
      () => ScreenInventoryCount(model: widget.model),
    );
    if (result == null) return;
    setState(() {
      widget.model.inventoryItems = result.inventoryItems;
      widget.model.status = result.status;
      widget.model.updatedAt = result.updatedAt;
    });
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
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.cost,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                ),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.costDifference,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                ),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
  }
}
