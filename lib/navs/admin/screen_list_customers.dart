import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/screens/basic/screen_view_customer.dart';

class NavListCustomers extends StatefulWidget {
  const NavListCustomers({super.key});

  @override
  State<NavListCustomers> createState() => _NavListCustomersState();
}

class _NavListCustomersState extends State<NavListCustomers> {
  final _refreshController = RefreshController();
  final _userController = Get.find<UserController>();
  final _itemsController = Get.find<ItemsController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounce;
  @override
  void initState() {
    _itemsController.loadCustomers();
    _initializeTimer();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        await _itemsController.loadCustomers(page: 1, search: _searchTerm);
        _refreshController.refreshCompleted();
      },
      child: [
        MistSearchField(
          label: "Search Customers",
          controller: _searchController,
        ),
        18.gapHeight,
        Expanded(
          child: Obx(() {
            if (_itemsController.syncingCustomers.value) {
              return MistLoader1();
            }
            if (_itemsController.customers.isEmpty) {
              return "No customers found".text();
            }
            return _makeTable(_itemsController.customers);
          }),
        ),
      ].column().padding(EdgeInsets.all(14)),
    );
  }

  void _initializeTimer() {
    _debounce = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final searchTerm = _searchController.text;
      if (_searchTerm != searchTerm) {
        _searchTerm = searchTerm;
        _itemsController.loadCustomers(search: _searchTerm, page: 1);
      }
    });
  }

  Widget _makeTable(RxList<CustomerModel> customers) {
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
          6: FixedColumnWidth(120.0),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Text('Customer').padding(EdgeInsets.all(10)),
              Text('Email').padding(EdgeInsets.all(10)),
              Text('Visits').padding(EdgeInsets.all(10)),
              Text('Points').padding(EdgeInsets.all(10)),
              Text('Total Purchases').padding(EdgeInsets.all(10)),
              Text('Inbound Profit').padding(EdgeInsets.all(10)),
            ],
          ),
          ...customers.map(
            (e) => TableRow(
              children: [
                TableRowInkWell(
                  onTap: () => Get.to(() => ScreenViewCustomer(model: e)),
                  child: e.fullName.text().padding(EdgeInsets.all(10)),
                ),
                TableRowInkWell(
                  onTap: () => Get.to(() => ScreenViewCustomer(model: e)),
                  child: e.email.text().padding(EdgeInsets.all(10)),
                ),
                TableRowInkWell(
                  onTap: () => Get.to(() => ScreenViewCustomer(model: e)),
                  child: e.visits.toString().text().padding(EdgeInsets.all(10)),
                ),
                e.points.toString().text().padding(EdgeInsets.all(10)),
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.purchaseValue,
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.all(10)),
                CurrenceConverter.getCurrenceFloatInStrings(
                  e.inboundProfit,
                  _userController.user.value?.baseCurrence ?? '',
                ).text().padding(EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
