import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:printing/printing.dart';
import 'package:mistpos/core/utils/pdfdocuments/pdf_reseller_report.dart';

class ScreenResellerDashboard extends StatefulWidget {
  const ScreenResellerDashboard({super.key});

  @override
  State<ScreenResellerDashboard> createState() => _ScreenResellerDashboardState();
}

class _ScreenResellerDashboardState extends State<ScreenResellerDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Companies Search & Pagination
  final _searchController = TextEditingController();
  List<dynamic> _companies = [];
  bool _isLoadingCompanies = false;
  int _companiesPage = 1;

  // Payments Filters & Pagination
  List<dynamic> _payments = [];
  bool _isLoadingPayments = false;
  int _paymentsPage = 1;
  String _selectedPlanFilter = "All"; // All, basic, pro, enterprise
  String _selectedStatusFilter = "All"; // All, pending, completed, failed

  // Stats
  double _totalPayments = 0.0;
  double _monthPayments = 0.0;
  double _yearPayments = 0.0;
  int _totalCompanies = 0;
  int _activeToday = 0;
  int _active30Days = 0;
  List<dynamic> _monthlyBreakdown = [
    { "month": "January", "amount": 0.0, "count": 0 },
    { "month": "February", "amount": 0.0, "count": 0 },
    { "month": "March", "amount": 0.0, "count": 0 },
    { "month": "April", "amount": 0.0, "count": 0 },
    { "month": "May", "amount": 0.0, "count": 0 },
    { "month": "June", "amount": 0.0, "count": 0 },
    { "month": "July", "amount": 0.0, "count": 0 },
    { "month": "August", "amount": 0.0, "count": 0 },
    { "month": "September", "amount": 0.0, "count": 0 },
    { "month": "October", "amount": 0.0, "count": 0 },
    { "month": "November", "amount": 0.0, "count": 0 },
    { "month": "December", "amount": 0.0, "count": 0 },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _fetchStats();
    _fetchCompanies();
    _fetchPayments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    try {
      final response = await Net.get("/admin/reseller/stats");
      if (!response.hasError && response.body != null) {
        setState(() {
          _totalPayments = (response.body['totalPayments'] ?? 0).toDouble();
          _monthPayments = (response.body['monthPayments'] ?? 0).toDouble();
          _yearPayments = (response.body['yearPayments'] ?? 0).toDouble();
          _totalCompanies = response.body['totalCompanies'] ?? 0;
          _activeToday = response.body['activeToday'] ?? 0;
          _active30Days = response.body['active30Days'] ?? 0;
          if (response.body['monthlyBreakdown'] != null) {
            _monthlyBreakdown = response.body['monthlyBreakdown'];
          }
        });
      }
    } catch (e) {
      // Keep state at 0
    }
  }

  Future<void> _fetchCompanies({bool isLoadMore = false}) async {
    if (_isLoadingCompanies) return;
    setState(() => _isLoadingCompanies = true);

    try {
      final response = await Net.get(
        "/admin/reseller/companies?page=$_companiesPage&search=${_searchController.text.trim()}",
      );

      if (!response.hasError && response.body != null) {
        final List<dynamic> fetched = response.body['data'] ?? [];
        setState(() {
          if (isLoadMore) {
            _companies.addAll(fetched);
          } else {
            _companies = fetched;
          }
        });
      }
    } catch (e) {
      // Fallback for UI visualization
    } finally {
      setState(() => _isLoadingCompanies = false);
    }
  }

  Future<void> _fetchPayments({bool isLoadMore = false}) async {
    if (_isLoadingPayments) return;
    setState(() => _isLoadingPayments = true);

    try {
      final response = await Net.get(
        "/admin/reseller/payments?page=$_paymentsPage&plan=${_selectedPlanFilter.toLowerCase()}&status=${_selectedStatusFilter.toLowerCase()}",
      );

      if (!response.hasError && response.body != null) {
        final List<dynamic> fetched = response.body['data'] ?? [];
        setState(() {
          if (isLoadMore) {
            _payments.addAll(fetched);
          } else {
            _payments = fetched;
          }
        });
      }
    } catch (e) {
      // Fallback for UI visualization
    } finally {
      setState(() => _isLoadingPayments = false);
    }
  }
  void _printReport() async {
    if (_tabController.index == 0) {
      if (_companies.isEmpty) {
        Get.snackbar("Info", "No merchants to print");
        return;
      }
      try {
        final pdf = await PdfResellerReport.generateMerchantsReport(companies: _companies);
        await Printing.layoutPdf(
          onLayout: (format) async => pdf.save(),
          name: 'Referred_Merchants_Report',
        );
      } catch (e) {
        Get.snackbar("Error", "Could not generate PDF: $e");
      }
    } else if (_tabController.index == 2) {
      try {
        final pdf = await PdfResellerReport.generateMonthlyReport(monthlyBreakdown: _monthlyBreakdown);
        await Printing.layoutPdf(
          onLayout: (format) async => pdf.save(),
          name: 'Monthly_Earnings_Report',
        );
      } catch (e) {
        Get.snackbar("Error", "Could not generate PDF: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Reseller Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black.withOpacity(0.87)),
        actions: [
          if (_tabController.index == 0 || _tabController.index == 2)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded),
              tooltip: "Print Report",
              onPressed: _printReport,
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: isDark ? Colors.white : Colors.black.withOpacity(0.87),
              unselectedLabelColor: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              tabs: const [
                Tab(
                  child: Text(
                    "Merchants",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Tab(
                  child: Text(
                    "Payments",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Tab(
                  child: Text(
                    "Monthly",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCompaniesTab(isDark, primary),
          _buildPaymentsTab(isDark, primary),
          _buildMonthlySummaryTab(isDark, primary),
        ],
      ),
    );
  }

  Widget _buildCompaniesTab(bool isDark, Color primary) {
    final companiesCount = _companies.length;

    return _isLoadingCompanies && _companies.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 2 + companiesCount + (companiesCount > 0 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _buildDashboardCard(
                        title: "Total Earned",
                        value: "\$${_totalPayments.toStringAsFixed(2)}",
                        icon: Icons.account_balance_wallet_rounded,
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: "This Month",
                        value: "\$${_monthPayments.toStringAsFixed(2)}",
                        icon: Icons.trending_up_rounded,
                        color: Colors.blueAccent,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: "This Year",
                        value: "\$${_yearPayments.toStringAsFixed(2)}",
                        icon: Icons.calendar_today_rounded,
                        color: Colors.amber,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: "Total Companies",
                        value: "$_totalCompanies",
                        icon: Icons.business_rounded,
                        color: Colors.indigoAccent,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: "Active Today",
                        value: "$_activeToday",
                        icon: Icons.check_circle_outline_rounded,
                        color: Colors.teal,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: "Active 30 Days",
                        value: "$_active30Days",
                        icon: Icons.insights_rounded,
                        color: Colors.deepPurpleAccent,
                        isDark: isDark,
                      ),
                    ],
                  ),
                );
              } else if (index == 1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (_) {
                          _companiesPage = 1;
                          _fetchCompanies();
                        },
                        decoration: InputDecoration(
                          hintText: "Search referred companies...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "REFERRED COMPANIES",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.45),
                        ),
                      ),
                    ),
                    if (companiesCount == 0 && !_isLoadingCompanies)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Iconify(Bx.store_alt, size: 64, color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2)),
                              const SizedBox(height: 16),
                              Text("No referred companies found", style: TextStyle(color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }

              final companyIndex = index - 2;
              if (companyIndex < companiesCount) {
                final company = _companies[companyIndex];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Iconify(Bx.store, color: primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company['name'] ?? 'Unknown Company',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black.withOpacity(0.87)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Plan: ${company['paymentPlan'] ?? 'Free'} • Subscribed: ${company['createdAt'] != null ? company['createdAt'].toString().substring(0, 10) : 'N/A'}",
                                style: TextStyle(fontSize: 12, color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      _companiesPage++;
                      _fetchCompanies(isLoadMore: true);
                    },
                    child: const Text("Load More"),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab(bool isDark, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filters
        Container(
          width: double.infinity,
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text("Plan: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7))),
                    const SizedBox(width: 8),
                    _buildFilterChip("All", _selectedPlanFilter, (v) {
                      setState(() { _selectedPlanFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                    _buildFilterChip("Basic", _selectedPlanFilter, (v) {
                      setState(() { _selectedPlanFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                    _buildFilterChip("Pro", _selectedPlanFilter, (v) {
                      setState(() { _selectedPlanFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                    _buildFilterChip("Enterprise", _selectedPlanFilter, (v) {
                      setState(() { _selectedPlanFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text("Status: ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7))),
                    const SizedBox(width: 8),
                    _buildFilterChip("All", _selectedStatusFilter, (v) {
                      setState(() { _selectedStatusFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                    _buildFilterChip("Completed", _selectedStatusFilter, (v) {
                      setState(() { _selectedStatusFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                    _buildFilterChip("Pending", _selectedStatusFilter, (v) {
                      setState(() { _selectedStatusFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                    _buildFilterChip("Failed", _selectedStatusFilter, (v) {
                      setState(() { _selectedStatusFilter = v; _paymentsPage = 1; });
                      _fetchPayments();
                    }, isDark, primary),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Payments List
        Expanded(
          child: _isLoadingPayments && _payments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _payments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Iconify(Bx.receipt, size: 64, color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          Text("No payment records found", style: TextStyle(color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5))),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: _payments.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _payments.length) {
                          return TextButton(
                            onPressed: () {
                              _paymentsPage++;
                              _fetchPayments(isLoadMore: true);
                            },
                            child: const Text("Load More"),
                          );
                        }

                        final payment = _payments[index];
                        final status = (payment['status'] ?? 'pending').toString().toLowerCase();
                        Color statusColor = Colors.amber;
                        if (status == 'completed') statusColor = const Color(0xFF10B981);
                        if (status == 'failed') statusColor = Colors.redAccent;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Iconify(
                                  status == 'completed' ? Bx.check : status == 'failed' ? Bx.x : Bx.time,
                                  color: statusColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      payment['companyName'] ?? 'Unknown Company',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black.withOpacity(0.87)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${payment['plan']?.toString().toUpperCase() ?? 'N/A'} • ${payment['date'] != null ? payment['date'].toString().substring(0, 10) : ''}",
                                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$${payment['commission']?.toString() ?? '0.00'}",
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: isDark ? Colors.white : Colors.black.withOpacity(0.87)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    status.toUpperCase(),
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, Function(String) onSelected, bool isDark, Color primary) {
    final isSelected = selectedValue == label;
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primary : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : (isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlySummaryTab(bool isDark, Color primary) {
    final currentYear = DateTime.now().year;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _monthlyBreakdown.length,
      itemBuilder: (context, index) {
        final item = _monthlyBreakdown[index];
        final amount = (item['amount'] ?? 0.0).toDouble();
        final count = item['count'] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item['month']} $currentYear",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black.withOpacity(0.87),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$count transactions",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: amount > 0 ? const Color(0xFF10B981) : (isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
