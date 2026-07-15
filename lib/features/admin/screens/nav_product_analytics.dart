import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_product_analytics.dart';

class NavProductAnalytics extends StatefulWidget {
  const NavProductAnalytics({super.key});

  @override
  State<NavProductAnalytics> createState() => _NavProductAnalyticsState();
}

class _NavProductAnalyticsState extends State<NavProductAnalytics>
    with SingleTickerProviderStateMixin {
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  final _itemsController = Get.find<ItemsController>();

  late TabController _tabController;

  ItemModel? _selectedProduct;
  String _breakdownPeriod = 'daily';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initial fetch
    _itemsController.loadCartItems();
    _adminController.fetchTopSellers(period: 'month');
    _adminController.fetchLowSellers(page: 1);
    _adminController.fetchUnsoldProducts(page: 1);

    // Initial breakdown if we have items
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _itemsController.loadCartItems();
      if (_itemsController.cartItems.isEmpty) {
        await _itemsController.syncCartItemsOnBackground();
      }
      if (_itemsController.cartItems.isNotEmpty) {
        setState(() {
          _selectedProduct = _itemsController.cartItems.first;
        });
        _adminController.fetchProductBreakdown(
          productId: _selectedProduct!.hexId,
          period: _breakdownPeriod,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadBreakdown(ItemModel product, String period) {
    setState(() {
      _selectedProduct = product;
      _breakdownPeriod = period;
    });
    _adminController.fetchProductBreakdown(
      productId: product.hexId,
      period: period,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── SECTION 1: TOP 10 SELLERS ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSectionHeader(
                  'Top 10 Performing Products',
                  Carbon.trophy,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.print, color: Colors.blue),
                tooltip: "Print Analytics Report",
                onPressed: _printReport,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTopSellers(primary),

          const SizedBox(height: 40),

          // ── SECTION 2: LOW SELLERS & UNSOLD ──
          _buildSectionHeader('Product Performance Alerts', Carbon.warning_alt),
          const SizedBox(height: 16),
          _buildPerformanceAlerts(primary),

          const SizedBox(height: 40),

          // ── SECTION 3: PRODUCT DEEP DIVE ──
          _buildSectionHeader(
            'Individual Product Analysis',
            Carbon.chart_evaluation,
          ),
          const SizedBox(height: 16),
          _buildProductDeepDive(primary),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String icon) {
    return Row(
      children: [
        Iconify(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildPill(
    String label,
    String value,
    String currentValue,
    ValueChanged<String> onChanged,
    Color primary,
  ) {
    final selected = currentValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // TOP SELLERS
  // ──────────────────────────────────────────────────────────────────
  Widget _buildTopSellers(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              const Text(
                'Highest Volume',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPill(
                        'Today',
                        'today',
                        _adminController.topSellerPeriod.value,
                        (val) => _adminController.fetchTopSellers(period: val),
                        primary,
                      ),
                      _buildPill(
                        'Month',
                        'month',
                        _adminController.topSellerPeriod.value,
                        (val) => _adminController.fetchTopSellers(period: val),
                        primary,
                      ),
                      _buildPill(
                        'Year',
                        'year',
                        _adminController.topSellerPeriod.value,
                        (val) => _adminController.fetchTopSellers(period: val),
                        primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (_adminController.loadingTopSellers.value) {
              return const SizedBox(
                height: 200,
                child: Center(child: MistLoader1()),
              );
            }
            if (_adminController.topSellers.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text("No sales data found for this period."),
                ),
              );
            }

            final maxSold = _adminController.topSellers.fold(
              0.0,
              (m, p) => p.totalSold > m ? p.totalSold : m,
            );
            final currency = _userController.user.value?.baseCurrence ?? '';

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _adminController.topSellers.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.withAlpha(30), height: 24),
              itemBuilder: (context, index) {
                final product = _adminController.topSellers[index];
                return Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index < 3
                            ? primary.withAlpha(40)
                            : Colors.grey.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          color: index < 3 ? primary : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.totalSold.toInt()} sold',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: maxSold > 0
                                ? product.totalSold / maxSold
                                : 0,
                            backgroundColor: Colors.grey.withAlpha(30),
                            color: primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      CurrenceConverter.getCurrenceFloatk(
                        product.revenue,
                        currency,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // LOW SELLERS & UNSOLD
  // ──────────────────────────────────────────────────────────────────
  Widget _buildPerformanceAlerts(Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Low Selling (< 10 units)'),
              Tab(text: 'Never Sold'),
            ],
          ),
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              if (_tabController.index == 0) {
                return _buildLowSellersList(primary);
              } else {
                return _buildUnsoldList(primary);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLowSellersList(Color primary) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    return Obx(() {
      if (_adminController.loadingLowSellers.value) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: MistLoader1()),
        );
      }
      if (_adminController.lowSellers.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text("No low selling products found.")),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _adminController.lowSellers.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.withAlpha(30)),
        itemBuilder: (context, index) {
          final item = _adminController.lowSellers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: primary.withAlpha(20),
              child: Icon(Icons.trending_down, color: primary, size: 20),
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Sold: ${item.totalSold.toInt()} units"),
            trailing: Text(
              CurrenceConverter.getCurrenceFloatk(item.revenue, currency),
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildUnsoldList(Color primary) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    return Obx(() {
      if (_adminController.loadingUnsold.value) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: MistLoader1()),
        );
      }
      if (_adminController.unsoldProducts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text("All products have been sold at least once."),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _adminController.unsoldProducts.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.withAlpha(30)),
        itemBuilder: (context, index) {
          final item = _adminController.unsoldProducts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.withAlpha(20),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade400,
                size: 20,
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "In Stock: ${item.stockQuantity} • Price: ${CurrenceConverter.getCurrenceFloatInStrings(item.price, currency)}",
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "0 Sales",
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required Function(int) onPageChanged,
  }) {
    if (totalPages <= 1) return const SizedBox(height: 16);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          Text('Page $currentPage of $totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // DEEP DIVE
  // ──────────────────────────────────────────────────────────────────
  Widget _buildProductDeepDive(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Product
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withAlpha(40)),
                ),
                child: InkWell(
                  onTap: _showProductSearchDialog,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Obx(() {
                      if (_itemsController.cartItems.isEmpty &&
                          _itemsController.syncingItems.value) {
                        return const Text(
                          "Syncing products...",
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                      if (_selectedProduct == null) {
                        return const Text(
                          "Search Product...",
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedProduct!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPill('Daily', 'daily', _breakdownPeriod, (val) {
                      if (_selectedProduct != null)
                        _loadBreakdown(_selectedProduct!, val);
                    }, primary),
                    _buildPill('Monthly', 'monthly', _breakdownPeriod, (val) {
                      if (_selectedProduct != null)
                        _loadBreakdown(_selectedProduct!, val);
                    }, primary),
                    _buildPill('Yearly', 'yearly', _breakdownPeriod, (val) {
                      if (_selectedProduct != null)
                        _loadBreakdown(_selectedProduct!, val);
                    }, primary),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Charts
          Obx(() {
            if (_adminController.loadingBreakdown.value) {
              return const SizedBox(
                height: 250,
                child: Center(child: MistLoader1()),
              );
            }
            if (_selectedProduct == null) {
              return const SizedBox(
                height: 250,
                child: Center(
                  child: Text("Select a product to view analytics."),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildTrendChart(primary)),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildPieChart(primary)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTrendChart(primary),
                      const SizedBox(height: 32),
                      _buildPieChart(primary),
                    ],
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrendChart(Color primary) {
    final list = _adminController.productBreakdown;
    if (list.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: Text(
            "No trend data available.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final currency = _userController.user.value?.baseCurrence ?? '';
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minX: _breakdownPeriod == 'daily' ? 1 : (_breakdownPeriod == 'monthly' ? 1 : null),
          maxX: _breakdownPeriod == 'daily' ? 31 : (_breakdownPeriod == 'monthly' ? 12 : null),
          clipData: const FlClipData.all(),
          minY: 0,
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  // Find the matching item by value
                  final item = list.firstWhere(
                    (e) {
                      if (_breakdownPeriod == 'daily') {
                        final parts = e.date.split('/');
                        return (double.tryParse(parts.isNotEmpty ? parts[0] : '') ?? -1) == spot.x;
                      } else if (_breakdownPeriod == 'monthly') {
                        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                        return (months.indexOf(e.date) + 1).toDouble() == spot.x;
                      }
                      return double.tryParse(e.date) == spot.x;
                    },
                    orElse: () => list.first,
                  );
                  return LineTooltipItem(
                    '${item.date}\n',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.totalSold.toInt()} sold\n',
                        style: TextStyle(color: primary, fontSize: 11),
                      ),
                      TextSpan(
                        text: CurrenceConverter.getCurrenceFloatk(
                          item.revenue,
                          currency,
                        ),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: textColor.withAlpha(25), strokeWidth: 1),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(bottom: BorderSide(color: textColor.withAlpha(80))),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: textColor.withAlpha(150),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _breakdownPeriod == 'daily' ? 5 : 1,
                getTitlesWidget: (value, meta) {
                  String label = '';
                  if (_breakdownPeriod == 'daily') {
                    if (value == 1 || value.toInt() % 5 == 0) {
                      label = value.toInt().toString();
                    }
                  } else if (_breakdownPeriod == 'monthly') {
                    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                    int idx = value.toInt() - 1;
                    if (idx >= 0 && idx < 12) {
                      label = months[idx];
                    }
                  } else {
                    label = value.toInt().toString();
                  }

                  if (label.isEmpty) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor.withAlpha(150),
                        fontSize: 10,
                      ),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: list.map((e) {
                double x = 0;
                if (_breakdownPeriod == 'daily') {
                  final parts = e.date.split('/');
                  if (parts.isNotEmpty) x = double.tryParse(parts[0]) ?? 0;
                } else if (_breakdownPeriod == 'monthly') {
                  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                  x = (months.indexOf(e.date) + 1).toDouble();
                } else {
                  x = double.tryParse(e.date) ?? 0;
                }
                return FlSpot(x, e.totalSold);
              }).toList(),
              isCurved: true,
              color: primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: primary,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primary.withAlpha(100), primary.withAlpha(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Color primary) {
    final pieSlices = _adminController.productPieSlices;
    if (pieSlices.isEmpty || pieSlices.every((s) => s.percentage == 0)) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: Text(
            "No share data available.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final productSlice = pieSlices.firstWhere(
      (s) => s.name != 'Others',
      orElse: () => pieSlices.first,
    );
    final othersSlice = pieSlices.firstWhere(
      (s) => s.name == 'Others',
      orElse: () => pieSlices.last,
    );

    return Column(
      children: [
        const Text(
          "Sales Volume Share (All Time)",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: primary,
                  value: productSlice.percentage,
                  title: '${productSlice.percentage}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.grey.withAlpha(50),
                  value: othersSlice.percentage,
                  title: '${othersSlice.percentage}%',
                  radius: 45,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(productSlice.name, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(50),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('All Other Products', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Future<void> _showProductSearchDialog() async {
    String searchQuery = '';
    bool isSearching = false;
    List<ItemModel> searchResults = _itemsController.cartItems.toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Helper to fetch from API
    Future<void> fetchFromApi(String query, Function setStateDialog) async {
      setStateDialog(() => isSearching = true);
      final response = await Net.get(
        "/cashier/products?page=1&search=$query&salesOnly=false&lastSync=0",
      );
      if (!response.hasError && response.body['list'] != null) {
        final List<dynamic> list = response.body['list'];
        setStateDialog(() {
          searchResults = list.map((e) => ItemModel.fromJson(e)).toList();
          isSearching = false;
        });
      } else {
        setStateDialog(() => isSearching = false);
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Initial fetch if empty
            if (searchResults.isEmpty && !isSearching) {
              fetchFromApi('', setStateDialog);
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: isDark ? const Color(0xFF1E202C) : Colors.white,
              child: Container(
                width: 400,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Select Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onChanged: (value) {
                        searchQuery = value;
                        // Use local filter if we have everything, else API
                        if (_itemsController.cartItems.isNotEmpty) {
                          setStateDialog(() {
                            searchResults = _itemsController.cartItems.where((
                              item,
                            ) {
                              return item.name.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              );
                            }).toList();
                          });
                        } else {
                          fetchFromApi(searchQuery, setStateDialog);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: isSearching
                          ? const Center(child: CircularProgressIndicator())
                          : searchResults.isEmpty
                          ? const Center(child: Text("No products found."))
                          : ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final item = searchResults[index];
                                return ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(
                                    item.category,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, item);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((selected) {
      if (selected != null && selected is ItemModel) {
        _loadBreakdown(selected, _breakdownPeriod);
      }
    });
  }

  Future<void> _printReport() async {
    try {
      final currency = _userController.user.value?.baseCurrence ?? 'USD';
      final pdf = await PdfProductAnalytics.generate(
        baseCurrence: currency,
        topSellers: _adminController.topSellers,
        lowSellers: _adminController.lowSellers,
        unsoldProducts: _adminController.unsoldProducts,
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      Toaster.showError("Failed to generate PDF: $e");
    }
  }
}
