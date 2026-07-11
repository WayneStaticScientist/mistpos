class GiganticOverview {
  final GiganticTotals totals;
  final List<CompanyRanking> companyRankings;
  final List<CompanyShifts> companyShifts;
  final List<GiganticGraphPoint> graphData;
  final List<GiganticEmployee> employees;

  GiganticOverview({
    required this.totals,
    required this.companyRankings,
    required this.companyShifts,
    required this.graphData,
    required this.employees,
  });

  factory GiganticOverview.fromJson(Map<String, dynamic> json) {
    return GiganticOverview(
      totals: GiganticTotals.fromJson(json['totals'] ?? {}),
      companyRankings: (json['companyRankings'] as List? ?? []).map((e) => CompanyRanking.fromJson(e)).toList(),
      companyShifts: (json['companyShifts'] as List? ?? []).map((e) => CompanyShifts.fromJson(e)).toList(),
      graphData: (json['graphData'] as List? ?? []).map((e) => GiganticGraphPoint.fromJson(e)).toList(),
      employees: (json['employees'] as List? ?? []).map((e) => GiganticEmployee.fromJson(e)).toList(),
    );
  }

  GiganticOverview copyWith({
    GiganticTotals? totals,
    List<CompanyRanking>? companyRankings,
    List<CompanyShifts>? companyShifts,
    List<GiganticGraphPoint>? graphData,
    List<GiganticEmployee>? employees,
  }) {
    return GiganticOverview(
      totals: totals ?? this.totals,
      companyRankings: companyRankings ?? this.companyRankings,
      companyShifts: companyShifts ?? this.companyShifts,
      graphData: graphData ?? this.graphData,
      employees: employees ?? this.employees,
    );
  }
}

class GiganticTotals {
  final double revenue;
  final double grossProfit;
  final double netProfit;
  final double taxes;
  final double discounts;
  final int receipts;
  final double expenses;
  final int cashiersCount;

  GiganticTotals({
    required this.revenue,
    required this.grossProfit,
    required this.netProfit,
    required this.taxes,
    required this.discounts,
    required this.receipts,
    required this.expenses,
    required this.cashiersCount,
  });

  factory GiganticTotals.fromJson(Map<String, dynamic> json) {
    return GiganticTotals(
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      grossProfit: (json['grossProfit'] ?? 0.0).toDouble(),
      netProfit: (json['netProfit'] ?? 0.0).toDouble(),
      taxes: (json['taxes'] ?? 0.0).toDouble(),
      discounts: (json['discounts'] ?? 0.0).toDouble(),
      receipts: json['receipts'] ?? 0,
      expenses: (json['expenses'] ?? 0.0).toDouble(),
      cashiersCount: json['cashiersCount'] ?? 0,
    );
  }
}

class CompanyRanking {
  final String companyId;
  final String companyName;
  final double revenue;
  final double profit;
  final double score;

  CompanyRanking({
    required this.companyId,
    required this.companyName,
    required this.revenue,
    required this.profit,
    required this.score,
  });

  factory CompanyRanking.fromJson(Map<String, dynamic> json) {
    return CompanyRanking(
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      profit: (json['profit'] ?? 0.0).toDouble(),
      score: (json['score'] ?? 0.0).toDouble(),
    );
  }
}

class CompanyShifts {
  final String companyName;
  final int shifts;

  CompanyShifts({
    required this.companyName,
    required this.shifts,
  });

  factory CompanyShifts.fromJson(Map<String, dynamic> json) {
    return CompanyShifts(
      companyName: json['companyName'] ?? '',
      shifts: json['shifts'] ?? 0,
    );
  }
}

class GiganticGraphPoint {
  final int timeKey;
  final double revenue;
  final double expenses;
  final int receipts;
  final double profits;

  GiganticGraphPoint({
    required this.timeKey,
    required this.revenue,
    required this.expenses,
    required this.receipts,
    required this.profits,
  });

  factory GiganticGraphPoint.fromJson(Map<String, dynamic> json) {
    return GiganticGraphPoint(
      timeKey: json['timeKey'] ?? 0,
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      expenses: (json['expenses'] ?? 0.0).toDouble(),
      receipts: json['receipts'] ?? 0,
      profits: (json['profits'] ?? 0.0).toDouble(),
    );
  }
}

class GiganticEmployee {
  final String name;
  final String companyName;
  final int receipts;
  final double revenue;
  final double profit;
  final int shifts;

  GiganticEmployee({
    required this.name,
    required this.companyName,
    required this.receipts,
    required this.revenue,
    required this.profit,
    required this.shifts,
  });

  factory GiganticEmployee.fromJson(Map<String, dynamic> json) {
    return GiganticEmployee(
      name: json['name'] ?? '',
      companyName: json['companyName'] ?? '',
      receipts: json['receipts'] ?? 0,
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      profit: (json['profit'] ?? 0.0).toDouble(),
      shifts: json['shifts'] ?? 0,
    );
  }
}
