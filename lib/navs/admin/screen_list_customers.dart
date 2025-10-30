import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:mistpos/screens/basic/screen_view_customer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NavListCustomers extends StatefulWidget {
  const NavListCustomers({super.key});

  @override
  State<NavListCustomers> createState() => _NavListCustomersState();
}

class _NavListCustomersState extends State<NavListCustomers> {
  final _refreshController = RefreshController();
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
    return [
      MistSearchField(label: "Search Customers", controller: _searchController),
      Expanded(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          onRefresh: () async {
            _itemsController.loadCustomers(page: 1, search: _searchTerm);
            _refreshController.refreshCompleted();
          },
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, index) {
                if (index < _itemsController.customers.length) {
                  return _buildTile(_itemsController.customers[index]);
                }
                return _buildLoader();
              },
              itemCount: _itemsController.customers.length + 1,
            ),
          ),
        ),
      ),
    ].column().padding(EdgeInsets.all(14));
  }

  Widget _buildTile(CustomerModel model) {
    return ListTile(
      onTap: () => Get.to(() => ScreenViewCustomer(model: model)),
      leading: CircleAvatar(child: Iconify(Bx.user, color: Colors.white)),
      title: model.fullName.text(),
      subtitle: model.email.text(),
    );
  }

  Widget _buildLoader() {
    if (_itemsController.customerPage >=
        _itemsController.customerTotalPages.value) {
      return ['No more customers'.text()]
          .row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .padding(EdgeInsets.all(14));
    }
    return [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 200,
          ),
        ]
        .row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .padding(EdgeInsets.all(14));
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
}
