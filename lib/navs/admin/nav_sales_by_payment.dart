import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/models/sales_by_payment.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:iconify_flutter/iconify_flutter.dart' show Iconify;
import 'package:mistpos/utils/pdfdocuments/pdf_sales_by_employee.dart';

class NavSalesByPayment extends StatefulWidget {
  const NavSalesByPayment({super.key});

  @override
  State<NavSalesByPayment> createState() => NavSalesByPaymentState();
}

class NavSalesByPaymentState extends State<NavSalesByPayment> {
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _adminController.getSalesPayment(_startDate, _endDate);
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
        if (_adminController.loadingSalesByPayment.value) {
          return MistLoader1().center();
        }
        if (_adminController.salesByPayment.isEmpty) {
          return "No sales today".text().center();
        }
        return SingleChildScrollView(
          child: _makeTable(_adminController.salesByPayment),
        );
      }).expanded1,
    ].column();
  }

  Widget _makeTable(RxList<SalesByPayment> salesByEmployee) {
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
              Text('Payment Method').padding(EdgeInsets.all(10)),
              Text('Gross Sales').padding(EdgeInsets.all(10)),
              Text('Average Sales').padding(EdgeInsets.all(10)),
              Text('Discounts').padding(EdgeInsets.all(10)),
              Text('Refunds').padding(EdgeInsets.all(10)),
              Text('Receipts').padding(EdgeInsets.all(10)),
              Text('Customers').padding(EdgeInsets.all(10)),
            ],
          ),
          ...salesByEmployee.map((e) {
            return TableRow(
              children: [
                Text(
                  e.paymentMethod,
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.grossSales,
                    _userController.user.value?.baseCurrence ?? '',
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.averageSalesPerReceipt,
                    _userController.user.value?.baseCurrence ?? '',
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.discounts,
                    _userController.user.value?.baseCurrence ?? '',
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  CurrenceConverter.getCurrenceFloatInStrings(
                    e.refunds,
                    _userController.user.value?.baseCurrence ?? '',
                  ),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.numberOfReceipts.toString(),
                ).padding(EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
                Text(
                  e.uniqueCustomerCount.toString(),
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
    _adminController.getSalesPayment(_startDate, _endDate);
  }

  void printDocument() async {
    PDFMaker maker = PDFMaker();
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    maker
        .createPDF(
          PdfSalesByEmployee(
            endDate: _endDate,
            startDate: _startDate,
            baseCurrence: baseCurrency,
            salesByEmployee: _adminController.salesByEmployee,
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
          _adminController.openFile(file);
        })
        .catchError((e) {
          Toaster.showError("Failed to generate PDF: $e");
        });
  }
}
