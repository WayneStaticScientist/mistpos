import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_receit_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReceitsLayoutView extends StatefulWidget {
  const ReceitsLayoutView({super.key});

  @override
  State<ReceitsLayoutView> createState() => _ReceitsLayoutViewState();
}

class _ReceitsLayoutViewState extends State<ReceitsLayoutView> {
  final _itemsListController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();
  final _searchController = TextEditingController();
  final _refreshController = RefreshController();
  String _searchKey = "";
  late Timer? _debounce;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _syncReceits(1, _searchKey);
    });
    _initDebounce();
  }

  void _initDebounce() {
    _debounce = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_searchController.text.trim() != _searchKey.trim()) {
        _searchKey = _searchController.text;
        _syncReceits(1, _searchKey);
      }
    });
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
      onRefresh: () async {
        await _syncReceits(1, _searchKey);
        _refreshController.refreshCompleted();
      },
      child: [
        MistSearchField(
          controller: _searchController,
          label: "Search Receits",
        ).padding(EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
        Obx(
          () => _itemsListController.receits.isNotEmpty
              ? GroupedListView<ItemReceitModel, String>(
                  elements: _itemsListController.receits,
                  groupBy: (element) =>
                      MistDateUtils.formatNormalDate(element.createdAt),
                  groupSeparatorBuilder: (String groupByValue) => Text(
                    groupByValue,
                    style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  itemBuilder: (context, ItemReceitModel element) =>
                      _buildItem(element),
                  itemComparator: (item1, item2) =>
                      item1.createdAt.compareTo(item2.createdAt), // optional
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: true, // optional
                  order: GroupedListOrder.DESC, // optional
                )
              : [
                  Iconify(Bx.receipt, color: AppTheme.color(context), size: 43),
                  14.gapHeight,
                  "No Receits ".text(
                    style: TextStyle(color: AppTheme.color(context)),
                  ),
                ].column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
        ).expanded1,
      ].column(),
    );
  }

  _buildItem(ItemReceitModel receit) {
    return ListTile(
          leading: Iconify(Carbon.receipt, color: AppTheme.color(context)),
          title: CurrenceConverter.getCurrenceFloatInStrings(
            receit.total,
            _userController.user.value?.baseCurrence ?? '',
          ).text(),
          trailing: Text(receit.label),
          subtitle: Text("${receit.createdAt.hour}:${receit.createdAt.minute}"),
          onTap: () => Get.to(() => ScreenReceitView(receitModel: receit)),
        )
        .decoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.withAlpha(50), width: 1),
              bottom: BorderSide(color: Colors.grey.withAlpha(50), width: 1),
            ),
          ),
        )
        .padding(EdgeInsets.symmetric(horizontal: 10, vertical: 5));
  }

  Future _syncReceits(int i, String searchKey) async {
    await _itemsListController.loadReceits(page: 1, search: searchKey);
  }
}
