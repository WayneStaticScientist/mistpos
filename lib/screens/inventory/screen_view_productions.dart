import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/production_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';

class ScreenViewProductions extends StatefulWidget {
  final ProductionModel model;
  const ScreenViewProductions({super.key, required this.model});

  @override
  State<ScreenViewProductions> createState() => _ScreenViewProductionsState();
}

class _ScreenViewProductionsState extends State<ScreenViewProductions> {
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Productions".text()),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          MistMordernLayout(
            label: "Info",
            children: [
              ListTile(
                title: "Label".text(),
                contentPadding: EdgeInsets.all(0),
                subtitle: widget.model.label.text(),
              ),
            ],
          ),
          32.gapHeight,
          MistMordernLayout(label: "Composite Items", children: [_makeTable()]),
        ],
      ),
    );
  }

  Widget _makeTable() {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: ScreenSizes.maxWidth,
      columns: [
        DataColumn2(label: Text('Item Name'), size: ColumnSize.L), // Has flex
        DataColumn(label: Text('Cost')),
        DataColumn(label: Text('Quantity')),
      ],
      rows: widget.model.items
          .map(
            (e) => DataRow(
              cells: <DataCell>[
                DataCell(e.name.text()),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.cost,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                ),
                DataCell(e.quantity.toString().text()),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
  }
}
