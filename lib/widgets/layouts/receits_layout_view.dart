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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_receit_view.dart';

class ReceitsLayoutView extends StatefulWidget {
  const ReceitsLayoutView({super.key});

  @override
  State<ReceitsLayoutView> createState() => _ReceitsLayoutViewState();
}

class _ReceitsLayoutViewState extends State<ReceitsLayoutView> {
  final _scrollController = ScrollController();
  final _refreshController = RefreshController();
  final _searchController = TextEditingController();
  final _userController = Get.find<UserController>();
  final _itemsListController = Get.find<ItemsController>();
  String _searchKey = "";
  late Timer? _debounce;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _syncReceits(1, _searchKey);
    });
    // 💡 FIX APPLIED HERE
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll * 0.95) {
        _syncReceits(_itemsListController.receitsPage.value + 1, _searchKey);
      }
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
    _scrollController.dispose();
    _refreshController.dispose();
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

      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.all(8),
        children: [
          MistSearchField(
            controller: _searchController,
            label: "Search Receits",
          ).padding(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
          18.gapHeight,
          Obx(
            () => _itemsListController.receits.isNotEmpty
                ? GroupedListView<ItemReceitModel, String>(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    elements: _itemsListController.receits,
                    groupBy: (element) =>
                        MistDateUtils.formatSortableDate(element.createdAt),
                    groupSeparatorBuilder: (String groupByValue) =>
                        // ... (Your separator logic)
                        groupByValue
                            .split(" ")
                            .skip(1)
                            .join(" ")
                            .text(
                              style: TextStyle(
                                fontSize: 12,
                                color: Get.theme.colorScheme.primary,
                              ),
                            )
                            .row()
                            .padding(const EdgeInsets.all(10)),
                    itemBuilder: (context, ItemReceitModel element) {
                      return [
                        _buildItem(element),
                        14.gapHeight,
                      ].column(mainAxisSize: MainAxisSize.min);
                    },
                    itemComparator: (item1, item2) =>
                        -item1.createdAt.compareTo(item2.createdAt),
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    order: GroupedListOrder.DESC,
                  )
                : [
                    // Empty state is now correctly inside the ListView
                    Iconify(
                      Bx.receipt,
                      color: AppTheme.color(context),
                      size: 43,
                    ),
                    14.gapHeight,
                    "No Receits ".text(
                      style: TextStyle(color: AppTheme.color(context)),
                    ),
                  ].column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
          ).padding(const EdgeInsets.only(bottom: 8.0)), // Removed .expanded1
        ],
      ), // Outer padding
    );
  }

  Widget _buildItem(ItemReceitModel receit) {
    return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Iconify(
            Carbon.receipt,
            color: receit.creditSale ? Colors.red : AppTheme.color(context),
          ),
          title:
              CurrenceConverter.getCurrenceFloatInStrings(
                receit.total,
                _userController.user.value?.baseCurrence ?? '',
              ).text(
                style: TextStyle(color: receit.creditSale ? Colors.red : null),
              ),
          trailing: Text(
            receit.label,
            style: TextStyle(
              fontSize: 10,
              color: receit.creditSale ? Colors.red : null,
            ),
          ),
          subtitle: Text(
            "${receit.createdAt.hour.toString().padLeft(2, '0')}:${receit.createdAt.minute.toString().padLeft(2, '0')} ${receit.creditSale ? '(credit)' : ''}",
            style: TextStyle(color: receit.creditSale ? Colors.red : null),
          ),
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
    await _itemsListController.loadReceits(page: i, search: searchKey);
  }
}
