import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ZimraHelper {
  static String manualZimraUrl = "https://fdms.zimra.co.zw";
  static String generateQrUrl(
    ItemReceitModel receipt, {
    bool isTest = false,
    String? qrUrlFromConfig,
  }) {
    final prebuilt = receipt.zimraQrCodeUrl?.trim();
    if (prebuilt != null && prebuilt.isNotEmpty) {
      return prebuilt;
    }

    final qrUrl = _normalizeQrBase(
      (qrUrlFromConfig != null && qrUrlFromConfig.trim().isNotEmpty)
          ? qrUrlFromConfig
          : (isTest
              ? "https://fdmstest.zimra.co.zw/"
              : "https://fdms.zimra.co.zw/"),
    );

    final deviceId =
        receipt.zimraDeviceId?.toString().padLeft(10, '0') ?? "0000000000";
    final receiptDate = _qrDateForReceipt(receipt);
    final globalNo =
        receipt.zimraReceiptGlobalNo?.toString().padLeft(10, '0') ??
        "0000000000";

    final rawSignature = receipt.zimraSignature ?? "";
    final receiptQrData = _calculateReceiptQrData(rawSignature);

    // ZIMRA §11: qrUrl/ + deviceId(10) + ddMMyyyy(8) + globalNo(10) + qrData(16)
    return "$qrUrl$deviceId$receiptDate$globalNo$receiptQrData";
  }

  static String _normalizeQrBase(String url) {
    var u = url.trim();
    if (!u.endsWith('/')) {
      u = '$u/';
    }
    return u;
  }

  /// Must match FDMS `receiptDate` (Africa/Harare calendar day) from SubmitReceipt.
  static String _qrDateForReceipt(ItemReceitModel receipt) {
    final stored = receipt.zimraReceiptDateQr;
    if (stored != null && RegExp(r'^\d{8}$').hasMatch(stored)) {
      return stored;
    }
    return _harareDdMmYyyy(receipt.createdAt);
  }

  /// Zimbabwe (Africa/Harare) is UTC+2 year-round — match server SubmitReceipt date.
  static String _harareDdMmYyyy(DateTime dt) {
    final utc = dt.toUtc();
    final harare = utc.add(const Duration(hours: 2));
    return DateFormat('ddMMyyyy').format(
      DateTime.utc(harare.year, harare.month, harare.day),
    );
  }

  static String _calculateReceiptQrData(String signature) {
    if (signature.isEmpty) return "0000000000000000";
    try {
      final decodedBytes = base64Decode(signature);
      // ZIMRA expects the MD5 hash of the RAW signature bytes, formatted as a hex string
      final md5Hash = md5.convert(decodedBytes).toString().toUpperCase();
      return md5Hash.substring(0, 16);
    } catch (e) {
      return "0000000000000000";
    }
  }

  static String extractVerificationCode(String signature) {
    final code = _calculateReceiptQrData(signature);
    if (code == "0000000000000000") return "";
    return code
        .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}-")
        .replaceAll(RegExp(r"-$"), "");
  }
}
