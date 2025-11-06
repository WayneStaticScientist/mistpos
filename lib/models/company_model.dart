import 'package:mistpos/models/exchange_rate_model.dart';

class CompanyModel {
  String owner;
  String email;
  String name;
  ExchangeRateModel exchangeRates;
  String hexId;
  CompanyModel({
    required this.owner,
    required this.email,
    required this.exchangeRates,
    required this.name,
    required this.hexId,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'] ?? "-",
      owner: json['owner'],
      email: json['email'],
      hexId: json['_id'] ?? "",
      exchangeRates: ExchangeRateModel.fromJson(json['exchangeRates']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "owner": owner,
      "email": email,
      "_id": hexId,
      "exchangeRates": exchangeRates.toJson(),
    };
  }
}
