import 'dart:math';

import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
import 'package:mistpos/data/models/mini_tax.dart';
import 'package:mistpos/data/models/item_receit_item.dart';
import 'package:mistpos/data/models/embedded_discount_model.dart';
part 'item_receit_model.g.dart';

/// Stable idempotency key sent with POST /cashier/purchase (retries + double-tap).
String generateClientSaleId() {
  final r = Random.secure();
  return List.generate(16, (_) => r.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
}

String _receiptMongoId(dynamic id) {
  if (id == null) return '';
  if (id is String) return id;
  if (id is Map && id[r'$oid'] != null) return id[r'$oid'].toString();
  return id.toString();
}

@collection
class ItemReceitModel {
  late int id = IdGen.id;
  final String cashier;
  final String payment;
  final double change;
  bool creditSale = false;
  double tax;
  double taxAmount;
  double amount;
  double currentAmountPayed;
  double total;
  bool synced = false;
  DateTime createdAt;
  String hexId = "";
  String clientSaleId = "";
  String currency = "";
  String? customerId;
  String label;
  List<MiniTax> miniTax;
  List<ItemReceitItem> items = [];
  List<EmbeddedDiscountModel> discounts = [];
  bool fiscalized = false;
  String? zimraReceiptId;
  String? zimraSignature;
  int? zimraReceiptGlobalNo;
  int? zimraDeviceId;
  int? zimraFiscalDayNo;
  /// ddMMyyyy (Harare) — same day as FDMS receiptDate for QR §11.
  String? zimraReceiptDateQr;
  String? zimraQrCodeUrl;
  /// ZIMRA FDMS: FiscalInvoice | CreditNote | DebitNote
  String receiptType;
  /// Mongo id of credited/debited fiscal invoice (credit/debit notes).
  String? originalReceiptId;
  ItemReceitModel({
    required this.items,
    required this.total,
    required this.amount,
    required this.hexId,
    required this.change,
    required this.cashier,
    required this.payment,
    required this.createdAt,
    this.miniTax = const [],
    this.tax = 0,
    this.taxAmount = 0,
    this.customerId,
    this.currency =
        "", //currence is just way to record on which currency did the receipt was sold , althought the value will be converted to base USD currency in background , this helps us to keep track
    this.label = "",
    this.clientSaleId = "",
    this.synced = false,
    this.creditSale = false,
    this.currentAmountPayed = 0.0,
    this.discounts = const [],
    this.fiscalized = false,
    this.zimraReceiptId,
    this.zimraSignature,
    this.zimraReceiptGlobalNo,
    this.zimraDeviceId,
    this.zimraFiscalDayNo,
    this.zimraReceiptDateQr,
    this.zimraQrCodeUrl,
    this.receiptType = 'FiscalInvoice',
    this.originalReceiptId,
  });
  Map<String, dynamic> toJson() {
    return {
      "currency": currency,
      "creditSale": creditSale,
      "customerId": customerId,
      "cashier": cashier,
      "payment": payment,
      "change": change,
      "amount": amount,
      "currentAmountPayed": currentAmountPayed,
      "total": total,
      "synced": synced,
      "label": label,
      "clientSaleId": clientSaleId,
      "tax": tax,
      "taxAmount": taxAmount,
      'miniTax': miniTax.map((e) => e.toJson()).toList(),
      "createdAt": createdAt.toIso8601String(),
      "discounts": discounts
          .map<Map<String, dynamic>>((e) => e.toJson())
          .toList(),
      "items": items.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
      "fiscalized": fiscalized,
      "zimraReceiptId": zimraReceiptId,
      "zimraSignature": zimraSignature,
      "zimraReceiptGlobalNo": zimraReceiptGlobalNo,
      "zimraDeviceId": zimraDeviceId,
      "zimraFiscalDayNo": zimraFiscalDayNo,
      "zimraReceiptDateQr": zimraReceiptDateQr,
      "zimraQrCodeUrl": zimraQrCodeUrl,
      "receiptType": receiptType,
      "originalReceiptId": originalReceiptId,
    };
  }

  factory ItemReceitModel.fromJson(Map<String, dynamic> data) {
    return ItemReceitModel(
      currency: data['currency'] ?? '',
      creditSale: data['creditSale'] ?? false,
      customerId: data['customerId'],
      items: data['items'] != null
          ? (data['items'] as List<dynamic>)
                .map((e) => ItemReceitItem.fromJson(e))
                .toList()
          : [],
      label: data['label'] ?? "-",
      clientSaleId: data['clientSaleId']?.toString() ?? "",
      miniTax: data['miniTax'] != null
          ? (data['miniTax'] as List<dynamic>)
                .map((e) => MiniTax.fromJson(e))
                .toList()
          : [],
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (data['taxAmount'] as num?)?.toDouble() ?? 0.0,
      synced: data['synced'] ?? false,
      hexId: _receiptMongoId(data['_id']),
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currentAmountPayed:
          (data['currentAmountPayed'] as num?)?.toDouble() ?? 0.0,
      change: (data['change'] as num?)?.toDouble() ?? 0.0,
      cashier: data['cashier'],
      payment: data['payment'],
      discounts: data['discounts'] != null
          ? (data['discounts'] as List<dynamic>)
                .map((e) => EmbeddedDiscountModel.fromJson(e))
                .toList()
          : [],
      createdAt: DateTime.tryParse(data['createdAt']) ?? DateTime.now(),
      fiscalized: data['fiscalized'] ?? false,
      zimraReceiptId: data['zimraReceiptId'],
      zimraSignature: data['zimraSignature'],
      zimraReceiptGlobalNo: data['zimraReceiptGlobalNo'],
      zimraDeviceId: data['zimraDeviceId'],
      zimraFiscalDayNo: data['zimraFiscalDayNo'],
      zimraReceiptDateQr: data['zimraReceiptDateQr']?.toString(),
      zimraQrCodeUrl: data['zimraQrCodeUrl']?.toString(),
      receiptType: data['receiptType']?.toString() ?? 'FiscalInvoice',
      originalReceiptId: data['originalReceiptId']?.toString(),
    );
  }

  /// Updates ZIMRA fields from a server receipt payload (e.g. after fiscalize).
  void applyZimraFiscalizationFrom(Map<String, dynamic> data) {
    if (data['fiscalized'] != null) {
      fiscalized = data['fiscalized'] as bool;
    } else {
      fiscalized = true;
    }
    zimraReceiptId = data['zimraReceiptId']?.toString();
    zimraSignature = data['zimraSignature']?.toString();
    final globalNo = data['zimraReceiptGlobalNo'];
    zimraReceiptGlobalNo = globalNo is num ? globalNo.toInt() : null;
    final deviceId = data['zimraDeviceId'];
    zimraDeviceId = deviceId is num ? deviceId.toInt() : null;
    final dayNo = data['zimraFiscalDayNo'];
    zimraFiscalDayNo = dayNo is num ? dayNo.toInt() : null;
    if (data['zimraReceiptDateQr'] != null) {
      zimraReceiptDateQr = data['zimraReceiptDateQr'].toString();
    }
    if (data['zimraQrCodeUrl'] != null) {
      zimraQrCodeUrl = data['zimraQrCodeUrl'].toString();
    }
    if (data['receiptType'] != null) {
      receiptType = data['receiptType'].toString();
    }
    if (data['originalReceiptId'] != null) {
      originalReceiptId = data['originalReceiptId'].toString();
    }
  }
}
