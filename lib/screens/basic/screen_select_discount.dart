import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenSelectDiscount extends StatefulWidget {
  const ScreenSelectDiscount({super.key});

  @override
  State<ScreenSelectDiscount> createState() => _ScreenSelectDiscountState();
}

class _ScreenSelectDiscountState extends State<ScreenSelectDiscount> {
  final _itemsController = Get.find<ItemsController>();
  final baseCurreny = Get.find<UserController>().user.value?.baseCurrence ?? '';
  final _searchController = TextEditingController();
  Timer? timer;
  String _searchKey = '';
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _itemsController.loadDiscounts();
    });
    _initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Select Discount".text()),
      body: [
        MistSearchField(
          controller: _searchController,
          label: "Search Discounts",
        ),
        18.gapHeight,
        Obx(() {
          if (_itemsController.syncingDiscounts.value) {
            return const Center(child: MistLoader1());
          }
          if (_itemsController.discounts.isEmpty) {
            return _emptyWidget();
          }
          return ListView.builder(
            itemBuilder: (context, index) => InkWell(
              child: _makeTile(item: _itemsController.discounts[index]),
            ),
            itemCount: _itemsController.discounts.length,
          );
        }).expanded1,
      ].column().padding(EdgeInsets.all(9)),
    );
  }

  Widget _emptyWidget() {
    return "No discounts found".text().center();
  }

  Widget _makeTile({required DiscountModel item}) {
    return ListTile(
      title: item.name.text(),
      onTap: () => Get.back(result: item),
      leading: Iconify(Bx.bxs_discount, color: Get.theme.colorScheme.primary),
      subtitle:
          (item.percentage
                  ? "${item.value}%"
                  : CurrenceConverter.getCurrenceFloatInStrings(
                      item.value,
                      baseCurreny,
                    ))
              .text(),
    );
  }

  void _initTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_searchKey != _searchController.text) {
        _searchKey = _searchController.text;
        _searchKey = _searchController.text;
        _itemsController.loadDiscounts(search: _searchKey);
      }
    });
  }
}
