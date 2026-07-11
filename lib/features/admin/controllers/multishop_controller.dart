import 'package:get/get.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/data/models/multishop_gigantic_model.dart';
import 'package:mistpos/data/models/multishop_overview_model.dart';
import 'package:mistpos/core/utils/toast.dart';

class MultiShopController extends GetxController {
  RxBool loadingStats = RxBool(false);
  RxList<MultiShopData> multishopData = RxList<MultiShopData>();

  RxBool loadingGraphs = RxBool(false);
  RxList<MultiShopGraphData> multishopGraphs = RxList<MultiShopGraphData>();

  Future<void> fetchMultiShopData({
    DateTime? startDate,
    required DateTime endDate,
  }) async {
    if (loadingStats.value) return;
    loadingStats.value = true;

    final cleanStart = startDate != null ? DateTime.utc(
      startDate.year,
      startDate.month,
      startDate.day,
    ).toIso8601String() : '';
    
    final cleanEnd = DateTime.utc(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    ).toIso8601String();

    final url = '/admin/stats/multishop?startDate=$cleanStart&endDate=$cleanEnd';
    final response = await Net.get(url);

    loadingStats.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch multishop stats: ${response.response}");
      return;
    }

    if (response.body['list'] != null) {
      final List<dynamic> list = response.body['list'];
      multishopData.assignAll(list.map((e) => MultiShopData.fromJson(e)).toList());
    }
  }

  Future<void> fetchMultiShopGraphs({
    required DateTime endDate,
    String period = 'daily',
  }) async {
    if (loadingGraphs.value) return;
    loadingGraphs.value = true;

    final cleanEnd = DateTime.utc(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    ).toIso8601String();

    final url = '/admin/stats/multishop/graphs?endDate=$cleanEnd&period=$period';
    final response = await Net.get(url);

    loadingGraphs.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch multishop graphs: ${response.response}");
      return;
    }

    if (response.body['list'] != null) {
      final List<dynamic> list = response.body['list'];
      multishopGraphs.assignAll(list.map((e) => MultiShopGraphData.fromJson(e)).toList());
    }
  }

  RxBool loadingDailySales = RxBool(false);
  RxList<MultiShopDailySalesData> multishopDailySales = RxList<MultiShopDailySalesData>();

  Future<void> fetchMultiShopDailySales({
    required DateTime date,
  }) async {
    if (loadingDailySales.value) return;
    loadingDailySales.value = true;

    final cleanDate = DateTime.utc(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
    ).toIso8601String();

    final url = '/admin/stats/multishop/sales/daily?date=$cleanDate';
    final response = await Net.get(url);

    loadingDailySales.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch multishop daily sales: ${response.response}");
      return;
    }

    if (response.body['list'] != null) {
      final List<dynamic> list = response.body['list'];
      multishopDailySales.assignAll(list.map((e) => MultiShopDailySalesData.fromJson(e)).toList());
    }
  }

  RxBool loadingMonthlySales = RxBool(false);
  RxList<MultiShopDailySalesData> multishopMonthlySales = RxList<MultiShopDailySalesData>();

  Future<void> fetchMultiShopMonthlySales({
    required DateTime date,
  }) async {
    if (loadingMonthlySales.value) return;
    loadingMonthlySales.value = true;

    final lastDay = DateTime(date.year, date.month + 1, 0);
    final cleanDate = DateTime.utc(
      date.year,
      date.month,
      lastDay.day,
      23,
      59,
      59,
      999,
    ).toIso8601String();

    final url = '/admin/stats/multishop/sales/monthly?date=$cleanDate';
    final response = await Net.get(url);

    loadingMonthlySales.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch multishop monthly sales: ${response.response}");
      return;
    }

    if (response.body['list'] != null) {
      final List<dynamic> list = response.body['list'];
      multishopMonthlySales.assignAll(list.map((e) => MultiShopDailySalesData.fromJson(e)).toList());
    }
  }

  RxBool loadingYearlySales = RxBool(false);
  RxList<MultiShopDailySalesData> multishopYearlySales = RxList<MultiShopDailySalesData>();

  Future<void> fetchMultiShopYearlySales({
    required DateTime date,
  }) async {
    if (loadingYearlySales.value) return;
    loadingYearlySales.value = true;

    final cleanDate = DateTime.utc(
      date.year,
      12,
      31,
      23,
      59,
      59,
      999,
    ).toIso8601String();

    final url = '/admin/stats/multishop/sales/yearly?date=$cleanDate';
    final response = await Net.get(url);

    loadingYearlySales.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch multishop yearly sales: ${response.response}");
      return;
    }

    if (response.body['list'] != null) {
      final List<dynamic> list = response.body['list'];
      multishopYearlySales.assignAll(list.map((e) => MultiShopDailySalesData.fromJson(e)).toList());
    }
  }

  RxBool loadingGigantic = RxBool(false);
  RxBool loadingGiganticGraphs = RxBool(false);
  Rx<GiganticOverview?> giganticOverview = Rx<GiganticOverview?>(null);

  Future<void> fetchGiganticOverview({
    DateTime? startDate,
    required DateTime endDate,
    String period = 'daily', // 'daily', 'monthly', 'yearly'
  }) async {
    if (loadingGigantic.value) return;
    loadingGigantic.value = true;

    final endStr = endDate.toIso8601String();
    final startStr = startDate?.toIso8601String() ?? '';

    final url = '/admin/stats/multishop/gigantic?date=$endStr${startStr.isNotEmpty ? '&startDate=$startStr' : ''}&period=$period';
    final response = await Net.get(url);

    loadingGigantic.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch gigantic overview: ${response.response}");
      return;
    }

    if (response.body != null) {
      giganticOverview.value = GiganticOverview.fromJson(response.body);
    }
  }

  Future<void> fetchGiganticGraphs({
    required DateTime endDate,
    String period = 'daily',
  }) async {
    if (loadingGiganticGraphs.value) return;
    loadingGiganticGraphs.value = true;

    final endStr = endDate.toIso8601String();
    final url = '/admin/stats/multishop/gigantic/graphs?date=$endStr&period=$period';
    final response = await Net.get(url);

    loadingGiganticGraphs.value = false;
    if (response.hasError) {
      Toaster.showError("Failed to fetch gigantic graphs: ${response.response}");
      return;
    }

    if (response.body != null && response.body['graphData'] != null && giganticOverview.value != null) {
      final List<dynamic> rawGraphs = response.body['graphData'];
      final newGraphs = rawGraphs.map((e) => GiganticGraphPoint.fromJson(e)).toList();
      giganticOverview.value = giganticOverview.value!.copyWith(graphData: newGraphs);
    }
  }
}
