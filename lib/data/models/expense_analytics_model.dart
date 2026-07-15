import 'package:mistpos/data/models/expense_model.dart';

class ExpenseAnalyticsTotals {
  final double totalAllTime;
  final double totalToday;
  final double totalMonth;
  final double totalYear;

  ExpenseAnalyticsTotals({
    required this.totalAllTime,
    required this.totalToday,
    required this.totalMonth,
    required this.totalYear,
  });

  factory ExpenseAnalyticsTotals.fromJson(Map<String, dynamic> json) {
    return ExpenseAnalyticsTotals(
      totalAllTime: (json['totalAllTime'] ?? 0).toDouble(),
      totalToday: (json['totalToday'] ?? 0).toDouble(),
      totalMonth: (json['totalMonth'] ?? 0).toDouble(),
      totalYear: (json['totalYear'] ?? 0).toDouble(),
    );
  }
}

class ExpenseTrendPoint {
  final String date;
  final double amount;

  ExpenseTrendPoint({
    required this.date,
    required this.amount,
  });

  factory ExpenseTrendPoint.fromJson(Map<String, dynamic> json) {
    return ExpenseTrendPoint(
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class ExpenseCategoryWeight {
  final String name;
  final double amount;
  final double percentage;

  ExpenseCategoryWeight({
    required this.name,
    required this.amount,
    required this.percentage,
  });

  factory ExpenseCategoryWeight.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryWeight(
      name: json['name']?.toString() ?? 'Uncategorized',
      amount: (json['amount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}

class ExpenseEmployeeWeight {
  final String name;
  final double amount;
  final double percentage;

  ExpenseEmployeeWeight({
    required this.name,
    required this.amount,
    required this.percentage,
  });

  factory ExpenseEmployeeWeight.fromJson(Map<String, dynamic> json) {
    return ExpenseEmployeeWeight(
      name: json['name']?.toString() ?? 'Unknown',
      amount: (json['amount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}

class ExpenseOverviewData {
  final ExpenseAnalyticsTotals totals;
  final List<ExpenseTrendPoint> trend;
  final List<ExpenseCategoryWeight> categories;
  final List<ExpenseEmployeeWeight> employees;
  final List<ExpenseModel> pendingExpenses;

  ExpenseOverviewData({
    required this.totals,
    required this.trend,
    required this.categories,
    required this.employees,
    required this.pendingExpenses,
  });

  factory ExpenseOverviewData.fromJson(Map<String, dynamic> json) {
    return ExpenseOverviewData(
      totals: json['totals'] != null 
          ? ExpenseAnalyticsTotals.fromJson(json['totals']) 
          : ExpenseAnalyticsTotals(totalAllTime: 0, totalToday: 0, totalMonth: 0, totalYear: 0),
      trend: (json['trend'] as List<dynamic>?)
              ?.map((e) => ExpenseTrendPoint.fromJson(e))
              .toList() ?? [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => ExpenseCategoryWeight.fromJson(e))
              .toList() ?? [],
      employees: (json['employees'] as List<dynamic>?)
              ?.map((e) => ExpenseEmployeeWeight.fromJson(e))
              .toList() ?? [],
      pendingExpenses: (json['pendingExpenses'] as List<dynamic>?)
              ?.map((e) => ExpenseModel.fromJson(e))
              .toList() ?? [],
    );
  }
}
