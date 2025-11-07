import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/dialy_sale_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class DailySales extends StatefulWidget {
  const DailySales({super.key});

  @override
  State<DailySales> createState() => _DailySalesState();
}

class _DailySalesState extends State<DailySales> {
  final _controller = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getDailySales(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalSales = _controller.dailySales.fold(
      0.0,
      (prev, data) => prev + data.totalSales,
    );
    final totalCosts = _controller.dailySales.fold(
      0.0,
      (prev, data) => prev + data.totalCosts,
    );
    return [
      ListTile(
        contentPadding: EdgeInsets.all(0),
        subtitle: "Tap to select date of interest".text(
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        onTap: _pickdate,
        title:
            "Sales for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} "
                .text(),
        trailing: Iconify(Bx.calendar, color: Colors.white),
      ),
      14.gapHeight,
      Obx(() {
        return ListTile(
          contentPadding: EdgeInsets.all(0),
          title: "Total Sales".text(),
          trailing: CurrenceConverter.getCurrenceFloatInStrings(
            totalSales,
            _userController.user.value?.baseCurrence ?? '',
          ).text(),
        ).visibleIf(
          !_controller.loadingDailySales.value &&
              _controller.dailySales.isNotEmpty,
        );
      }),
      Obx(() {
        return ListTile(
          contentPadding: EdgeInsets.all(0),
          title: "Total Costs".text(),
          trailing: CurrenceConverter.getCurrenceFloatInStrings(
            totalCosts,
            _userController.user.value?.baseCurrence ?? '',
          ).text(),
        ).visibleIf(
          !_controller.loadingDailySales.value &&
              _controller.dailySales.isNotEmpty,
        );
      }),
      Obx(() {
        if (_controller.loadingDailySales.value) {
          return MistLoader1().center();
        }
        if (_controller.dailySales.isEmpty) {
          return "No sales today".text().center();
        }
        return SingleChildScrollView(child: _makeTable(_controller.dailySales));
      }).expanded1,
    ].column();
  }

  Widget _makeTable(RxList<DialySaleModel> dailySales) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: ScreenSizes.maxWidth,
      columns: [
        DataColumn2(label: Text('Item Name'), size: ColumnSize.S), // Has flex
        DataColumn2(label: Text('Sold Amount'), size: ColumnSize.S),
        DataColumn2(label: Text('Total Sales'), size: ColumnSize.S),
        DataColumn2(label: Text('Total Costs'), size: ColumnSize.S),
      ],
      rows: dailySales
          .map(
            (e) => DataRow(
              cells: <DataCell>[
                DataCell(e.productName.text()),
                DataCell(e.totalCount.toString().text()),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.totalSales,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                ),
                DataCell(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.totalCosts,
                    _userController.user.value?.baseCurrence ?? '',
                  ).text(),
                ),
              ],
            ),
          )
          .toList(),
    ).constrained(maxWidth: ScreenSizes.maxWidth, maxHeight: 10000);
  }

  void _pickdate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      _selectedDate = date;
    });
    _controller.getDailySales(_selectedDate);
  }
}
