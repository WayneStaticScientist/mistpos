import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/admin/controllers/admin_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/core/utils/subscriptions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mistpos/data/models/payment_request_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/bxl.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_billing_history.dart';

class NavBillingHistory extends StatefulWidget {
  const NavBillingHistory({super.key});

  @override
  State<NavBillingHistory> createState() => NavBillingHistoryState();
}

class NavBillingHistoryState extends State<NavBillingHistory> {
  final _adminController = Get.find<AdminController>();
  final _userController = Get.find<UserController>();
  final _inventoryController = Get.find<InventoryController>();
  final _refreshController = RefreshController();

  String _selectedStatus = 'All';
  final List<String> _statuses = ['All', 'Completed', 'Pending', 'Failed'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _adminController.loadPayments(page: 1, status: _selectedStatus);
  }

  void printDocument() async {
    final payments = _adminController.paymentsHistory;
    if (payments.isEmpty) {
      Get.snackbar("Error", "No billing records to print.");
      return;
    }
    final currency = _userController.user.value?.baseCurrence ?? '';
    final pdf = await PdfBillingHistory.generate(
      baseCurrence: currency,
      payments: payments,
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Billing_History_Report',
    );
  }

  void _confirmPoll(String paymentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Poll Payment Status", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "Are you sure you want to ask Paynow to poll this payment?\n\nIf the payment was successful, your subscription will be automatically updated.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _adminController.pollPayment(paymentId);
            },
            child: const Text("Confirm & Poll", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  double _getPlanPrice(String plan) {
    int index = MistSubscriptionUtils.availablePlans.indexOf(plan);
    if (index != -1 && index < MistSubscriptionUtils.planPrices.length) {
      return MistSubscriptionUtils.planPrices[index];
    }
    return 0.0;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return const Color(0xFF10B981); // Emerald green
      case 'pending': return const Color(0xFFF59E0B);   // Amber
      case 'failed': return const Color(0xFFEF4444);    // Red
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Use scaffoldBackgroundColor so it blends perfectly
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      child: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          await _adminController.loadPayments(page: 1, status: _selectedStatus);
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          if (_adminController.paymentsPage.value < _adminController.paymentsTotalPages.value) {
            await _adminController.loadPayments(
              page: _adminController.paymentsPage.value + 1,
              status: _selectedStatus,
            );
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              sliver: SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Current Subscription"),
                        const SizedBox(height: 16),
                        _buildCurrentSubscriptionCard(isDark),
                        const SizedBox(height: 36),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionHeader("Payment History"),
                            _buildFilterDropdown(isDark),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (_adminController.loadingPayments.value) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: MistLoader1()),
                        ),
                      );
                    }

                    final list = _adminController.paymentsHistory;
                    if (list.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor.withAlpha(20),
                                  ),
                                  child: Icon(Icons.receipt_long_rounded, size: 64, color: Theme.of(context).primaryColor.withAlpha(150)),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "No $_selectedStatus payments found.",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final isFirst = index == 0;
                          final isLast = index == list.length - 1;
                          return _buildPaymentItem(list[index], isFirst: isFirst, isLast: isLast, isDark: isDark);
                        },
                        childCount: list.length,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildFilterDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E202C) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withAlpha(isDark ? 30 : 50)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          items: _statuses.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedStatus = val);
              _loadData();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard(bool isDark) {
    final company = _inventoryController.company.value;
    final sub = company?.subscriptionType;
    final planName = MistSubscriptionUtils.getPlanDisplayName(sub?.type ?? 'free');
    final price = _getPlanPrice(sub?.type ?? 'free');
    final baseCurrence = _userController.user.value?.baseCurrence ?? '';
    final formattedPrice = CurrenceConverter.getCurrenceFloatInStrings(price, baseCurrence);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(isDark ? 30 : 40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planName,
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedPrice,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  "/ month",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Next renewal on: ${sub?.validUntil != null ? MistDateUtils.formatNormalDate(sub!.validUntil!) : 'N/A'}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Subscription management is typically handled in settings, but we provide a hook here.
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: BorderSide(color: Colors.grey.withAlpha(isDark ? 80 : 100)),
              ),
              child: Text(
                "Manage Subscription",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(PaymentRequestModel payment, {required bool isFirst, required bool isLast, required bool isDark}) {
    final currency = _userController.user.value?.baseCurrence ?? '';
    final statusColor = _getStatusColor(payment.status);
    final borderColor = Colors.grey.withAlpha(isDark ? 30 : 40);
    
    // Icon Logic based on subscription type
    final plan = payment.subscription.toLowerCase();
    String iconName = Bx.credit_card;
    if (plan.contains('pro')) {
      iconName = Bx.diamond;
    } else if (plan.contains('basic')) {
      iconName = Bxl.paypal;
    } else if (plan.contains('enterprise')) {
      iconName = Bx.buildings;
    } else if (plan.contains('free') || plan.contains('trial')) {
      iconName = Bx.gift;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(16) : Radius.zero,
          topRight: isFirst ? const Radius.circular(16) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        border: Border(
          top: isFirst ? BorderSide(color: borderColor) : BorderSide.none,
          left: BorderSide(color: borderColor),
          right: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2D3E) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Iconify(
                    iconName,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Middle Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${MistDateUtils.formatNormalDate(payment.createdAt)} - ${MistSubscriptionUtils.getPlanDisplayName(payment.subscription)} Payment",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${payment.months} Month",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right side Amount & Status
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "-${CurrenceConverter.getCurrenceFloatInStrings(payment.amount, currency)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(isDark ? 40 : 25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      payment.status == "Completed" ? "Paid" : payment.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Pending Polling Action
          if (payment.status.toLowerCase() == 'pending') ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _confirmPoll(payment.id),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(isDark ? 40 : 20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).primaryColor.withAlpha(100)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync, size: 14, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        "Check Status",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
