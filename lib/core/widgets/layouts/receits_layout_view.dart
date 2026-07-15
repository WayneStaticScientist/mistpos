import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/inputs/search_field.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/features/settings/screens/screen_receit_view.dart';

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
  String _filterStatus = "All"; // "All" or "Credit"
  late Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _syncReceits(1, _searchKey);
    });

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
        setState(() {
          _searchKey = _searchController.text;
        });
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
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Floating and Snapping Header
          // This will scroll away when going down and reappear on scroll up
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 120.0, // Height to fit search and filters
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MistSearchField(
                      controller: _searchController,
                      label: "Search Receipts",
                    ).padding(const EdgeInsets.symmetric(horizontal: 2)),

                    // Filter Chips Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip("All"),
                          10.gapWidth,
                          _buildFilterChip("Payed"),
                          10.gapWidth,
                          _buildFilterChip("Credit"),
                        ],
                      ).padding(const EdgeInsets.symmetric(horizontal: 2)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // The List Content
          Obx(() {
            // 2. Check if empty after filter
            if (_itemsListController.receits.isNotEmpty) {
              // Group logic
              final Map<String, List<ItemReceitModel>> grouped = {};
              for (var item in _itemsListController.receits) {
                final date = MistDateUtils.formatSortableDate(item.createdAt);
                if (!grouped.containsKey(date)) {
                  grouped[date] = [];
                }
                grouped[date]!.add(item);
              }

              // Flatten logic: [Header, Item, Item, Header, Item...]
              final List<dynamic> flatList = [];
              final sortedKeys = grouped.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              for (var key in sortedKeys) {
                flatList.add(key); // Add Date String as Header
                flatList.addAll(grouped[key]!); // Add Items
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = flatList[index];
                  if (item is String) {
                    return _buildGroupHeader(item);
                  } else if (item is ItemReceitModel) {
                    return _buildItem(item);
                  }
                  return const SizedBox.shrink();
                }, childCount: flatList.length),
              );
            } else {
              // Empty State
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Iconify(
                      Bx.receipt,
                      color: AppTheme.color(context),
                      size: 43,
                    ),
                    14.gapHeight,
                    "No Receipts found".text(
                      style: TextStyle(color: AppTheme.color(context)),
                    ),
                  ],
                ).padding(const EdgeInsets.all(20)),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildGroupHeader(String date) {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 24, bottom: 8, right: 16),
      child: Text(
        date.split(" ").skip(1).join(" ").toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _filterStatus == label;
    return ChoiceChip(
      checkmarkColor: Theme.of(context).colorScheme.primary,
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _filterStatus = label;
          });
          _syncReceits(1, _searchKey);
        }
      },
      selectedColor: Get.theme.colorScheme.primary.withAlpha(60),
      labelStyle: TextStyle(
        color: isSelected ? Get.theme.colorScheme.primary : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Get.theme.colorScheme.primary
              : Colors.grey.withAlpha(128),
        ),
      ),
    );
  }

  Widget _buildItem(ItemReceitModel receit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha((255 * 0.3).toInt()), // 30% opacity
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: receit.creditSale
              ? Colors.red.withAlpha(30)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => ScreenReceitView(receitModel: receit)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: receit.creditSale
                        ? Colors.red.withAlpha(20)
                        : Get.theme.colorScheme.primary.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Iconify(
                    Carbon.receipt,
                    color: receit.creditSale
                        ? Colors.red
                        : Get.theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "#${receit.label}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrenceConverter.getCurrenceFloatInStrings(
                              receit.total,
                              _userController.user.value?.baseCurrence ?? '',
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: receit.creditSale
                                  ? Colors.red.shade400
                                  : AppTheme.color(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${receit.createdAt.hour.toString().padLeft(2, '0')}:${receit.createdAt.minute.toString().padLeft(2, '0')} • ${receit.items.length} items",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (receit.creditSale)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "CREDIT",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                          else if (!receit.synced)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "PENDING",
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "PAID",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _syncReceits(int i, String searchKey) async {
    await _itemsListController.loadReceits(
      page: i,
      search: searchKey,
      filter: _filterStatus,
    );
  }
}
