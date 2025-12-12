import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/models/product_stats_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';
import 'package:mistpos/utils/pdfdocuments/pdf_inv_evaluation.dart';

class NavInventoryValuation extends StatefulWidget {
  const NavInventoryValuation({super.key});

  @override
  State<NavInventoryValuation> createState() => NavInventoryValuationState();
}

class NavInventoryValuationState extends State<NavInventoryValuation> {
  final _userController = Get.find<UserController>();
  final _adminController = Get.find<AdminController>();
  final _inventoryController = Get.find<InventoryController>();
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inventoryController.loadInventoryValuation(
        start: _startDate,
        end: _endDate,
      );
      if (_inventoryController.company.value == null ||
          !(MistSubscriptionUtils.proList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return;
      }
      _inventoryController.loadInventoryProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_inventoryController.company.value == null ||
          !(MistSubscriptionUtils.proList.contains(
            _inventoryController.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return SingleChildScrollView(
        child: [
          14.gapHeight,
          [
                Iconify(Bx.calendar, color: AppTheme.color(context)),
                8.gapWidth,

                "From ${MistDateUtils.getInformalShortDate(_startDate)} - ${(DateUtils.isSameDay(_endDate, DateTime.now()) ? "Today " : MistDateUtils.getInformalShortDate(_endDate))}"
                    .text()
                    .visibleIfNotNull(_startDate),
              ]
              .row(mainAxisAlignment: MainAxisAlignment.center)
              .onTap(_changeDateRange),
          "Tap on the date icon to change date ranges".text(
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          Obx(() {
            if (_inventoryController.loadingInventoryValuation.value) {
              return MistLoader1();
            }
            if (_inventoryController.statsPoducts.value == null) {
              return "No value for that specified time".text();
            }
            return _makeSummary(_inventoryController.statsPoducts.value!);
          }),
          18.gapHeight,
          Obx(() {
            if (_inventoryController.loadingInventoryProducts.value) {
              return SizedBox();
            }
            return "Inventory Products".text();
          }),

          Obx(() {
            if (_inventoryController.loadingInventoryProducts.value) {
              return SizedBox();
            }
            return ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                _inventoryController.inventoryProductsTotalPages.value,
                (e) =>
                    MistChip(
                          label: (e + 1).toString(),
                          selected:
                              e ==
                              _inventoryController.inventoryProductsPage.value -
                                  1,
                        )
                        .onTap(() {
                          _inventoryController.loadInventoryProducts(
                            page: e + 1,
                          );
                        })
                        .padding(EdgeInsets.symmetric(horizontal: 5)),
              ),
            ).sizedBox(height: 50);
          }),
          18.gapHeight,
          Obx(() {
            if (_inventoryController.loadingInventoryProducts.value) {
              return MistLoader1();
            }
            if (_inventoryController.inventoryProducts.isEmpty) {
              return "No products found".text();
            }

            return _makeTable(_inventoryController.inventoryProducts);
          }),
        ].column(),
      );
    });
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
    _inventoryController.loadInventoryValuation(
      start: _startDate,
      end: _endDate,
    );
  }

  Widget _makeSummary(StatsProductModel statsProductModel) {
    return MistMordernLayout(
      label: "Summary",
      children: [
        ListTile(
          title: "Total Inventory Value".text(),
          subtitle: CurrenceConverter.getCurrenceFloatInStrings(
            statsProductModel.totalCost,
            _userController.user.value?.baseCurrence ?? '',
          ).text(style: TextStyle(fontSize: 18)),
        ),
        14.gapHeight,
        ListTile(
          title: "Total Retail Value".text(),
          subtitle: CurrenceConverter.getCurrenceFloatInStrings(
            statsProductModel.totalRevenue,
            _userController.user.value?.baseCurrence ?? '',
          ).text(style: TextStyle(fontSize: 18)),
        ),
        14.gapHeight,
        ListTile(
          title: "Potential Profit".text(),
          subtitle: CurrenceConverter.getCurrenceFloatInStrings(
            statsProductModel.totalRevenue - statsProductModel.totalCost,
            _userController.user.value?.baseCurrence ?? '',
          ).text(style: TextStyle(fontSize: 18)),
        ),
        ListTile(
          title: "Margin".text(),
          subtitle:
              "${((statsProductModel.totalCost / statsProductModel.totalRevenue) * 100).toStringAsFixed(0)}%"
                  .text(style: TextStyle(fontSize: 18)),
        ),
      ],
    ).sizedBox(width: double.infinity);
  }

  Widget _makeTable(RxList<ItemModel> inventoryProducts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(200.0), // Item
          1: FixedColumnWidth(100.0),
          2: FixedColumnWidth(100.0),
          3: FixedColumnWidth(100.0),
          4: FixedColumnWidth(100.0),
          5: FixedColumnWidth(100.0),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Text('Item Name').padding(EdgeInsets.all(10)),
              Text('Quantity').padding(EdgeInsets.all(10)),
              Text('Cost').padding(EdgeInsets.all(10)),
              Text('Retail').padding(EdgeInsets.all(10)),
              Text('Profit').padding(EdgeInsets.all(10)),
              Text('Margin').padding(EdgeInsets.all(10)),
            ],
          ),
          ...inventoryProducts.map(
            (e) => TableRow(
              children: [
                e.name.text().padding(EdgeInsets.all(10)),
                e.stockQuantity.toString().text().padding(EdgeInsets.all(10)),
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.cost *
                      ((e.isCompositeItem &&
                                  !e.useProduction &&
                                  e.trackStock) ||
                              (!e.trackStock)
                          ? 1
                          : e.stockQuantity),
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.all(10)),
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.price *
                      ((e.isCompositeItem &&
                                  !e.useProduction &&
                                  e.trackStock) ||
                              (!e.trackStock)
                          ? 1
                          : e.stockQuantity),
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.all(10)),
                CurrenceConverter.getCurrenceFloatInStrings(
                  (e.price - e.cost) *
                      ((e.isCompositeItem &&
                                  !e.useProduction &&
                                  e.trackStock) ||
                              (!e.trackStock)
                          ? 1
                          : e.stockQuantity),
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.all(10)),
                "${((e.cost / e.price) * 100).toStringAsFixed(2)}%"
                    .text()
                    .padding(EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    ).sizedBox(width: double.infinity);
  }

  void printDocument() async {
    if (_inventoryController.statsPoducts.value == null) {
      Toaster.showError("Stats hasnt loaded yet | please wait them to load");
      return;
    }
    PDFMaker maker = PDFMaker();
    final baseCurrency = _userController.user.value?.baseCurrence ?? '';
    maker
        .createPDF(
          PdfInvEvaluation(
            endDate: _endDate,
            startDate: _startDate,
            baseCurrence: baseCurrency,
            statsProductModel: _inventoryController.statsPoducts.value!,
            inventoryProducts: _inventoryController.inventoryProducts,
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
