import 'package:mistpos/core/utils/zimra_receipt_type.dart';
import 'package:mistpos/data/models/item_receit_model.dart';

/// Keeps credit/debit notes visually grouped under their original invoice in Sales.
class ReceiptListSort {
  static DateTime sortDate(
    ItemReceitModel receipt,
    Map<String, ItemReceitModel> byHexId,
  ) {
    if (ZimraReceiptDisplay.isAdjustment(receipt)) {
      final pid = receipt.originalReceiptId?.trim();
      if (pid != null && pid.isNotEmpty) {
        final parent = byHexId[pid];
        if (parent != null) {
          return parent.createdAt.subtract(const Duration(milliseconds: 1));
        }
      }
    }
    return receipt.createdAt;
  }

  static List<ItemReceitModel> orderForDisplay(List<ItemReceitModel> items) {
    final byHex = {
      for (final r in items)
        if (r.hexId.isNotEmpty) r.hexId: r,
    };
    final sorted = [...items]
      ..sort((a, b) {
        final cmp = sortDate(b, byHex).compareTo(sortDate(a, byHex));
        if (cmp != 0) return cmp;
        return b.hexId.compareTo(a.hexId);
      });
    return sorted;
  }
}
