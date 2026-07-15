import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/data/models/expense_model.dart';
import 'package:mistpos/features/inventory/controllers/expenses_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/inventory/screens/screen_expense_detail.dart';
import 'package:mistpos/features/settings/screens/screen_add_expense.dart';
import 'package:mistpos/core/widgets/layouts/subscription_alert.dart';

class _DateHeaderGroup {
  final DateTime date;
  final double total;
  _DateHeaderGroup(this.date, this.total);
}

class CategoryStyle {
  final IconData icon;
  final Color color;
  CategoryStyle(this.icon, this.color);
}

CategoryStyle _getCategoryStyle(String categoryName, Color primary) {
  final name = categoryName.toLowerCase();
  if (name.contains('food') ||
      name.contains('meal') ||
      name.contains('restaurant') ||
      name.contains('cafe')) {
    return CategoryStyle(
      Icons.restaurant_rounded,
      const Color(0xFFFF9800),
    ); // Orange
  } else if (name.contains('salary') ||
      name.contains('wage') ||
      name.contains('payroll')) {
    return CategoryStyle(
      Icons.monetization_on_rounded,
      const Color(0xFF4CAF50),
    ); // Green
  } else if (name.contains('rent') ||
      name.contains('office') ||
      name.contains('building') ||
      name.contains('housing')) {
    return CategoryStyle(
      Icons.business_rounded,
      const Color(0xFF9C27B0),
    ); // Purple
  } else if (name.contains('utility') ||
      name.contains('electricity') ||
      name.contains('water') ||
      name.contains('power')) {
    return CategoryStyle(
      Icons.electric_bolt_rounded,
      const Color(0xFFFFB300),
    ); // Amber/Yellow
  } else if (name.contains('transport') ||
      name.contains('travel') ||
      name.contains('car') ||
      name.contains('fuel') ||
      name.contains('gas') ||
      name.contains('cab')) {
    return CategoryStyle(
      Icons.directions_car_rounded,
      const Color(0xFF03A9F4),
    ); // Light Blue
  } else if (name.contains('marketing') ||
      name.contains('ad') ||
      name.contains('promo') ||
      name.contains('sales')) {
    return CategoryStyle(
      Icons.campaign_rounded,
      const Color(0xFFE91E63),
    ); // Pink
  } else if (name.contains('tax') ||
      name.contains('license') ||
      name.contains('legal') ||
      name.contains('insurance')) {
    return CategoryStyle(
      Icons.gavel_rounded,
      const Color(0xFF607D8B),
    ); // Blue Grey
  } else if (name.contains('supplies') ||
      name.contains('stationery') ||
      name.contains('stock') ||
      name.contains('inventory') ||
      name.contains('hardware')) {
    return CategoryStyle(
      Icons.inventory_2_rounded,
      const Color(0xFF8D6E63),
    ); // Brown
  } else if (name.contains('software') ||
      name.contains('subscription') ||
      name.contains('internet') ||
      name.contains('wifi') ||
      name.contains('telecom')) {
    return CategoryStyle(Icons.lan_rounded, const Color(0xFF3F51B5)); // Indigo
  } else if (name.contains('repair') ||
      name.contains('maintenance') ||
      name.contains('service')) {
    return CategoryStyle(
      Icons.build_rounded,
      const Color(0xFFE57373),
    ); // Soft Red
  }
  final hash = categoryName.hashCode;
  final colors = [
    const Color(0xFF00C896),
    const Color(0xFF00B0FF),
    const Color(0xFFFF7043),
    const Color(0xFFAB47BC),
    const Color(0xFF26A69A),
    const Color(0xFF5C6BC0),
    const Color(0xFF8D6E63),
    const Color(0xFF78909C),
  ];
  final color = colors[hash.abs() % colors.length];
  return CategoryStyle(Icons.receipt_long_rounded, color);
}

class NavExpenses extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavExpenses({super.key, this.scaffoldKey});

  @override
  State<NavExpenses> createState() => _NavExpensesState();
}

