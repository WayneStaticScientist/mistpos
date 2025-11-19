import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/models/subscripiton_model.dart';

class CompanyModel {
  String owner;
  String email;
  String name;
  ExchangeRateModel exchangeRates;
  SubscriptionModel subscriptionType;
  String hexId;
  CompanyModel({
    required this.owner,
    required this.email,
    required this.name,
    required this.hexId,
    required this.exchangeRates,
    required this.subscriptionType,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'] ?? "-",
      owner: json['owner'],
      email: json['email'],
      hexId: json['_id'] ?? "",
      subscriptionType: json['subscriptionType'] != null
          ? SubscriptionModel.fromJson(json['subscriptionType'])
          : SubscriptionModel(),
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
      "subscriptionType": subscriptionType.toJson(),
    };
  }
}
