import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:mistpos/data/models/shifts_model.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/data/models/employee_model.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/data/models/dialy_sale_model.dart';
import 'package:mistpos/data/models/sales_by_payment.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/data/models/shifts_stats_model.dart';
import 'package:mistpos/data/models/sales_stats_model.dart';
import 'package:mistpos/data/models/product_stats_model.dart';
import 'package:mistpos/data/models/average_profit_model.dart';
import 'package:mistpos/data/models/sales_by_employee_model.dart';
import 'package:mistpos/data/models/payment_request_model.dart';
import 'package:mistpos/data/models/this_month_summary_model.dart';
import 'package:mistpos/data/models/monthly_report_model.dart';
import 'package:mistpos/data/models/yearly_report_model.dart';
import 'package:mistpos/data/models/expense_analytics_model.dart';
import 'package:mistpos/data/models/product_analytics_model.dart';

class AdminController extends GetxController {
  RxBool loading = RxBool(false);
  RxInt totalProducts = RxInt(0);
  Rx<StatsProductModel?> statsPoducts = Rx<StatsProductModel?>(null);
  Rx<StatsSalesModel?> statsSales = Rx<StatsSalesModel?>(null);
  Rx<ThisMonthSummaryModel?> thisMonthSummary = Rx<ThisMonthSummaryModel?>(
    null,
  );
  void getAdminStats({DateTime? startDate, DateTime? endDate}) async {
    loading.value = true;
    DateTime? cleanStart;
    DateTime? cleanEnd;
    if (startDate != null) {
      cleanStart = DateTime.utc(startDate.year, startDate.month, startDate.day);
    }
    if (endDate != null) {
      cleanEnd = DateTime.utc(
        endDate.year,
        endDate.month,
        endDate.day,
        23, // Hour: 11 PM
        59, // Minute: 59
        59, // Second: 59
        999, // Millisecond: 999
      );
    }

    // 2. Do the exact same for the end date.
    // We keep the exact hours/minutes/seconds you passed in, but wrap it as UTC
    // so the Node backend doesn't shift it.

    final result = await Net.get(
      "/admin/stats?startDate=${cleanStart?.toIso8601String() ?? ''}&endDate=${cleanEnd?.toIso8601String() ?? ''}",
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
    if (result.body['thisMonthSummary'] != null) {
      thisMonthSummary.value = ThisMonthSummaryModel.fromJson(
        result.body['thisMonthSummary'],
      );
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
  void getWeeklyProfits({DateTime? endDate, String period = 'weekly'}) async {
    if (loadingWeeklyProfits.value) return;
    endDate ??= DateTime.now();
    loadingWeeklyProfits.value = true;
    weeklyProfitsFailed.value = "";
    DateTime cleanEnd = DateTime.utc(
      endDate.year,
      endDate.month,
      endDate.day,
      23, // Hour: 11 PM
      59, // Minute: 59
      59, // Second: 59
      999, // Millisecond: 999
    );
    final reponse = await Net.get(
      "/admin/stats/daily?endDate=${cleanEnd.toIso8601String()}&period=$period",
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
  Rx<DailySalesSummary?> dailySalesSummary = Rx<DailySalesSummary?>(null);
  Future<void> getDailySales(DateTime date, DateTime timeStart) async {
    if (loadingDailySales.value) return;
    loadingDailySales.value = true;
    final cleanStart = DateTime.utc(
      timeStart.year,
      timeStart.month,
      timeStart.day,
    );

    // 2. Do the exact same for the end date.
    // We keep the exact hours/minutes/seconds you passed in, but wrap it as UTC
    // so the Node backend doesn't shift it.
    final cleanEnd = DateTime.utc(
      date.year,
      date.month,
      date.day,
      23, // Hour: 11 PM
      59, // Minute: 59
      59, // Second: 59
      999, // Millisecond: 999
    );
    final result = await Net.get(
      "/admin/stats/sales/daily?date=${cleanEnd.toIso8601String()}&startDate=${cleanStart.toIso8601String()}",
    );
    loadingDailySales.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      dailySalesSummary.value = DailySalesSummary.fromJson(result.body['list']);
    }
  }

  RxBool loadingSalesByEmployee = RxBool(false);
  RxList<SalesByEmployeeModel> salesByEmployee = RxList<SalesByEmployeeModel>();
  Future<void> getSalesByEmployee(DateTime timeStart, DateTime date) async {
    if (loadingSalesByEmployee.value) return;
    loadingSalesByEmployee.value = true;
    final cleanStart = DateTime.utc(
      timeStart.year,
      timeStart.month,
      timeStart.day,
    );

    // 2. Do the exact same for the end date.
    // We keep the exact hours/minutes/seconds you passed in, but wrap it as UTC
    // so the Node backend doesn't shift it.
    final cleanEnd = DateTime.utc(
      date.year,
      date.month,
      date.day,
      23, // Hour: 11 PM
      59, // Minute: 59
      59, // Second: 59
      999, // Millisecond: 999
    );
    final result = await Net.get(
      "/admin/stats/sales/employee?endDate=${cleanEnd.toIso8601String()}&startDate=${cleanStart.toIso8601String()}",
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
  Future<void> getSalesPayment(DateTime timeStart, DateTime date) async {
    if (loadingSalesByPayment.value) return;
    loadingSalesByPayment.value = true;
    final cleanStart = DateTime.utc(
      timeStart.year,
      timeStart.month,
      timeStart.day,
    );

    // 2. Do the exact same for the end date.
    // We keep the exact hours/minutes/seconds you passed in, but wrap it as UTC
    // so the Node backend doesn't shift it.
    final cleanEnd = DateTime.utc(
      date.year,
      date.month,
      date.day,
      23, // Hour: 11 PM
      59, // Minute: 59
      59, // Second: 59
      999, // Millisecond: 999
    );
    final result = await Net.get(
      "/admin/stats/sales/payments?endDate=${cleanEnd.toIso8601String()}&startDate=${cleanStart.toIso8601String()}",
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
  Future<void> getShifts(DateTime timeStart, DateTime date) async {
    if (loadingShifts.value) return;
    loadingShifts.value = true;
    final cleanStart = DateTime.utc(
      timeStart.year,
      timeStart.month,
      timeStart.day,
    );

    // 2. Do the exact same for the end date.
    // We keep the exact hours/minutes/seconds you passed in, but wrap it as UTC
    // so the Node backend doesn't shift it.
    final cleanEnd = DateTime.utc(
      date.year,
      date.month,
      date.day,
      23, // Hour: 11 PM
      59, // Minute: 59
      59, // Second: 59
      999, // Millisecond: 999
    );
    final result = await Net.get(
      "/admin/stats/sales/shifts?endDate=${cleanEnd.toIso8601String()}&startDate=${cleanStart.toIso8601String()}",
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

  RxBool loadingAllShifts = RxBool(false);
  RxList<ShiftsModel> allShifts = RxList<ShiftsModel>();
  RxInt allShiftsPage = RxInt(1);
  RxInt allShiftsTotalPages = RxInt(1);
  RxInt allShiftsTotalItems = RxInt(0);

  Future<void> loadAllShifts({int page = 1}) async {
    if (loadingAllShifts.value) return;
    loadingAllShifts.value = true;
    final result = await Net.get("/admin/shifts?page=$page&limit=15");
    loadingAllShifts.value = false;
    if (result.hasError) {
      Toaster.showError("Failed to load shifts log: ${result.response}");
      return;
    }
    if (result.body['shifts'] != null) {
      List<dynamic> list = result.body['shifts'];
      if (page == 1) {
        allShifts.assignAll(list.map((e) => ShiftsModel.fromJson(e)).toList());
      } else {
        allShifts.addAll(list.map((e) => ShiftsModel.fromJson(e)).toList());
      }
      allShiftsPage.value = result.body['pagination']['page'] ?? 1;
      allShiftsTotalPages.value = result.body['pagination']['pages'] ?? 1;
      allShiftsTotalItems.value = result.body['pagination']['total'] ?? 0;
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

  // ── BILLING HISTORY ──
  RxBool loadingPayments = RxBool(false);
  RxList<PaymentRequestModel> paymentsHistory = RxList<PaymentRequestModel>();
  RxInt paymentsTotalPages = RxInt(1);
  RxInt paymentsPage = RxInt(1);

  Future<void> loadPayments({int page = 1, String status = 'All'}) async {
    if (page == 1) {
      loadingPayments.value = true;
      paymentsHistory.clear();
    }

    final result = await Net.get(
      "/admin/payments?page=$page&limit=20&status=$status",
    );
    if (result.hasError) {
      if (page == 1) loadingPayments.value = false;
      Toaster.showError(result.response);
      return;
    }

    final data = result.body['list'] as List;
    final parsed = data.map((e) => PaymentRequestModel.fromJson(e)).toList();

    if (page == 1) {
      paymentsHistory.assignAll(parsed);
    } else {
      paymentsHistory.addAll(parsed);
    }

    paymentsPage.value = result.body['pagination']['currentPage'];
    paymentsTotalPages.value = result.body['pagination']['totalPages'];
    if (page == 1) loadingPayments.value = false;
  }

  Future<void> pollPayment(String paymentId) async {
    final result = await Net.post(
      "/admin/subscribe/paymobile/poll",
      data: {"pollId": paymentId},
    );

    if (result.hasError) {
      Toaster.showError(result.response);
      return;
    }

    Toaster.showSuccess("Payment checked successfully!");
    // Refresh the list to reflect status changes
    loadPayments(page: 1, status: 'All');
  }

  // ── PRODUCT ANALYTICS ──

  // Top 10 sellers
  RxBool loadingTopSellers = RxBool(false);
  RxList<TopSellerProduct> topSellers = RxList<TopSellerProduct>([]);
  RxString topSellerPeriod = RxString('month');

  Future<void> fetchTopSellers({String period = 'month'}) async {
    if (loadingTopSellers.value) return;
    loadingTopSellers.value = true;
    topSellerPeriod.value = period;
    final result = await Net.get('/admin/stats/products/top-sellers?period=$period');
    loadingTopSellers.value = false;
    if (result.hasError) return;
    if (result.body['list'] != null) {
      final List<dynamic> list = result.body['list'];
      topSellers.value = list.map((e) => TopSellerProduct.fromJson(e)).toList();
    }
  }

  // Low sellers
  RxBool loadingLowSellers = RxBool(false);
  RxList<LowSellerProduct> lowSellers = RxList<LowSellerProduct>([]);
  RxInt lowSellersPage = RxInt(1);
  RxInt lowSellersTotalPages = RxInt(1);
  RxInt lowSellersTotal = RxInt(0);

  Future<void> fetchLowSellers({int page = 1}) async {
    if (loadingLowSellers.value) return;
    loadingLowSellers.value = true;
    final result = await Net.get('/admin/stats/products/low-sellers?page=$page&limit=15');
    loadingLowSellers.value = false;
    if (result.hasError) return;
    if (result.body['list'] != null) {
      final List<dynamic> list = result.body['list'];
      lowSellers.value = list.map((e) => LowSellerProduct.fromJson(e)).toList();
      lowSellersPage.value = result.body['currentPage'] ?? 1;
      lowSellersTotalPages.value = result.body['totalPages'] ?? 1;
      lowSellersTotal.value = result.body['total'] ?? 0;
    }
  }

  // Unsold products
  RxBool loadingUnsold = RxBool(false);
  RxList<UnsoldProduct> unsoldProducts = RxList<UnsoldProduct>([]);
  RxInt unsoldPage = RxInt(1);
  RxInt unsoldTotalPages = RxInt(1);
  RxInt unsoldTotal = RxInt(0);

  Future<void> fetchUnsoldProducts({int page = 1}) async {
    if (loadingUnsold.value) return;
    loadingUnsold.value = true;
    final result = await Net.get('/admin/stats/products/unsold?page=$page&limit=15');
    loadingUnsold.value = false;
    if (result.hasError) return;
    if (result.body['list'] != null) {
      final List<dynamic> list = result.body['list'];
      unsoldProducts.value = list.map((e) => UnsoldProduct.fromJson(e)).toList();
      unsoldPage.value = result.body['currentPage'] ?? 1;
      unsoldTotalPages.value = result.body['totalPages'] ?? 1;
      unsoldTotal.value = result.body['total'] ?? 0;
    }
  }

  // Per-product breakdown
  RxBool loadingBreakdown = RxBool(false);
  RxList<ProductSalesTrend> productBreakdown = RxList<ProductSalesTrend>([]);
  RxList<ProductPieSlice> productPieSlices = RxList<ProductPieSlice>([]);

  Future<void> fetchProductBreakdown({
    required String productId,
    String period = 'daily',
  }) async {
    if (loadingBreakdown.value) return;
    loadingBreakdown.value = true;
    productBreakdown.clear();
    productPieSlices.clear();
    final result = await Net.get(
      '/admin/stats/products/breakdown?productId=$productId&period=$period',
    );
    loadingBreakdown.value = false;
    if (result.hasError) return;
    if (result.body['trend'] != null) {
      final List<dynamic> trend = result.body['trend'];
      productBreakdown.value = trend.map((e) => ProductSalesTrend.fromJson(e)).toList();
    }
    if (result.body['pie'] != null) {
      final List<dynamic> pie = result.body['pie'];
      productPieSlices.value = pie.map((e) => ProductPieSlice.fromJson(e)).toList();
    }
  }

  // ── EXPENSES OVERVIEW ──
  RxBool loadingExpensesOverview = RxBool(false);
  Rxn<ExpenseOverviewData> expensesOverview = Rxn<ExpenseOverviewData>();

  Future<void> fetchExpensesOverview({String period = 'daily'}) async {
    if (loadingExpensesOverview.value) return;
    loadingExpensesOverview.value = true;
    final result = await Net.get('/admin/stats/expenses/overview?period=$period');
    loadingExpensesOverview.value = false;

    if (result.hasError) {
      Toaster.showError('Failed to fetch expenses overview');
      return;
    }

    if (result.body != null) {
      expensesOverview.value = ExpenseOverviewData.fromJson(result.body);
    }
  }

  RxBool loadingMonthlyReport = RxBool(false);
  Rx<MonthlyReportModel?> monthlyReport = Rx<MonthlyReportModel?>(null);
  RxString monthlyReportError = RxString("");

  Rx<YearlyReportModel?> yearlyReport = Rx<YearlyReportModel?>(null);
  RxBool loadingYearlyReport = false.obs;
  RxString yearlyReportError = RxString("");

  Future<void> fetchMonthlyReport({required DateTime startDate, required DateTime endDate}) async {
    if (loadingMonthlyReport.value) return;
    loadingMonthlyReport.value = true;
    monthlyReportError.value = "";
    
    // Ensure clean dates for backend API
    final cleanStart = DateTime.utc(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final cleanEnd = DateTime.utc(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    );

    final response = await Net.get("/admin/stats/monthly-reports?startDate=${cleanStart.toIso8601String()}&endDate=${cleanEnd.toIso8601String()}");
    loadingMonthlyReport.value = false;

    if (response.hasError) {
      monthlyReportError.value = response.response;
      return;
    }

    if (response.body != null) {
      try {
        monthlyReport.value = MonthlyReportModel.fromJson(response.body);
      } catch (e) {
        monthlyReportError.value = "Failed to parse data: $e";
      }
    }
  }

  Future<void> fetchYearlyReport(int year) async {
    loadingYearlyReport.value = true;
    yearlyReportError.value = "";
    update();

    final response = await Net.get("/admin/stats/yearly-reports?year=$year");
    loadingYearlyReport.value = false;

    if (response.hasError) {
      yearlyReportError.value = response.response;
      return;
    }

    if (response.body != null) {
      try {
        yearlyReport.value = YearlyReportModel.fromJson(response.body);
      } catch (e) {
        yearlyReportError.value = "Failed to parse data: $e";
      }
    }
  }
}