class _NavExpensesState extends State<NavExpenses> {
  final _inventory = Get.find<InventoryController>();
  final _ctrl = Get.find<ExpensesController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _selectedCategory;
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  Timer? _debounce;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _ctrl.syncExpenseCategories();
    // Use Future.delayed to ensure we don't trigger simultaneous API calls that might conflict on the backend
    Future.delayed(Duration.zero, () {
      _loadPage(1, reset: true);
      _fetchTotal();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadPage(int page, {bool reset = false}) {
    if (reset) {
      _hasMore = true;
      _currentPage = 1;
    }
    _ctrl.fetchPaginatedExpenses(
      page: page,
      search: _searchController.text,
      category: _selectedCategory ?? '',
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    if (_ctrl.fetchingPaginatedExpenses.value) return;
    final total = _ctrl.totalPaginatedExpenses.value;
    final loaded = _ctrl.paginatedExpenses.length;
    if (loaded >= total) {
      if (_hasMore) setState(() => _hasMore = false);
      return;
    }
    final nextPage = _currentPage + 1;
    _currentPage = nextPage;
    _ctrl.fetchPaginatedExpenses(
      page: nextPage,
      search: _searchController.text,
      category: _selectedCategory ?? '',
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      setState(() => _searchQuery = value);
      _loadPage(1, reset: true);
      _fetchTotal();
    });
  }

  void _fetchTotal() {
    _ctrl.fetchExpenses(
      search: _searchController.text,
      category: _selectedCategory ?? '',
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    bool isSubscribed = MistSubscriptionUtils.proList.contains(
      _inventory.company.value?.subscriptionType.type,
    );
    if (!isSubscribed) {
      Toaster.showError("Upgrade to pro-plan to use this feature");
      return;
    }
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadPage(1, reset: true);
      _fetchTotal();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = null;
      _startDate = null;
      _endDate = null;
      _hasMore = true;
    });
    _loadPage(1, reset: true);
    _fetchTotal();
  }

  bool get _hasFilters =>
      _selectedCategory != null ||
      _startDate != null ||
      _searchController.text.isNotEmpty;

  List<dynamic> _buildGroupedList(List<ExpenseModel> expenses) {
    final grouped = <String, List<ExpenseModel>>{};
    for (final e in expenses) {
      final key = '${e.date.year}-${e.date.month}-${e.date.day}';
      grouped.putIfAbsent(key, () => []).add(e);
    }
    final result = <dynamic>[];
    for (final entry in grouped.entries) {
      final list = entry.value;
      final sum = list.fold<double>(0.0, (acc, item) => acc + item.amount);
      result.add(_DateHeaderGroup(list.first.date, sum));
      result.addAll(list);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final bg = isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FB);
    final cardBg = isDark ? const Color(0xFF1C1F2E) : Colors.white;
    final textSecondary = isDark ? Colors.white54 : const Color(0xFF7B8099);

    return Obx(() {
      if (_inventory.company.value == null ||
          (_inventory.company.value!.subscriptionType.validUntil != null &&
              MistDateUtils.getDaysDifference(
                    _inventory.company.value!.subscriptionType.validUntil!,
                  ) <
                  0) ||
          !(MistSubscriptionUtils.basicList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }

      return Scaffold(
        backgroundColor: bg,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () => Get.to(() => AddExpenseScreen()),
          backgroundColor: primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Expense',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 4,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ── App Bar ──
            if (MediaQuery.of(context).size.width > 800)
              const SliverToBoxAdapter(child: SizedBox.shrink())
            else
              SliverAppBar(
                backgroundColor: isDark ? const Color(0xFF1C1F2E) : Colors.white,
                foregroundColor: isDark ? Colors.white : const Color(0xFF1A1D2E),
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
                ),
                title: const Text(
                  'Expenses',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                actions: [
                  if (_hasFilters)
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.close_rounded, size: 16),
                      label: const Text('Clear', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                    ),
                ],
              ),

            // ── Summary Banner (Scrolls away) ──
            SliverToBoxAdapter(
              child: _SummaryBanner(
                ctrl: _ctrl,
                primary: primary,
                isDark: isDark,
                startDate: _startDate,
                endDate: _endDate,
                onDateTap: () => _selectDateRange(context),
              ),
            ),

            // ── Search & Categories (Sticks to top when scrolling down) ──
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyFiltersDelegate(
                child: Container(
                  color: bg,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SearchBar(
                              controller: _searchController,
                              isDark: isDark,
                              primary: primary,
                              cardBg: cardBg,
                              onChanged: _onSearchChanged,
                              inventory: _inventory,
                            ),
                          ),
                          if (MediaQuery.of(context).size.width > 800 && _hasFilters) ...[
                            const SizedBox(width: 10),
                            TextButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(Icons.close_rounded, size: 16),
                              label: const Text('Clear', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                backgroundColor: isDark ? Colors.red.withAlpha(20) : Colors.red.withAlpha(10),
                                foregroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      _CategoryFilterRow(
                        ctrl: _ctrl,
                        isDark: isDark,
                        primary: primary,
                        cardBg: cardBg,
                        selected: _selectedCategory,
                        inventory: _inventory,
                        onSelected: (id) {
                          setState(() => _selectedCategory = id);
                          _loadPage(1, reset: true);
                          _fetchTotal();
                        },
                      ),
                    ],
                  ),
                ),
                // Approx height of search bar (52) + gap (10) + categories (36) + padding (24) = 122
                maxHeight: 122.0,
                minHeight: 122.0,
              ),
            ),

            // ── Expenses List ──
            Obx(() {
              if (_ctrl.fetchingPaginatedExpenses.value &&
                  _ctrl.paginatedExpenses.isEmpty) {
                return SliverFillRemaining(child: Center(child: MistLoader1()));
              }
              if (_ctrl.paginatedExpenses.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyState(textSecondary: textSecondary),
                );
              }

              final grouped = _buildGroupedList(_ctrl.paginatedExpenses);
              final isLoadingMore =
                  _ctrl.fetchingPaginatedExpenses.value &&
                  _ctrl.paginatedExpenses.isNotEmpty;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == grouped.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final item = grouped[index];
                    if (item is _DateHeaderGroup) {
                      return _DateHeader(
                        date: item.date,
                        total: item.total,
                        isDark: isDark,
                        textSecondary: textSecondary,
                      );
                    }
                    final expense = item as ExpenseModel;
                    return _ExpenseCard(
                      expense: expense,
                      primary: primary,
                      cardBg: cardBg,
                      isDark: isDark,
                      onTap: () => Get.to(
                        () => ScreenExpenseDetail(expense: expense),
                        transition: Transition.rightToLeft,
                      ),
                    );
                  }, childCount: grouped.length + (isLoadingMore ? 1 : 0)),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

// ── Sticky Header Delegate ──────────────────────────────────────────────────

class _StickyFiltersDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _StickyFiltersDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // We always want to rebuild when state changes so it updates filters
  }
}

// ── Summary Banner ──────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final ExpensesController ctrl;
  final Color primary;
  final bool isDark;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onDateTap;

