import 'dart:developer';

import 'package:get/get.dart';
import 'package:mistpos/models/employee_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/sales_stats_model.dart';
import 'package:mistpos/models/product_stats_model.dart';
import 'package:mistpos/utils/toast.dart';

class AdminController extends GetxController {
  RxBool loading = RxBool(false);
  RxInt totalProducts = RxInt(0);
  Rx<StatsProductModel?> statsPoducts = Rx<StatsProductModel?>(null);
  Rx<StatsSalesModel?> statsSales = Rx<StatsSalesModel?>(null);
  void getAdminStats() async {
    loading.value = true;
    final result = await Net.get("/admin/stats");
    if (result.hasError) {
      loading.value = false;
      return;
    }
    totalProducts.value = result.body['totalProducts'] ?? 0;
    if (result.body['productStats'] != null) {
      statsPoducts.value = StatsProductModel.fromJson(
        result.body['productStats'],
      );
    }
    if (result.body['salesStates'] != null) {
      statsSales.value = StatsSalesModel.fromJson(result.body['salesStates']);
    }

    loading.value = false;
  }

  RxBool loadingEmployess = RxBool(false);
  RxList<EmployeeModel> employees = RxList<EmployeeModel>();
  void fetchEmployees() async {
    if (loadingEmployess.value) return;
    loadingEmployess.value = true;
    final results = await Net.get("/admin/employees");
    if (results.hasError) {
      loadingEmployess.value = false;
      return;
    }
    log("resultss ${results.body}");
    if (results.body['list'] != null) {
      List<dynamic> usersList = results.body['list'];
      employees.assignAll(
        usersList.map((e) => EmployeeModel.fromJson(e)).toList(),
      );
    }
    loadingEmployess.value = false;
  }

  RxBool addingEmployee = RxBool(false);
  Future<bool> addEmployee(Map<String, dynamic> data) async {
    if (addingEmployee.value) {
      Toaster.showError("Adding employee please wait");
      return false;
    }
    ;
    addingEmployee.value = true;
    final result = await Net.post("/admin/employee", data: data);
    addingEmployee.value = false;
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    fetchEmployees();
    return true;
  }

  RxBool updatingEmployee = RxBool(false);
  Future<bool> updateEmployee(Map<String, dynamic> data) async {
    if (addingEmployee.value) {
      Toaster.showError("Adding employee please wait");
      return false;
    }
    updatingEmployee.value = true;
    final result = await Net.put("/admin/employee", data: data);
    updatingEmployee.value = false;
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    fetchEmployees();
    return true;
  }

  Future<bool> deleteEmployee(String id) async {
    if (addingEmployee.value) {
      Toaster.showError("Adding employee please wait");
      return false;
    }
    updatingEmployee.value = true;
    final result = await Net.delete("/admin/employee/$id");
    updatingEmployee.value = false;
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    fetchEmployees();
    return true;
  }
}
