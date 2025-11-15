import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/dialy_sale_model.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/utils/pdfdocuments/pdf_daily_sales.dart';

class DailySales extends StatefulWidget {
  const DailySales({super.key});

  @override
  State<DailySales> createState() => DailySalesState();
}

class DailySalesState extends State<DailySales> {
  final _controller = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  DateTime _selectedDate = DateTime.now();
  DateTime? _startDate;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getDailySales(DateTime.now(), null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      14.gapHeight,
      [
        Iconify(Bx.calendar, color: AppTheme.color(context)),
        8.gapWidth,
        "Sales for ${(DateUtils.isSameDay(_selectedDate, DateTime.now()) ? "Today only" : MistDateUtils.formatNormalDate(_selectedDate))}"
            .text()
            .visibleIf(_startDate == null),
        if (_startDate != null)
          "From ${MistDateUtils.getInformalShortDate(_startDate!)} - ${(DateUtils.isSameDay(_selectedDate, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(_selectedDate))}"
              .text()
              .visibleIfNotNull(_startDate),
      ].row(mainAxisAlignment: MainAxisAlignment.center).onTap(_changeDateRange),
      "Tap on the date icon to change date ranges".text(
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),

      14.gapHeight,
      Obx(() {
        final totalSales = _controller.dailySales.fold(
          0.0,
          (prev, data) => prev + data.totalSales,
        );

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
        final totalCosts = _controller.dailySales.fold(
          0.0,
          (prev, data) => prev + data.totalCosts,
        );
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

  void _changeDateRange() async {
    final date = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      _selectedDate = date.end;
      _startDate = date.start;
    });
    _controller.getDailySales(_selectedDate, _startDate);
  }

  void printDocument() async {
    PDFMaker maker = PDFMaker();
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    maker
        .createPDF(
          PdfDailySales(
            endDate: _selectedDate,
            startDate: _startDate,
            baseCurrence: baseCurrency,
            dailySales: _controller.dailySales,
          ),
          setup: PageSetup(
            context: context,
            quality: 4.0,
            scale: 1.0,
            pageFormat: PageFormat.a4,
            margins: 40,
          ),
        )
        .then((file) {
          _controller.openFile(file);
        })
        .catchError((e) {
          Toaster.showError("Failed to generate PDF: $e");
        });
  }
}
