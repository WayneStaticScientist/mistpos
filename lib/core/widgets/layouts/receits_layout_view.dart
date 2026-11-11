import 'dart:async';

import 'package:get/get.dart';

import 'package:exui/exui.dart';

import 'package:flutter/material.dart';

import 'package:iconify_flutter/icons/bx.dart';

import 'package:mistpos/core/utils/date_utils.dart';

import 'package:mistpos/core/themes/app_theme.dart';

import 'package:iconify_flutter/iconify_flutter.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:mistpos/data/models/item_receit_model.dart';

import 'package:mistpos/core/utils/currence_converter.dart';

import 'package:mistpos/core/widgets/inputs/search_field.dart';

import 'package:mistpos/features/auth/controllers/user_controller.dart';

import 'package:mistpos/features/inventory/controllers/items_controller.dart';

import 'package:mistpos/features/settings/screens/screen_receit_view.dart';

import 'package:mistpos/core/utils/zimra_receipt_type.dart';

import 'package:mistpos/core/utils/receipt_list_sort.dart';

import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';

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

  final _inventoryController = Get.find<InventoryController>();

  String _searchKey = "";

  String _filterStatus = "All";

  late Timer? _debounce;

  static const _filterOptions = [
    _FilterOption("All", "All", null),

    _FilterOption("Payed", "Paid", Icons.payments_outlined),

    _FilterOption("Credit", "On credit", Icons.credit_card_outlined),

    _FilterOption(
      "CreditNote",
      "Credit notes",
      null,
      kind: ZimraReceiptKind.creditNote,
      chipTag: 'CN',
    ),

    _FilterOption(
      "DebitNote",
      "Debit notes",
      null,
      kind: ZimraReceiptKind.debitNote,
      chipTag: 'DN',
    ),

    _FilterOption("FiscalInvoice", "Invoices", Icons.receipt_long_outlined),
  ];

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 850;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 1000 : double.infinity,
        ),
        child: SmartRefresher(
          controller: _refreshController,

          onRefresh: () async {
            await _syncReceits(1, _searchKey);

            _refreshController.refreshCompleted();
          },

          child: CustomScrollView(
            controller: _scrollController,

            slivers: [
              SliverAppBar(
                floating: true,

                snap: true,

                pinned: false,

                elevation: 0,

                automaticallyImplyLeading: false,

                backgroundColor: Theme.of(context).scaffoldBackgroundColor,

                toolbarHeight: 132,

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

                          label: "Search receipts, CN, DN…",
                        ).padding(const EdgeInsets.symmetric(horizontal: 2)),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,

                          child: Row(
                            children: [
                              for (
                                var i = 0;
                                i < _filterOptions.length;
                                i++
                              ) ...[
                                if (i > 0) 8.gapWidth,

                                _buildFilterChip(_filterOptions[i]),
                              ],
                            ],
                          ).padding(const EdgeInsets.symmetric(horizontal: 2)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Obx(() {
                if (_itemsListController.receits.isNotEmpty) {
                  final Map<String, List<ItemReceitModel>> grouped = {};

                  for (var item in _itemsListController.receits) {
                    final date = MistDateUtils.formatSortableDate(
                      item.createdAt,
                    );

                    grouped.putIfAbsent(date, () => []).add(item);
                  }

                  final List<dynamic> flatList = [];

                  final sortedKeys = grouped.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

                  for (var key in sortedKeys) {
                    flatList.add(key);

                    flatList.addAll(
                      ReceiptListSort.orderForDisplay(grouped[key]!),
                    );
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

                        "No receipts found".text(
                          style: TextStyle(color: AppTheme.color(context)),
                        ),
                      ],
                    ).padding(const EdgeInsets.all(20)),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String date) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 8, right: 16),

      child: Text(
        date.split(" ").skip(1).join(" ").toUpperCase(),

        style: TextStyle(
          fontSize: 11,

          fontWeight: FontWeight.w700,

          letterSpacing: 1.2,

          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildFilterChip(_FilterOption option) {
    final isSelected = _filterStatus == option.value;

    Color? accent;

    if (option.kind != null) {
      accent = ZimraReceiptDisplay.accentColor(option.kind!);
    }

    return FilterChip(
      showCheckmark: true,

      checkmarkColor: accent ?? Theme.of(context).colorScheme.primary,

      avatar: option.chipTag != null
          ? CircleAvatar(
              radius: 10,

              backgroundColor: (accent ?? Colors.grey).withAlpha(40),

              child: Text(
                option.chipTag!,

                style: TextStyle(
                  fontSize: 8,

                  fontWeight: FontWeight.bold,

                  color: accent,
                ),
              ),
            )
          : option.icon != null
          ? Icon(
              option.icon,

              size: 16,

              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            )
          : null,

      label: Text(option.label),

      selected: isSelected,

      onSelected: (bool selected) {
        if (selected) {
          setState(() => _filterStatus = option.value);

          _syncReceits(1, _searchKey);
        }
      },

      selectedColor: (accent ?? Theme.of(context).colorScheme.primary)
          .withAlpha(45),

      labelStyle: TextStyle(
        color: isSelected
            ? (accent ?? Theme.of(context).colorScheme.primary)
            : Colors.grey.shade700,

        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,

        fontSize: 13,
      ),

      side: BorderSide(
        color: isSelected
            ? (accent ?? Theme.of(context).colorScheme.primary).withAlpha(160)
            : Colors.grey.withAlpha(100),
      ),
    );
  }

  Widget _buildItem(ItemReceitModel receit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final kind = ZimraReceiptDisplay.kindOf(receit);

    final isAdjustment = ZimraReceiptDisplay.isAdjustment(receit);

    final accent = ZimraReceiptDisplay.accentColor(kind);

    final currency = _userController.user.value?.baseCurrence ?? '';

    final zimraEnabled =
        _inventoryController.company.value?.zimraCertificate != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),

      decoration: BoxDecoration(
        color: AppTheme.surface(context),

        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withAlpha(12),

            blurRadius: 8,

            offset: const Offset(0, 2),
          ),
        ],

        border: Border.all(
          color: isAdjustment
              ? accent.withAlpha(isDark ? 100 : 140)
              : isDark
              ? Colors.white.withAlpha(12)
              : Colors.grey.withAlpha(40),
        ),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            onTap: () => Get.to(() => ScreenReceitView(receitModel: receit)),

            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Container(
                    width: 5,

                    color: isAdjustment
                        ? accent
                        : receit.creditSale
                        ? Colors.redAccent
                        : Theme.of(context).colorScheme.primary.withAlpha(180),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,

                                  vertical: 4,
                                ),

                                decoration: BoxDecoration(
                                  color: accent.withAlpha(isDark ? 35 : 28),

                                  borderRadius: BorderRadius.circular(6),

                                  border: Border.all(
                                    color: accent.withAlpha(90),
                                  ),
                                ),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Iconify(
                                      ZimraReceiptDisplay.listIconifyAsset(
                                        kind,
                                      ),

                                      size: 14,

                                      color: accent,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      ZimraReceiptDisplay.listBadgeLabel(
                                        receit,
                                      ),

                                      style: TextStyle(
                                        fontSize: 10,

                                        fontWeight: FontWeight.w800,

                                        letterSpacing: 0.8,

                                        color: accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              Text(
                                CurrenceConverter.getCurrenceFloatInStrings(
                                  receit.total.abs(),

                                  currency,
                                ),

                                style: TextStyle(
                                  fontWeight: FontWeight.w800,

                                  fontSize: 17,

                                  color: ZimraReceiptDisplay.amountColor(
                                    kind,

                                    creditSale: receit.creditSale,
                                  ),
                                ),
                              ),

                              if (kind == ZimraReceiptKind.creditNote)
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),

                                  child: Text(
                                    'CR',

                                    style: TextStyle(
                                      fontSize: 9,

                                      fontWeight: FontWeight.bold,

                                      color: accent.withAlpha(200),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '#${receit.label}',

                            style: const TextStyle(
                              fontWeight: FontWeight.w700,

                              fontSize: 16,

                              letterSpacing: 0.2,
                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          Text(
                            ZimraReceiptDisplay.listSubtitle(receit),

                            style: TextStyle(
                              color: Colors.grey.shade600,

                              fontSize: 12.5,

                              height: 1.35,
                            ),

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 6,

                            runSpacing: 6,

                            crossAxisAlignment: WrapCrossAlignment.center,

                            children: [
                              if (zimraEnabled)
                                _statusPill(
                                  receit.fiscalized
                                      ? 'ZIMRA OK'
                                      : 'NOT FISCALIZED',

                                  receit.fiscalized
                                      ? Colors.teal
                                      : Colors.redAccent,
                                ),

                              if (receit.creditSale)
                                _statusPill('ON CREDIT', Colors.redAccent)
                              else if (!receit.synced)
                                _statusPill(
                                  'SYNC PENDING',
                                  Colors.orange.shade700,
                                )
                              else if (kind == ZimraReceiptKind.fiscalInvoice)
                                _statusPill('PAID', Colors.green.shade700),

                              if (receit.fiscalized &&
                                  receit.zimraFiscalDayNo != null &&
                                  receit.zimraReceiptGlobalNo != null)
                                _statusPill(
                                  'FD ${receit.zimraFiscalDayNo}/${receit.zimraReceiptGlobalNo}',

                                  Colors.blueGrey,

                                  dense: true,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusPill(String label, Color color, {bool dense = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 6 : 8,

        vertical: dense ? 2 : 3,
      ),

      decoration: BoxDecoration(
        color: color.withAlpha(28),

        borderRadius: BorderRadius.circular(5),

        border: Border.all(color: color.withAlpha(80)),
      ),

      child: Text(
        label,

        style: TextStyle(
          color: color,

          fontSize: dense ? 9 : 10,

          fontWeight: FontWeight.w700,

          letterSpacing: 0.6,
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

class _FilterOption {
  final String value;

  final String label;

  final IconData? icon;

  final ZimraReceiptKind? kind;

  final String? chipTag;

  const _FilterOption(
    this.value,
    this.label,
    this.icon, {
    this.kind,
    this.chipTag,
  });
}
