import 'dart:developer';

import 'package:get/get.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/expense_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/expense_category_model.dart';

class ExpensesController extends GetxController {
  RxBool addingExpenses = false.obs;
  RxList<ExpenseCategoryModel> categories = RxList([]);

  RxBool syncingExpenseCategories = RxBool(false);
  void syncExpenseCategories() async {
    syncingExpenseCategories.value = true;
    final response = await Net.get("/expense-categories");
    syncingExpenseCategories.value = false;
    if (response.hasError) {
      return;
    }
    final list = response.body['list'] as List<dynamic>?;
    categories.clear();
    if (list == null) {
      return;
    }
    categories.assignAll(list.map((e) => ExpenseCategoryModel.fromJson(e)));
    log("The len is ${categories.length}}");
  }

  Future<bool> addExpenseCategory(String name) async {
    if (syncingExpenseCategories.value) return false;
    syncingExpenseCategories.value = true;
    final response = await Net.post(
      "/admin/expense-category",
      data: {"label": name},
    );
    syncingExpenseCategories.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    syncExpenseCategories();
    return true;
  }

  Future<bool> addExpense(Map<String, dynamic> expenseData) async {
    if (addingExpenses.value) return false;
    addingExpenses.value = true;
    final response = await Net.post("/admin/expense", data: expenseData);
    addingExpenses.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    fetchExpenses();
    return true;
  }

  RxDouble totalExpenses = 0.0.obs;
  RxBool fetchingExpenses = false.obs;
  RxList<ExpenseModel> expenses = RxList([]);
  RxString fetchingExpensesResponse = ''.obs;
  Future<void> fetchExpenses({
    DateTime? endDate,
    String category = '',
    String search = '',
    DateTime? startDate,
  }) async {
    if (fetchingExpenses.value) return;
    totalExpenses.value = 0.0;
    fetchingExpenses.value = true;
    fetchingExpensesResponse.value = '';
    final response = await Net.get(
      "/expenses?search=$search&endDate=${endDate?.toIso8601String() ?? ''}&startDate=${startDate?.toIso8601String() ?? ''}&category=$category",
    );
    fetchingExpenses.value = false;
    if (response.hasError) {
      fetchingExpensesResponse.value = response.response;
      Toaster.showError(response.response);
      return;
    }
    final list = response.body['list'] as List<dynamic>?;
    expenses.clear();
    if (list == null) {
      return;
    }
    expenses.assignAll(list.map((e) => ExpenseModel.fromJson(e)));
    totalExpenses.value = expenses.fold(
      0.0,
      (previousValue, element) => previousValue + element.amount,
    );
  }

  RxInt totalPaginatedExpenses = 0.obs;
  RxInt paginatedExpensesPage = 1.obs;
  RxBool fetchingPaginatedExpenses = false.obs;
  RxString fetchingPaginatedExpensesResponse = ''.obs;
  RxList<ExpenseModel> paginatedExpenses = RxList([]);
  Future<void> fetchPaginatedExpenses({
    int page = 1,
    String status = '',
    String search = '',
    String category = '',
  }) async {
    if (fetchingPaginatedExpenses.value) return;
    fetchingPaginatedExpenses.value = true;
    fetchingPaginatedExpensesResponse.value = '';
    final response = await Net.get(
      "/expenses-pages?search=$search&page=$page&category=$category&status=$status",
    );
    fetchingPaginatedExpenses.value = false;
    if (response.hasError) {
      fetchingPaginatedExpensesResponse.value = response.response;
      Toaster.showError(response.response);
      return;
    }
    final list = response.body['list'] as List<dynamic>?;
    expenses.clear();
    if (list == null) {
      return;
    }
    if (page == 1) {
      paginatedExpenses.clear();
    }
    paginatedExpenses.addAll(list.map((e) => ExpenseModel.fromJson(e)));
    totalPaginatedExpenses.value = response.body['total'];
    paginatedExpensesPage.value = response.body['page'];
  }
}