  const _SummaryBanner({
    required this.ctrl,
    required this.primary,
    required this.isDark,
    required this.startDate,
    required this.endDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            primary.withBlue((primary.blue + 50).clamp(0, 255)),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withAlpha(70),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Total
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL EXPENSES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => ctrl.fetchingExpenses.value
                        ? const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            CurrenceConverter.selectedCurrencyInString(
                              ctrl.totalExpenses.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '${ctrl.totalPaginatedExpenses.value} records',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Date range button
            GestureDetector(
              onTap: onDateTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(60)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Period',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      startDate != null && endDate != null
                          ? '${MistDateUtils.getInformalShortDate(startDate!)} –\n${MistDateUtils.getInformalShortDate(endDate!)}'
                          : 'Whole Period',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color primary;
  final Color cardBg;
  final ValueChanged<String> onChanged;
  final InventoryController inventory;

  const _SearchBar({
    required this.controller,
    required this.isDark,
    required this.primary,
    required this.cardBg,
    required this.onChanged,
    required this.inventory,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSubscribed = MistSubscriptionUtils.proList.contains(
        inventory.company.value?.subscriptionType.type,
      );
      return TextField(
        controller: controller,
        readOnly: !isSubscribed,
        onChanged: isSubscribed ? onChanged : null,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A1D2E),
        ),
        decoration: InputDecoration(
          hintText: isSubscribed
              ? 'Search reason, reference, notes…'
              : 'Upgrade to Pro to search',
          hintStyle: TextStyle(
            color: isSubscribed ? Colors.grey : Colors.red.withAlpha(180),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            isSubscribed ? Icons.search_rounded : Icons.lock_rounded,
            color: isSubscribed ? primary : Colors.red,
            size: 20,
          ),
          filled: true,
          fillColor: cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      );
    });
  }
}

// ── Category Filter Row ──────────────────────────────────────────────────────

class _CategoryFilterRow extends StatelessWidget {
  final ExpensesController ctrl;
  final bool isDark;
  final Color primary;
  final Color cardBg;
  final String? selected;
  final InventoryController inventory;
  final ValueChanged<String?> onSelected;

  const _CategoryFilterRow({
    required this.ctrl,
    required this.isDark,
    required this.primary,
    required this.cardBg,
    required this.selected,
    required this.inventory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.categories.isEmpty) return const SizedBox.shrink();
      return SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // "All" chip
            _Chip(
              label: 'All',
              isSelected: selected == null,
              primary: primary,
              cardBg: cardBg,
              isDark: isDark,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: 8),
            ...ctrl.categories.map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _Chip(
                  label: cat.label,
                  isSelected: selected == cat.id,
                  primary: primary,
                  cardBg: cardBg,
                  isDark: isDark,
                  onTap: () {
                    final isSubscribed = MistSubscriptionUtils.proList.contains(
                      inventory.company.value?.subscriptionType.type,
                    );
                    if (!isSubscribed) {
                      Toaster.showError(
                        "Upgrade to pro-plan to use this feature",
                      );
                      return;
                    }
                    onSelected(cat.id);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color primary;
  final Color cardBg;
  final bool isDark;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.primary,
    required this.cardBg,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primary : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.withAlpha(50),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white60 : Colors.black54),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── Date Header ──────────────────────────────────────────────────────────────

class _DateHeader extends StatelessWidget {
  final DateTime date;
  final double total;
  final bool isDark;
  final Color textSecondary;

  const _DateHeader({
    required this.date,
    required this.total,
    required this.isDark,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    String label;
    if (target == today) {
      label = 'Today';
    } else if (target == today.subtract(const Duration(days: 1))) {
      label = 'Yesterday';
    } else {
      label = MistDateUtils.formatNormalDate(date);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withAlpha(220)
                  : const Color(0xFF1A1D2E),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(20)
                  : primaryColor(context).withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(30)
                    : primaryColor(context).withAlpha(50),
                width: 1,
              ),
            ),
            child: Text(
              CurrenceConverter.selectedCurrencyInString(total),
              style: TextStyle(
                color: isDark ? Colors.white60 : primaryColor(context),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: Colors.grey.withAlpha(40), height: 1)),
        ],
      ),
    );
  }

  Color primaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
}

// ── Expense Card ─────────────────────────────────────────────────────────────

class _ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final Color primary;
  final Color cardBg;
  final bool isDark;
  final VoidCallback onTap;

  const _ExpenseCard({
    required this.expense,
    required this.primary,
    required this.cardBg,
    required this.isDark,
    required this.onTap,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF00C896);
      case 'rejected':
        return const Color(0xFFFF4C6A);
      default:
        return const Color(0xFFFFA726);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1D2E);
    final textSecondary = isDark ? Colors.white54 : const Color(0xFF7B8099);
    final statusColor = _statusColor(expense.status);
    final categoryLabel = expense.category['label'] ?? '—';
    final catStyle = _getCategoryStyle(categoryLabel, primary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      // Category icon box
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: catStyle.color.withAlpha(22),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          catStyle.icon,
                          color: catStyle.color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.expenseFor,
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                // Category pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: catStyle.color.withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: catStyle.color.withAlpha(60),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    categoryLabel,
                                    style: TextStyle(
                                      color: catStyle.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  MistDateUtils.formatTime(expense.date),
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Amount + chevron
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CurrenceConverter.selectedCurrencyInString(
                              expense.amount,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFFF4C6A),
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: textSecondary,
                            size: 18,
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
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final Color textSecondary;
  const _EmptyState({required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No expenses found',
            style: TextStyle(
              color: textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or add a new expense.',
            style: TextStyle(color: textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
