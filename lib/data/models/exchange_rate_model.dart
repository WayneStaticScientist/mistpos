class ExchangeRateModel {
  String name;
  Map<String, double> rates;
  ExchangeRateModel({required this.name, required this.rates});
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    Map<String, double> doubleRates = Map.fromEntries(
      (json['rates'] as Map<String, dynamic>).entries.map(
        (entry) => MapEntry(entry.key, (entry.value as num).toDouble()),
      ),
    );
    return ExchangeRateModel(name: json['name'], rates: doubleRates);
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'rates': rates};
  }
}
