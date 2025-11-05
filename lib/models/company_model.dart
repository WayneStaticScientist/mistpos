import 'package:mistpos/models/exchange_rate_model.dart';

class CompanyModel {
  String owner;
  String email;
  ExchangeRateModel exchangeRates;
  CompanyModel({
    required this.owner,
    required this.email,
    required this.exchangeRates,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      owner: json['owner'],
      email: json['email'],
      exchangeRates: ExchangeRateModel.fromJson(json['exchangeRates']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "owner": owner,
      "email": email,
      "exchangeRates": exchangeRates.toJson(),
    };
  }
}
