import 'package:get_storage/get_storage.dart';
import 'package:mistpos/data/models/exchange_rate_model.dart';
import 'package:mistpos/data/models/receit_extras_model.dart';
import 'package:mistpos/data/models/subscripiton_model.dart';

class AiSubscriptionsModel {
  final int tokens;
  AiSubscriptionsModel({required this.tokens});
  
  factory AiSubscriptionsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AiSubscriptionsModel(tokens: 0);
    return AiSubscriptionsModel(
      tokens: json['tokens'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokens': tokens,
    };
  }
}

class AutomatedSyncModel {
  final bool hasSubscription;
  final DateTime? validUntil;
  final String phone;
  final double price;
  final bool phoneVerified;
  AutomatedSyncModel({
    required this.hasSubscription,
    required this.validUntil,
    required this.price,
    required this.phone,
    this.phoneVerified = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'hasSubscription': hasSubscription,
      'validUntil': validUntil?.toIso8601String(),
      'price': price,
      'phone': phone,
      'phoneVerified': phoneVerified,
    };
  }

  factory AutomatedSyncModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AutomatedSyncModel(
        hasSubscription: false,
        validUntil: null,
        price: 0.0,
        phone: "",
        phoneVerified: false,
      );
    }
    return AutomatedSyncModel(
      hasSubscription: json['hasSubscription'] ?? false,
      phone: json['phone'] ?? "",
      phoneVerified: json['phoneVerified'] ?? false,
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static AutomatedSyncModel empty() {
    return AutomatedSyncModel(
      hasSubscription: false,
      validUntil: null,
      price: 0.0,
      phone: "",
      phoneVerified: false,
    );
  }
}

class ResellerPropsModel {
  final double percentage;
  final String code;
  final String status;
  final String statusReason;

  ResellerPropsModel({
    required this.percentage,
    required this.code,
    required this.status,
    required this.statusReason,
  });

  factory ResellerPropsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ResellerPropsModel(
        percentage: 0.0,
        code: "",
        status: "Not-a-Reseller",
        statusReason: "",
      );
    }
    return ResellerPropsModel(
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      code: json['code'] as String? ?? "",
      status: json['status'] as String? ?? "Not-a-Reseller",
      statusReason: json['statusReason'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'code': code,
      'status': status,
      'statusReason': statusReason,
    };
  }
}

class CompanyModel {
  String owner;
  String email;
  String name;
  bool enableCreditSale;
  bool shiftBasedSales;
  bool verified;
  bool showSalesCount;
  ExchangeRateModel exchangeRates;
  SubscriptionModel subscriptionType;
  bool autoApproveAllExpenses;
  String hexId;
  final AutomatedSyncModel automatedSync;
  final AutomatedSyncModel weeklyAutomatedSync;
  AiSubscriptionsModel aiSubscriptions;
  List<ReceitExtrasModel> receitExtras;
  final String? reseller;
  final ResellerPropsModel resellerProps;
  
  // Zimra integration fields
  int? zimraDeviceId;
  String? zimraDeviceSerialNo;
  String? zimraActivationKey;
  String? zimraCertificate;
  DateTime? zimraCertificateValidTill;
  bool? zimraIsTest;
  int? zimraFiscalDayNo;
  String? zimraFiscalDayStatus;
  DateTime? zimraLastFiscalDayOpened;
  int? zimraReceiptGlobalNo;
  int? zimraReceiptCounter;
  bool? zimraAutoOpenFiscalDay;
  bool? zimraAllowOfflineReceipts;
  bool? zimraQrFiscilization;

