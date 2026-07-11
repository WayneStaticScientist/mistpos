import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:mistpos/features/settings/screens/screen_subscription.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/support/screens/screen_ai_subscription.dart';
import 'package:get/get.dart';

class MistAdminDashboard extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String selectedTile;
  final String currentPlan;
  final Function(String label) onTap;
  const MistAdminDashboard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.selectedTile,
    required this.onTap,
    this.currentPlan = 'free',
  });

  @override
  State<MistAdminDashboard> createState() => _MistAdminDashboardState();
}

class _MistAdminDashboardState extends State<MistAdminDashboard> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final surfaceColor = isDark ? const Color(0xFF0F1117) : Colors.white;

    return Drawer(
      elevation: 0,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Premium Header ──
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withAlpha(200)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.userName.isNotEmpty
                            ? widget.userName[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.userEmail,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(200),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // ── Plan & AI Badges ──
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => const ScreenSubscription()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _planIcon(widget.currentPlan),
                              color: _planBadgeColor(widget.currentPlan),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              MistSubscriptionUtils.getPlanDisplayName(
                                widget.currentPlan,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.open_in_new,
                              size: 11,
                              color: Colors.white.withAlpha(180),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => const ScreenAiSubscription()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${CompanyModel.fromStorage()?.aiSubscriptions.tokens ?? 0} AI Credits',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Search Field ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withAlpha(40)),
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search menu...',
                  hintStyle: TextStyle(color: Colors.grey.withAlpha(150), fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: primary, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── Scrollable Menu ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              children: [
                if (_searchQuery.isNotEmpty) ..._buildSearchResults() else ...[
                  _buildSectionHeader('ANALYTICS & REPORTS'),
                _buildNavItem("Overview", Carbon.dashboard, Colors.blueAccent),
                _buildNavItem("Monthly Reports", Carbon.report, Colors.indigoAccent),
                _buildNavItem("Yearly Reports", Carbon.calendar, Colors.indigoAccent),
                _buildNavItem("Daily Sales", Carbon.sun, Colors.orange),
                _buildNavItem("Product Analytics", Carbon.analytics, Colors.deepPurple),
                _buildNavItem("Expenses Overview", Carbon.chart_line_data, Colors.redAccent),
                _buildNavItem("Sales By Employee", Carbon.user, Colors.purple),
                _buildNavItem("Sales By Categories", Carbon.category, Colors.deepPurpleAccent),
                _buildNavItem("Sales By Payments", Carbon.money, Colors.green),
                _buildNavItem("Sales By Customers", Carbon.user_multiple, Colors.indigo),
                _buildNavItem("Shifts", Carbon.time_plot, Colors.indigo),
                _buildNavItem("Shift Logs", Carbon.event_schedule, Colors.teal),

                const SizedBox(height: 16),
                _buildSectionHeader('MULTISHOP OVERVIEW'),
                _buildNavItem("MultiShop Overview", Carbon.dashboard, Colors.blueAccent),
                _buildNavItem("MultiShop Daily Sales", Carbon.sun, Colors.orange),
                _buildNavItem("MultiShop Monthly Sales", Carbon.report, Colors.indigoAccent),
                _buildNavItem("MultiShop Yearly Sales", Carbon.calendar, Colors.indigoAccent),
                _buildNavItem("MultiShop Gigantic Overview", Carbon.chart_scatter, Colors.deepOrangeAccent),

                const SizedBox(height: 16),
                _buildSectionHeader('SUPPORT & HELP'),
                _buildNavItem("Mistpos AI", Carbon.bot, Colors.deepPurpleAccent),
                _buildNavItem("Support Tickets", Carbon.help, Colors.pinkAccent),
                _buildNavItem("System Diagnosis", Carbon.activity, Colors.green),
                _buildNavItem("Reseller", Carbon.user_multiple, Colors.indigoAccent),

                const SizedBox(height: 16),
                _buildSectionHeader('STORE OPERATIONS'),
                _buildNavItem("Receits", Carbon.receipt, Colors.redAccent),
                _buildNavItem("Customers", Carbon.user_multiple, Colors.cyan),
                _buildNavItem("Employees", Carbon.user_role, Colors.deepPurple),
                _buildNavItem("Stores", Carbon.store, Colors.blueGrey),
                _buildNavItem("Billing History", Carbon.wallet, Colors.green),

                const SizedBox(height: 16),
                _buildSectionHeader('INVENTORY MANAGEMENT'),
                _buildNavItem(
                  "Items",
                  Carbon.shopping_cart,
                  Colors.amber.shade700,
                ),
                _buildNavItem(
                  "Bulk Import/Export",
                  Carbon.upload,
                  Colors.teal,
                ),
                _buildNavItem(
                  "Categories",
                  Carbon.category,
                  Colors.indigoAccent,
                ),
                _buildNavItem("Modifiers", Carbon.add_alt, Colors.lightBlue),
                _buildNavItem("Discounts", Carbon.percentage, Colors.pink),
                _buildNavItem("Expenses", Carbon.wallet, Colors.red),

                const SizedBox(height: 16),
                _buildSectionHeader('STOCK & TRANSFERS'),
                _buildNavItem("Suppliers", Carbon.delivery_truck, Colors.brown),
                _buildNavItem(
                  "Purchase Orders",
                  Carbon.shopping_cart_plus,
                  Colors.deepOrange,
                ),
                _buildNavItem("Transfer Orders", Carbon.box, Colors.blue),
                _buildNavItem(
                  "Productions",
                  Carbon.assembly,
                  Colors.purpleAccent,
                ),
                _buildNavItem(
                  "Inventory Counts",
                  Carbon.chart_evaluation,
                  Colors.teal,
                ),
                _buildNavItem(
                  "Stock Adjustments",
                  Carbon.settings_adjust,
                  Colors.blueGrey,
                ),
                _buildNavItem(
                  "Inventory History",
                  Carbon.recently_viewed,
                  Colors.indigo,
                ),
                _buildNavItem(
                  "Inventory Valuation",
                  Carbon.chart_line,
                  Colors.green,
                ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    final List<Map<String, dynamic>> allItems = [
      {'label': "Overview", 'icon': Carbon.dashboard, 'color': Colors.blueAccent},
      {'label': "Monthly Reports", 'icon': Carbon.report, 'color': Colors.indigoAccent},
      {'label': "Yearly Reports", 'icon': Carbon.calendar, 'color': Colors.indigoAccent},
      {'label': "Daily Sales", 'icon': Carbon.sun, 'color': Colors.orange},
      {'label': "Product Analytics", 'icon': Carbon.analytics, 'color': Colors.deepPurple},
      {'label': "Expenses Overview", 'icon': Carbon.chart_line_data, 'color': Colors.redAccent},
      {'label': "Sales By Employee", 'icon': Carbon.user, 'color': Colors.purple},
      {'label': "Sales By Categories", 'icon': Carbon.category, 'color': Colors.deepPurpleAccent},
      {'label': "Sales By Payments", 'icon': Carbon.money, 'color': Colors.green},
      {'label': "Sales By Customers", 'icon': Carbon.user_multiple, 'color': Colors.indigo},
      {'label': "Shifts", 'icon': Carbon.time_plot, 'color': Colors.indigo},
      {'label': "Shift Logs", 'icon': Carbon.event_schedule, 'color': Colors.teal},
      {'label': "MultiShop Overview", 'icon': Carbon.dashboard, 'color': Colors.blueAccent},
      {'label': "MultiShop Daily Sales", 'icon': Carbon.sun, 'color': Colors.orange},
      {'label': "MultiShop Monthly Sales", 'icon': Carbon.report, 'color': Colors.indigoAccent},
      {'label': "MultiShop Yearly Sales", 'icon': Carbon.calendar, 'color': Colors.indigoAccent},
      {'label': "MultiShop Gigantic Overview", 'icon': Carbon.chart_scatter, 'color': Colors.deepOrangeAccent},
      {'label': "Mistpos AI", 'icon': Carbon.bot, 'color': Colors.deepPurpleAccent},
      {'label': "Support Tickets", 'icon': Carbon.help, 'color': Colors.pinkAccent},
      {'label': "System Diagnosis", 'icon': Carbon.activity, 'color': Colors.green},
      {'label': "Reseller", 'icon': Carbon.user_multiple, 'color': Colors.indigoAccent},
      {'label': "Receits", 'icon': Carbon.receipt, 'color': Colors.redAccent},
      {'label': "Customers", 'icon': Carbon.user_multiple, 'color': Colors.cyan},
      {'label': "Employees", 'icon': Carbon.user_role, 'color': Colors.deepPurple},
      {'label': "Stores", 'icon': Carbon.store, 'color': Colors.blueGrey},
      {'label': "Billing History", 'icon': Carbon.wallet, 'color': Colors.green},
      {'label': "Items", 'icon': Carbon.shopping_cart, 'color': Colors.amber.shade700},
      {'label': "Bulk Import/Export", 'icon': Carbon.upload, 'color': Colors.teal},
      {'label': "Categories", 'icon': Carbon.category, 'color': Colors.indigoAccent},
      {'label': "Modifiers", 'icon': Carbon.add_alt, 'color': Colors.lightBlue},
      {'label': "Discounts", 'icon': Carbon.percentage, 'color': Colors.pink},
      {'label': "Expenses", 'icon': Carbon.wallet, 'color': Colors.red},
      {'label': "Suppliers", 'icon': Carbon.delivery_truck, 'color': Colors.brown},
      {'label': "Purchase Orders", 'icon': Carbon.shopping_cart_plus, 'color': Colors.deepOrange},
      {'label': "Transfer Orders", 'icon': Carbon.box, 'color': Colors.blue},
      {'label': "Productions", 'icon': Carbon.assembly, 'color': Colors.purpleAccent},
      {'label': "Inventory Counts", 'icon': Carbon.chart_evaluation, 'color': Colors.teal},
      {'label': "Stock Adjustments", 'icon': Carbon.settings_adjust, 'color': Colors.blueGrey},
      {'label': "Inventory History", 'icon': Carbon.recently_viewed, 'color': Colors.indigo},
      {'label': "Inventory Valuation", 'icon': Carbon.chart_line, 'color': Colors.green},
    ];

    final filtered = allItems.where((item) => (item['label'] as String).toLowerCase().contains(_searchQuery)).toList();

    if (filtered.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text("No navigation items found.", style: TextStyle(color: Colors.grey))),
        )
      ];
    }

    return filtered.map((item) => _buildNavItem(item['label'], item['icon'], item['color'])).toList();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, String icon, Color iconColor) {
    final isSelected = widget.selectedTile == label;
    final isLocked = !MistSubscriptionUtils.hasAccessTo(label, widget.currentPlan);
    final requiredPlan = MistSubscriptionUtils.getRequiredPlanLabel(label);
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Locked items get a dimmed, muted look
    final effectiveIconColor = isLocked
        ? (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
        : (isSelected ? primary : iconColor);
    final effectiveTextColor = isLocked
        ? (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
        : (isSelected
            ? primary
            : (isDark ? Colors.white70 : Colors.black87));

    Widget tile = Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected && !isLocked ? primary.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLocked
                ? (isDark ? Colors.grey.shade900 : Colors.grey.shade100)
                : (isSelected ? primary.withAlpha(30) : iconColor.withAlpha(20)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Iconify(
            icon,
            color: effectiveIconColor,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected && !isLocked ? FontWeight.bold : FontWeight.w500,
            color: effectiveTextColor,
          ),
        ),
        trailing: isLocked
            ? _buildLockBadge(requiredPlan, isDark)
            : (isSelected
                ? Container(
                    width: 6,
                    height: 24,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : null),
        onTap: isLocked
            ? () => _showUpgradeDialog(label, requiredPlan)
            : () => widget.onTap(label),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );

    return tile;
  }

  Widget _buildLockBadge(String? requiredPlan, bool isDark) {
    return Tooltip(
      message: requiredPlan != null
          ? 'Requires $requiredPlan'
          : 'Upgrade to unlock',
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.amber.withAlpha(25)
              : Colors.amber.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.amber.withAlpha(80),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 12,
              color: Colors.amber.shade600,
            ),
            if (requiredPlan != null) ...[
              const SizedBox(width: 4),
              Text(
                _shortPlanName(requiredPlan),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _shortPlanName(String fullName) {
    // "Basic Plan" → "Basic", etc.
    return fullName.replaceAll(' Plan', '');
  }

  void _showUpgradeDialog(String label, String? requiredPlan) {
    Get.defaultDialog(
      title: "Upgrade Required",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: Colors.amber.shade600,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"$label" requires ${requiredPlan ?? 'a higher plan'}.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            'Upgrade your subscription to access this feature.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Maybe Later'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Get.back();
            Get.to(() => const ScreenSubscription());
          },
          icon: const Icon(Icons.rocket_launch_rounded, size: 16),
          label: const Text('Upgrade Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  IconData _planIcon(String plan) {
    switch (plan) {
      case 'enterprise':
        return Icons.workspace_premium_rounded;
      case 'pro':
        return Icons.star_rounded;
      case 'basic':
        return Icons.verified_rounded;
      case 'trial':
        return Icons.hourglass_top_rounded;
      default:
        return Icons.person_outline_rounded;
    }
  }

  Color _planBadgeColor(String plan) {
    switch (plan) {
      case 'enterprise':
        return Colors.amber;
      case 'pro':
        return Colors.lightBlueAccent;
      case 'basic':
        return Colors.greenAccent;
      case 'trial':
        return Colors.orangeAccent;
      default:
        return Colors.white70;
    }
  }
}
