import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/employee_model.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/models/dialy_sale_model.dart';
import 'package:mistpos/models/sales_by_payment.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/shifts_stats_model.dart';
import 'package:mistpos/models/sales_stats_model.dart';
import 'package:mistpos/models/product_stats_model.dart';
import 'package:mistpos/models/average_profit_model.dart';
import 'package:mistpos/models/sales_by_employee_model.dart';

class AdminController extends GetxController {
  RxBool loading = RxBool(false);
  RxInt totalProducts = RxInt(0);
  Rx<StatsProductModel?> statsPoducts = Rx<StatsProductModel?>(null);
  Rx<StatsSalesModel?> statsSales = Rx<StatsSalesModel?>(null);
  void getAdminStats({DateTime? startDate, DateTime? endDate}) async {
    loading.value = true;
    final date = DateTime.now();
    if (endDate == null ||
        (endDate.day == date.day &&
            endDate.month == date.month &&
            endDate.year == date.year)) {
      endDate = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    }
    final result = await Net.get(
      "/admin/stats?startDate=${startDate?.toIso8601String() ?? ''}&endDate=${endDate.toIso8601String()}",
    );
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

  RxBool loadingWeeklyProfits = RxBool(false);
  RxString weeklyProfitsFailed = RxString("");
  RxList<AverageProfitModel> weeklyProfits = RxList<AverageProfitModel>([]);
  void getWeeklyProfits({DateTime? endDate}) async {
    if (loadingWeeklyProfits.value) return;
    endDate ??= DateTime.now();
    loadingWeeklyProfits.value = true;
    weeklyProfitsFailed.value = "";
    final reponse = await Net.get(
      "/admin/stats/daily?endDate=${endDate.toIso8601String()}",
    );
    loadingWeeklyProfits.value = false;
    if (reponse.hasError) {
      weeklyProfitsFailed.value = reponse.response;
      return;
    }
    if (reponse.body['list'] != null) {
      List<dynamic> list = reponse.body['list'];
      weeklyProfits.value = list
          .map((e) => AverageProfitModel.fromJson(e))
          .toList();
    }
  }

  Future<bool> addCompany(Map<String, dynamic> data) async {
    final result = await Net.post("/admin/company", data: data);
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    loadCompanies();
    return true;
  }

  RxBool loadingCompanies = RxBool(false);
  RxList<CompanyModel> companies = RxList<CompanyModel>();
  Future<void> loadCompanies({int page = 1, String search = ''}) async {
    if (loadingCompanies.value) return;
    loadingCompanies.value = true;
    final result = await Net.get("/admin/companies?page=$page&search=$search");
    loadingCompanies.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      List<dynamic> list = result.body['list'];
      companies.value = list.map((e) => CompanyModel.fromJson(e)).toList();
    }
  }

  Future<bool> deleteCompany(String id) async {
    final result = await Net.delete("/admin/company/$id");
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    loadCompanies();
    return true;
  }

  RxBool companyLoading = RxBool(false);
  Future<bool> updateCompany(Map<String, dynamic> data, String id) async {
    if (companyLoading.value) return false;
    companyLoading.value = true;
    final result = await Net.put("/admin/company/$id", data: data);
    companyLoading.value = false;
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    loadCompanies();
    return true;
  }

  RxBool loadingDailySales = RxBool(false);
  RxList<DialySaleModel> dailySales = RxList<DialySaleModel>();
  Future<void> getDailySales(DateTime date, DateTime? timeStart) async {
    if (loadingDailySales.value) return;
    loadingDailySales.value = true;
    final result = await Net.get(
      "/admin/stats/sales/daily?date=${date.toIso8601String()}&startDate=${timeStart?.toIso8601String() ?? ''}",
    );
    loadingDailySales.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      List<dynamic> list = result.body['list'];
      dailySales.value = list.map((e) => DialySaleModel.fromJson(e)).toList();
    }
  }

  RxBool loadingSalesByEmployee = RxBool(false);
  RxList<SalesByEmployeeModel> salesByEmployee = RxList<SalesByEmployeeModel>();
  Future<void> getSalesByEmployee(DateTime start, DateTime end) async {
    if (loadingSalesByEmployee.value) return;
    loadingSalesByEmployee.value = true;
    final result = await Net.get(
      "/admin/stats/sales/employee?endDate=${end.toIso8601String()}&startDate=${start.toIso8601String()}",
    );
    loadingSalesByEmployee.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      List<dynamic> list = result.body['list'];
      salesByEmployee.value = list
          .map((e) => SalesByEmployeeModel.fromJson(e))
          .toList();
    }
  }

  RxBool loadingSalesByPayment = RxBool(false);
  RxList<SalesByPayment> salesByPayment = RxList<SalesByPayment>();
  Future<void> getSalesPayment(DateTime start, DateTime end) async {
    if (loadingSalesByPayment.value) return;
    loadingSalesByPayment.value = true;
    final result = await Net.get(
      "/admin/stats/sales/payments?endDate=${end.toIso8601String()}&startDate=${start.toIso8601String()}",
    );
    loadingSalesByPayment.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      List<dynamic> list = result.body['list'];
      salesByPayment.value = list
          .map((e) => SalesByPayment.fromJson(e))
          .toList();
    }
  }

  RxBool loadingShifts = RxBool(false);
  RxList<ShiftsStatsModel> shiftsStats = RxList<ShiftsStatsModel>();
  Future<void> getShifts(DateTime start, DateTime end) async {
    if (loadingShifts.value) return;
    loadingShifts.value = true;
    final result = await Net.get(
      "/admin/stats/sales/shifts?endDate=${end.toIso8601String()}&startDate=${start.toIso8601String()}",
    );
    loadingShifts.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      List<dynamic> list = result.body['list'];
      shiftsStats.value = list
          .map((e) => ShiftsStatsModel.fromJson(e))
          .toList();
    }
  }

  RxBool settingUpKeys = RxBool(false);
  Future<User?> setupPaynowKeys({
    required String integrationId,
    required String integrationKey,
  }) async {
    if (settingUpKeys.value) {
      Toaster.showError("already setting up keys");
      return null;
    }
    settingUpKeys.value = true;
    final result = await Net.post(
      "/admin/paynow/keys",
      data: {"integrationId": integrationId, "integrationKey": integrationKey},
    );
    settingUpKeys.value = false;
    if (result.hasError) {
      Toaster.showError(result.response);
      return null;
    }
    return User.fromMap(result.body['update']);
  }

  void openFile(Uint8List fileBytes) async {
    try {
      if (fileBytes.isEmpty) {
        Toaster.showError("PDF generation failed: No bytes returned.");
        return;
      }
      DateTime now = DateTime.now();
      final String? selectedDirectory = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF Report',
        fileName:
            'document-${now.day}-${now.month}-${now.year}.pdf', // Suggest a file name
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: fileBytes,
      );
      if (selectedDirectory == null) {
        Toaster.showError("PDF save cancelled by user.");
        return;
      }
      Toaster.showSuccess("PDF saved successfully to: $selectedDirectory");
      OpenFile.open(selectedDirectory);
    } catch (e) {
      Toaster.showError("There was error : $e");
    }
  }
}
