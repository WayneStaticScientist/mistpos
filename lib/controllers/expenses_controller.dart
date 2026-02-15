import 'dart:developer';

import 'package:get/get.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/expense_category_model.dart';

class ExpensesController extends GetxController {
  RxBool addingExpenses = false.obs;
  RxList<ExpenseCategoryModel> categories = RxList([]);

  RxBool syncingExpenseCategories = RxBool(false);
  void syncExpenseCategories() async {
    syncingExpenseCategories.value = true;
    final response = await Net.get("/expense-categories");
    log("response is ${response.body}");
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

  void addExpense(Map<String, dynamic> expenseData) async {
    addingExpenses.value = true;
    final response = await Net.post("/admin/expense");
    addingExpenses.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
  }
}
