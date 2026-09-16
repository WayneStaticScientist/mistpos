import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ZimraHelper {
  static String manualZimraUrl = "https://fdms.zimra.co.zw";
  static String generateQrUrl(ItemReceitModel receipt, {bool isTest = false}) {
    final qrUrl = isTest
        ? "https://fdmstest.zimra.co.zw"
        : "https://fdms.zimra.co.zw";

    final deviceId =
        receipt.zimraDeviceId?.toString().padLeft(10, '0') ?? "0000000000";
    final receiptDate = DateFormat('ddMMyyyy').format(receipt.createdAt);
    final globalNo =
        receipt.zimraReceiptGlobalNo?.toString().padLeft(10, '0') ??
        "0000000000";

    // 1. Extract the raw signature
    final rawSignature = receipt.zimraSignature ?? "";
    String receiptQrData = _calculateReceiptQrData(rawSignature);

    // 3. Construct the exact URL structure requested by ZIMRA (No fiscalDayNo)
    return "$qrUrl/$deviceId$receiptDate$globalNo$receiptQrData";
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
