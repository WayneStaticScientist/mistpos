import 'package:flutter/material.dart';
import 'dart:async';

import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/screens/inventory/screen_add_supplier.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScreenSelectSupplier extends StatefulWidget {
  const ScreenSelectSupplier({super.key});

  @override
  State<ScreenSelectSupplier> createState() => _ScreenSelectSupplierState();
}

class _ScreenSelectSupplierState extends State<ScreenSelectSupplier> {
  final _refreshController = RefreshController();
  final _iventoryController = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounce;
  @override
  void initState() {
    _iventoryController.loadSuppliers();
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
    return Scaffold(
      appBar: AppBar(
        title: "Select Supplier".text(),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: [
        MistSearchField(
          label: "Search Suppliers",
          controller: _searchController,
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullUp: true,
            onRefresh: () async {
              _iventoryController.loadSuppliers(page: 1, search: _searchTerm);
              _refreshController.refreshCompleted();
            },
            child: Obx(
              () => _iventoryController.suppliers.isEmpty
                  ? "No suppliers found . Click + to add new supplier".text()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        if (index < _iventoryController.suppliers.length) {
                          return _buildTile(
                            _iventoryController.suppliers[index],
                          );
                        }
                        return _buildLoader();
                      },
                      itemCount: _iventoryController.suppliers.length + 1,
                    ),
            ),
          ),
        ),
      ].column().padding(EdgeInsets.all(14)),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => Get.to(() => ScreenAddSupplier()),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTile(SupplierModel model) {
    return ListTile(
      onTap: () {
        _iventoryController.selectedSupplier.value = model;
        Get.back();
      },
      leading: CircleAvatar(child: Iconify(Bx.user, color: Colors.white)),
      title: model.name.text(),
      subtitle: model.email?.text(),
    );
  }

  Widget _buildLoader() {
    if (_iventoryController.supplierPage >=
        _iventoryController.supplierPage.value) {
      return ['No more Suppliers'.text()]
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
        _iventoryController.loadSuppliers(search: _searchTerm, page: 1);
      }
    });
  }
}
