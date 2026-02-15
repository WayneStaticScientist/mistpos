import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:mistpos/screens/basic/screen_add_expense.dart'; // Ensure you have get package installed

/// Simple Model for Expense
class Expense {
  final String id;
  final String category;
  final DateTime date;
  final double amount;
  final String reason;

  Expense({
    required this.id,
    required this.category,
    required this.date,
    required this.amount,
    required this.reason,
  });
}

class NavExpenses extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavExpenses({super.key, this.scaffoldKey});

  @override
  State<NavExpenses> createState() => _NavExpensesState();
}

class _NavExpensesState extends State<NavExpenses> {
  // Controllers and State Variables
  final TextEditingController _searchController = TextEditingController();

  // Filters
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  // Dummy Categories
  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Others',
  ];

  // Dummy Data
  final List<Expense> _allExpenses = [
    Expense(
      id: '1',
      category: 'Food',
      date: DateTime.now().subtract(const Duration(days: 1)),
      amount: 25.50,
      reason: 'Lunch with colleagues',
    ),
    Expense(
      id: '2',
      category: 'Transport',
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 12.00,
      reason: 'Uber to work',
    ),
    Expense(
      id: '3',
      category: 'Bills',
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 150.00,
      reason: 'Electricity Bill',
    ),
    Expense(
      id: '4',
      category: 'Shopping',
      date: DateTime.now().subtract(const Duration(days: 10)),
      amount: 89.99,
      reason: 'New Sneakers',
    ),
    Expense(
      id: '5',
      category: 'Food',
      date: DateTime.now(),
      amount: 15.00,
      reason: 'Breakfast',
    ),
  ];

  List<Expense> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _filteredExpenses = _allExpenses;
    _searchController.addListener(_filterExpenses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Logic ---

  void _filterExpenses() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredExpenses = _allExpenses.where((expense) {
        // 1. Search Filter (Reason or Amount)
        final matchesSearch =
            expense.reason.toLowerCase().contains(query) ||
            expense.amount.toString().contains(query);

        // 2. Category Filter
        final matchesCategory =
            _selectedCategory == null || expense.category == _selectedCategory;

        // 3. Date Range Filter
        bool matchesDate = true;
        if (_startDate != null && _endDate != null) {
          // Check if date is within range (inclusive)
          matchesDate =
              expense.date.isAfter(
                _startDate!.subtract(const Duration(days: 1)),
              ) &&
              expense.date.isBefore(_endDate!.add(const Duration(days: 1)));
        }

        return matchesSearch && matchesCategory && matchesDate;
      }).toList();
    });
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
    // Use Get.isDark if Get is available, otherwise fallback to Theme context
    // Assuming Get is installed as per prompt requirements
    bool isDarkMode = false;
    try {
      isDarkMode = Get.isDarkMode;
    } catch (e) {
      isDarkMode = Theme.of(context).brightness == Brightness.dark;
    }

    final primaryColor = Theme.of(context).colorScheme.primary;
    final currencyFormat = NumberFormat.simpleCurrency();
    final dateFormat = DateFormat('MMM dd, yyyy');

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
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search reason or amount...",
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
                    child: DropdownButton<String>(
                      hint: Text(
                        "Category",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      value: _selectedCategory,
                      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                      items: _categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
                              ? "${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}"
                              : "Date Range",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
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

          // 3. Tabular Data
          Expanded(
            child: _filteredExpenses.isEmpty
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
                          isDarkMode ? Colors.grey[900] : Colors.white,
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Category',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Reason',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: _filteredExpenses.map((expense) {
                          return DataRow(
                            cells: [
                              DataCell(Text(dateFormat.format(expense.date))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    expense.category,
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
                                  width: 150, // Limit width for reason
                                  child: Text(
                                    expense.reason,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  currencyFormat.format(expense.amount),
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
  }
}