  CompanyModel({
    required this.owner,
    required this.email,
    required this.name,
    this.receitExtras = const [],
    required this.hexId,
    this.verified = false,
    required this.exchangeRates,
    required this.showSalesCount,
    required this.subscriptionType,
    required this.enableCreditSale,
    this.shiftBasedSales = false,
    this.autoApproveAllExpenses = false,
    required this.automatedSync,
    required this.weeklyAutomatedSync,
    required this.aiSubscriptions,
    this.reseller,
    required this.resellerProps,
    this.zimraDeviceId,
    this.zimraDeviceSerialNo,
    this.zimraActivationKey,
    this.zimraCertificate,
    this.zimraCertificateValidTill,
    this.zimraIsTest,
    this.zimraFiscalDayNo,
    this.zimraFiscalDayStatus,
    this.zimraLastFiscalDayOpened,
    this.zimraReceiptGlobalNo,
    this.zimraReceiptCounter,
    this.zimraAutoOpenFiscalDay,
    this.zimraAllowOfflineReceipts,
    this.zimraQrFiscilization,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      automatedSync: AutomatedSyncModel.fromJson(json['automatedSync']),
      weeklyAutomatedSync: AutomatedSyncModel.fromJson(
        json['weeklyAutomatedSync'],
      ),
      aiSubscriptions: AiSubscriptionsModel.fromJson(json['aiSubscriptions']),
      autoApproveAllExpenses: json['autoApproveAllExpenses'] ?? false,
      enableCreditSale: json['enableCreditSale'] ?? true,
      shiftBasedSales: json['shiftBasedSales'] ?? false,
      owner: json['owner'],
      email: json['email'],
      hexId: json['_id'] ?? "",
      receitExtras:
          (json['receitExtras'] as List<dynamic>?)
               ?.map((e) => ReceitExtrasModel.fromJSON(e))
               .toList() ??
          [],
      name: json['name'] ?? "-",
      verified: json['verified'] ?? false,
      showSalesCount: json['showSalesCount'] ?? false,
      subscriptionType: json['subscriptionType'] != null
          ? SubscriptionModel.fromJson(json['subscriptionType'])
          : SubscriptionModel(),
      exchangeRates: ExchangeRateModel.fromJson(json['exchangeRates']),
      reseller: json['reseller'] as String?,
      resellerProps: ResellerPropsModel.fromJson(json['resellerProps']),
      zimraDeviceId: json['zimra'] != null ? json['zimra']['deviceId'] as int? : json['zimraDeviceId'] as int?,
      zimraDeviceSerialNo: json['zimra'] != null ? json['zimra']['deviceSerialNo'] as String? : json['zimraDeviceSerialNo'] as String?,
      zimraActivationKey: json['zimra'] != null ? json['zimra']['activationKey'] as String? : json['zimraActivationKey'] as String?,
      zimraCertificate: json['zimra'] != null ? json['zimra']['certificate'] as String? : json['zimraCertificate'] as String?,
      zimraCertificateValidTill: json['zimra'] != null
          ? (json['zimra']['certificateValidTill'] != null ? DateTime.parse(json['zimra']['certificateValidTill']) : null)
          : (json['zimraCertificateValidTill'] != null ? DateTime.parse(json['zimraCertificateValidTill']) : null),
      zimraIsTest: json['zimra'] != null ? (json['zimra']['isTest'] as bool? ?? true) : (json['zimraIsTest'] as bool? ?? true),
      zimraFiscalDayNo: json['zimra'] != null ? json['zimra']['fiscalDayNo'] as int? : json['zimraFiscalDayNo'] as int?,
      zimraFiscalDayStatus: json['zimra'] != null ? json['zimra']['fiscalDayStatus'] as String? : json['zimraFiscalDayStatus'] as String?,
      zimraLastFiscalDayOpened: json['zimra'] != null
          ? (json['zimra']['lastFiscalDayOpened'] != null ? DateTime.parse(json['zimra']['lastFiscalDayOpened']) : null)
          : (json['zimraLastFiscalDayOpened'] != null ? DateTime.parse(json['zimraLastFiscalDayOpened']) : null),
      zimraReceiptGlobalNo: json['zimra'] != null ? json['zimra']['receiptGlobalNo'] as int? : json['zimraReceiptGlobalNo'] as int?,
      zimraReceiptCounter: json['zimra'] != null ? json['zimra']['receiptCounter'] as int? : json['zimraReceiptCounter'] as int?,
      zimraAutoOpenFiscalDay: json['zimra'] != null ? (json['zimra']['autoOpenFiscalDay'] as bool? ?? false) : (json['zimraAutoOpenFiscalDay'] as bool? ?? false),
      zimraAllowOfflineReceipts: json['zimra'] != null ? (json['zimra']['allowOfflineReceipts'] as bool? ?? false) : (json['zimraAllowOfflineReceipts'] as bool? ?? false),
      zimraQrFiscilization: json['zimra'] != null ? (json['zimra']['qrFiscilization'] as bool? ?? false) : (json['zimraQrFiscilization'] as bool? ?? false),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "_id": hexId,
      "name": name,
      "owner": owner,
      "email": email,
      "verified": verified,
      'automatedSync': automatedSync.toJson(),
      'weeklyAutomatedSync': weeklyAutomatedSync.toJson(),
      'aiSubscriptions': aiSubscriptions.toJson(),
      "showSalesCount": showSalesCount,
      'enableCreditSale': enableCreditSale,
      'shiftBasedSales': shiftBasedSales,
      "exchangeRates": exchangeRates.toJson(),
      "subscriptionType": subscriptionType.toJson(),
      'autoApproveAllExpenses': autoApproveAllExpenses,
      "receitExtras": receitExtras.map((e) => e.toJson()).toList(),
      'reseller': reseller,
      'resellerProps': resellerProps.toJson(),
      'zimraDeviceId': zimraDeviceId,
      'zimraDeviceSerialNo': zimraDeviceSerialNo,
      'zimraActivationKey': zimraActivationKey,
      'zimraCertificate': zimraCertificate,
      'zimraCertificateValidTill': zimraCertificateValidTill?.toIso8601String(),
      'zimraIsTest': zimraIsTest,
      'zimraFiscalDayNo': zimraFiscalDayNo,
      'zimraFiscalDayStatus': zimraFiscalDayStatus,
      'zimraLastFiscalDayOpened': zimraLastFiscalDayOpened?.toIso8601String(),
      'zimraReceiptGlobalNo': zimraReceiptGlobalNo,
      'zimraReceiptCounter': zimraReceiptCounter,
      'zimraAutoOpenFiscalDay': zimraAutoOpenFiscalDay,
      'zimraAllowOfflineReceipts': zimraAllowOfflineReceipts,
      'zimraQrFiscilization': zimraQrFiscilization,
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
