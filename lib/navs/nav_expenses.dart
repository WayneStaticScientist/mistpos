import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/date_utils.dart'; // Ensure you have get package installed
import 'package:mistpos/utils/subscriptions.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/expenses_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/basic/screen_add_expense.dart';
import 'package:mistpos/widgets/layouts/subscription_alert.dart';

class NavExpenses extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavExpenses({super.key, this.scaffoldKey});

  @override
  State<NavExpenses> createState() => _NavExpensesState();
}

class _NavExpensesState extends State<NavExpenses> {
  final _inventory = Get.find<InventoryController>();
  final _expenseController = Get.find<ExpensesController>();
  final TextEditingController _searchController = TextEditingController();

  // Filters
  String? _selectedCategory;
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  // Dummy Categories
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _expenseController.syncExpenseCategories();
    _filterExpenses();
    _initDebounce();
  }

  @override
  dispose() {
    _timer?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  void _initDebounce() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
        _filterExpenses();
      }
    });
  }

  // --- Logic ---

  void _filterExpenses() {
    _expenseController.fetchExpenses(
      search: _searchController.text,
      category: _selectedCategory ?? '',
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _filterExpenses();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _startDate = null;
      _endDate = null;
    });
    _filterExpenses();
  }

  // --- UI Building Blocks ---

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    try {
      isDarkMode = Get.isDarkMode;
    } catch (e) {
      isDarkMode = Theme.of(context).brightness == Brightness.dark;
    }

    final primaryColor = Theme.of(context).colorScheme.primary;

    return Obx(() {
      if (_inventory.company.value == null ||
          MistDateUtils.getDaysDifference(
                _inventory.company.value!.subscriptionType.validUntil!,
              ) <
              0 ||
          !(MistSubscriptionUtils.basicList.contains(
            _inventory.company.value!.subscriptionType.type,
          ))) {
        return SubscriptionAlert();
      }
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[50],
        appBar: AppBar(
          leading: DrawerButton(
            onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
          ),
          title: const Text("Expenses"),
          centerTitle: true,
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          elevation: 0,
          actions: [
            Obx(
              () => _expenseController.fetchingExpenses.value
                  ? CircularProgressIndicator(color: primaryColor)
                  : CurrenceConverter.selectedCurrencyInString(
                          _expenseController.totalExpenses.value,
                        )
                        .text(
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .padding(
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. Search Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search reason or reference or notes...",
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                ),
              ),
            ),

            // 2. Filters Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  // Category Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withAlpha(90)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton<String>(
                          hint: Text(
                            "Category",
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          value: _selectedCategory,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                          ),
                          items: _expenseController.categories.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: value.label.text(),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                            _filterExpenses();
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Date Range Button
                  InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withAlpha(90)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _startDate != null && _endDate != null
                                ? "${MistDateUtils.getInformalShortDate(_startDate!)} - ${MistDateUtils.getInformalShortDate(_endDate!)}"
                                : "Today's Expenses",
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Clear Filter Button
                  if (_selectedCategory != null || _startDate != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                      onPressed: _clearFilters,
                      tooltip: "Clear Filters",
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Obx(
              () => _expenseController.fetchingExpenses.value
                  ? MistLoader1().center()
                  : Expanded(
                      child: _expenseController.expenses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No expenses found",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    primaryColor.withAlpha(30),
                                  ),
                                  dataRowColor: WidgetStateProperty.all(
                                    isDarkMode
                                        ? Colors.grey[900]
                                        : Colors.white,
                                  ),
                                  columnSpacing: 20,
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                      width: 1,
                                      color: Colors.white.withAlpha(30),
                                    ),
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Reason',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: _expenseController.expenses.map((
                                    expense,
                                  ) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            MistDateUtils.getInformalShortDate(
                                              expense.date,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withAlpha(30),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              expense.category['label'],
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width:
                                                150, // Limit width for reason
                                            child: Text(
                                              expense.expenseFor,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            CurrenceConverter.selectedCurrencyInString(
                                              expense.amount,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ),
            ),
            // 3. Tabular Data
          ],
        ),

        // 4. Bottom Bar for Adding Expense
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(27),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: () => Get.to(() => AddExpenseScreen()),
              icon: const Icon(Icons.add),
              label: const Text("ADD NEW EXPENSE"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white, // Text/Icon color
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ),
      );
    });
  }
}
