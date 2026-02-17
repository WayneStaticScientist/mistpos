import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/models/subscripiton_model.dart';

class CompanyModel {
  String owner;
  String email;
  String name;
  bool enableCreditSale;
  bool verified;
  bool showSalesCount;
  ExchangeRateModel exchangeRates;
  SubscriptionModel subscriptionType;
  bool autoApproveAllExpenses;
  String hexId;
  CompanyModel({
    required this.owner,
    required this.email,
    required this.name,
    required this.hexId,
    this.verified = false,
    required this.exchangeRates,
    required this.showSalesCount,
    required this.subscriptionType,
    required this.enableCreditSale,
    this.autoApproveAllExpenses = false,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      autoApproveAllExpenses: json['autoApproveAllExpenses'] ?? false,
      enableCreditSale: json['enableCreditSale'] ?? true,
      owner: json['owner'],
      email: json['email'],
      hexId: json['_id'] ?? "",
      name: json['name'] ?? "-",
      verified: json['verified'] ?? false,
      showSalesCount: json['showSalesCount'] ?? false,
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
      "showSalesCount": showSalesCount,
      'enableCreditSale': enableCreditSale,
      "exchangeRates": exchangeRates.toJson(),
      "subscriptionType": subscriptionType.toJson(),
      'autoApproveAllExpenses': autoApproveAllExpenses,
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
