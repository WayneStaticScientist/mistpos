import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/models/inventory_history_model.dart';
import 'package:mistpos/controllers/inventory_controller.dart';

class NavInventoryHistory extends StatefulWidget {
  const NavInventoryHistory({super.key});

  @override
  State<NavInventoryHistory> createState() => _NavInventoryHistoryState();
}

class _NavInventoryHistoryState extends State<NavInventoryHistory> {
  final _inventoryController = Get.find<InventoryController>();
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inventoryController.getInventoryHistory(_startDate, _endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      14.gapHeight,
      [
        Iconify(Bx.calendar, color: AppTheme.color(context)),
        8.gapWidth,

        "From ${MistDateUtils.getInformalShortDate(_startDate)} - ${(DateUtils.isSameDay(_endDate, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(_endDate))}"
            .text()
            .visibleIfNotNull(_startDate),
      ].row(mainAxisAlignment: MainAxisAlignment.center).onTap(_changeDateRange),
      "Tap on the date icon to change date ranges".text(
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),

      Obx(() {
        if (_inventoryController.loadingInventoryHistory.value) {
          return MistLoader1().center();
        }
        if (_inventoryController.inventoryHistory.isEmpty) {
          return "No sales today".text().center();
        }
        return SingleChildScrollView(
          child: _makeTable(_inventoryController.inventoryHistory),
        );
      }).expanded1,
    ].column();
  }

  Widget _makeTable(RxList<InventoryHistoryModel> historyModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(200.0), // Item
          1: FixedColumnWidth(100.0),
          2: FixedColumnWidth(100.0),
          3: FixedColumnWidth(100.0),
          4: FixedColumnWidth(80.0),
          5: FixedColumnWidth(80.0),
          6: FixedColumnWidth(80.0),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Text('Item Name').padding(EdgeInsets.all(10)),
              Text('Document Type').padding(EdgeInsets.all(10)),
              Text('Quantity Change').padding(EdgeInsets.all(10)),
              Text('Date').padding(EdgeInsets.all(10)),
            ],
          ),
          ...historyModel.map((e) {
            return TableRow(
              children: [
                Text(
                  e.itemName ?? '-',
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.documentType ?? "-",
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.quantityChange?.toString() ?? "-",
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.createdAt != null
                      ? MistDateUtils.getInformalShortDate(e.createdAt!)
                      : "",
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      _endDate = date.end;
      _startDate = date.start;
    });
    _inventoryController.getInventoryHistory(_startDate, _endDate);
  }
}
