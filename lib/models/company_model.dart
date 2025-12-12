import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/models/subscripiton_model.dart';

class CompanyModel {
  String owner;
  String email;
  String name;
  bool verified;
  ExchangeRateModel exchangeRates;
  SubscriptionModel subscriptionType;

  String hexId;
  CompanyModel({
    required this.owner,
    required this.email,
    required this.name,
    required this.hexId,
    this.verified = false,
    required this.exchangeRates,
    required this.subscriptionType,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'] ?? "-",
      owner: json['owner'],
      email: json['email'],
      verified: json['verified'] ?? false,
      hexId: json['_id'] ?? "",
      subscriptionType: json['subscriptionType'] != null
          ? SubscriptionModel.fromJson(json['subscriptionType'])
          : SubscriptionModel(),
      exchangeRates: ExchangeRateModel.fromJson(json['exchangeRates']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "_id": hexId,
      "name": name,
      "owner": owner,
      "email": email,
      "verified": verified,
      "exchangeRates": exchangeRates.toJson(),
      "subscriptionType": subscriptionType.toJson(),
    };
  }

  void saveToStorage() {
    GetStorage storage = GetStorage();
    storage.write("company", toJson());
  }

  static CompanyModel? fromStorage() {
    GetStorage storage = GetStorage();
    if (!storage.hasData("company")) return null;
    return CompanyModel.fromJson(storage.read("company"));
  }
}
