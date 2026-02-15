import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart'; // Ensure you have get package installed
import 'package:mistpos/controllers/expenses_controller.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _expenseController = Get.find<ExpensesController>();
  // Text Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _expenseForController =
      TextEditingController(); // "Reason" or "Payee"
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _newCategoryController =
      TextEditingController(); // For adding new categories

  // State Variables
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String _paymentType = 'Cash';

  // Lists
  final List<String> _paymentTypes = ['Cash', 'Bank', 'Others'];
  // Mutable list to simulate "categories that can be added later"
  @override
  void initState() {
    super.initState();
    _expenseController.syncExpenseCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _expenseForController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addNewCategoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Category"),
        content: TextField(
          controller: _newCategoryController,
          decoration: const InputDecoration(hintText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newCategoryController.text.isNotEmpty) {
                Get.back();
                _expenseController.addExpenseCategory(
                  _newCategoryController.text.trim(),
                );
                _newCategoryController.clear();
                return;
              }
              Toaster.showError("Please enter a category name");
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      // Logic to save expense would go here
      // For now, we just go back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense Added Successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    try {
      isDarkMode = Get.isDarkMode;
    } catch (e) {
      isDarkMode = Theme.of(context).brightness == Brightness.dark;
    }

    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[50],
      appBar: AppBar(
        title: const Text("Add New Expense"),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Date Selection
                InkWell(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withAlpha(100)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          MistDateUtils.formatNormalDate(_selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    prefixText: "\$ ",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 3. Category Row (Dropdown + Add Button)
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: "Category",
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.category,
                              color: primaryColor,
                            ),
                          ),
                          items: _expenseController.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.label),
                            );
                          }).toList(),
                          onChanged: (newValue) =>
                              setState(() => _selectedCategory = newValue),
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _addNewCategoryDialog,
                      child: Obx(
                        () => _expenseController.syncingExpenseCategories.value
                            ? MistLoader1()
                            : Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: primaryColor),
                                ),
                                child: Icon(Icons.add, color: primaryColor),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 4. Expense For
                TextFormField(
                  controller: _expenseForController,
                  decoration: InputDecoration(
                    labelText: "Expense For (Payee/Reason)",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter what this expense is for'
                      : null,
                ),
                const SizedBox(height: 20),

                // 5. Payment Type
                DropdownButtonFormField<String>(
                  initialValue: _paymentType,
                  decoration: InputDecoration(
                    labelText: "Payment Type",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.payment, color: primaryColor),
                  ),
                  items: _paymentTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _paymentType = newValue);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // 6. Reference Number
                TextFormField(
                  controller: _referenceController,
                  decoration: InputDecoration(
                    labelText: "Reference Number (Optional)",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.tag, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 20),

                // 7. Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Notes",
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 40,
                      ), // Align icon to top
                      child: Icon(Icons.note, color: primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "SAVE TRANSACTION",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
