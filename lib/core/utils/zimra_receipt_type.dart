import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mistpos/data/models/item_receit_model.dart';

/// ZIMRA FDMS receipt types (Gateway API v7.2 §5.4.6).
enum ZimraReceiptKind { fiscalInvoice, creditNote, debitNote }

class ZimraReceiptDisplay {
  static ZimraReceiptKind kindOf(ItemReceitModel receipt) {
    switch (receipt.receiptType) {
      case 'CreditNote':
        return ZimraReceiptKind.creditNote;
      case 'DebitNote':
        return ZimraReceiptKind.debitNote;
      default:
        return ZimraReceiptKind.fiscalInvoice;
    }
  }

  static bool isCreditNote(ItemReceitModel receipt) =>
      kindOf(receipt) == ZimraReceiptKind.creditNote;

  static bool isDebitNote(ItemReceitModel receipt) =>
      kindOf(receipt) == ZimraReceiptKind.debitNote;

  static bool isAdjustment(ItemReceitModel receipt) =>
      isCreditNote(receipt) || isDebitNote(receipt);

  static String documentTitle(ItemReceitModel receipt) {
    switch (kindOf(receipt)) {
      case ZimraReceiptKind.creditNote:
        return 'Credit note';
      case ZimraReceiptKind.debitNote:
        return 'Debit note';
      case ZimraReceiptKind.fiscalInvoice:
        return 'Fiscal invoice';
    }
  }

  static String appBarTitle(ItemReceitModel receipt) {
    final prefix = documentTitle(receipt);
    return '$prefix #${receipt.label}';
  }

  /// Printed header (aligned with ZIMRA §10 receipt views).
  static String printHeader(ItemReceitModel receipt) {
    switch (kindOf(receipt)) {
      case ZimraReceiptKind.creditNote:
        return '*** FISCAL CREDIT NOTE ***';
      case ZimraReceiptKind.debitNote:
        return '*** FISCAL DEBIT NOTE ***';
      case ZimraReceiptKind.fiscalInvoice:
        return '*** FISCAL TAX INVOICE ***';
    }
  }

  static Color accentColor(ZimraReceiptKind kind) {
    switch (kind) {
      case ZimraReceiptKind.creditNote:
        return Colors.deepOrange;
      case ZimraReceiptKind.debitNote:
        return Colors.indigo;
      case ZimraReceiptKind.fiscalInvoice:
        return Colors.teal;
    }
  }

  static String listBadgeLabel(ItemReceitModel receipt) {
    switch (kindOf(receipt)) {
      case ZimraReceiptKind.creditNote:
        return 'CREDIT NOTE';
      case ZimraReceiptKind.debitNote:
        return 'DEBIT NOTE';
      case ZimraReceiptKind.fiscalInvoice:
        return receipt.fiscalized ? 'FISCAL' : 'INVOICE';
    }
  }

  static String listTypeShort(ItemReceitModel receipt) {
    switch (kindOf(receipt)) {
      case ZimraReceiptKind.creditNote:
        return 'CN';
      case ZimraReceiptKind.debitNote:
        return 'DN';
      case ZimraReceiptKind.fiscalInvoice:
        return 'INV';
    }
  }

  /// Iconify asset id for list leading avatar.
  static String listIconifyAsset(ZimraReceiptKind kind) {
    switch (kind) {
      case ZimraReceiptKind.creditNote:
        return Mdi.receipt_text_minus_outline;
      case ZimraReceiptKind.debitNote:
        return Mdi.receipt_text_plus_outline;
      case ZimraReceiptKind.fiscalInvoice:
        return Carbon.receipt;
    }
  }

  static String? linkedInvoiceLabel(ItemReceitModel receipt) {
    if (receipt.label.startsWith('CN-')) {
      return receipt.label.substring(3);
    }
    if (receipt.label.startsWith('DN-')) {
      return receipt.label.substring(3);
    }
    return null;
  }

  static String listSubtitle(ItemReceitModel receipt) {
    final time =
        '${receipt.createdAt.hour.toString().padLeft(2, '0')}:${receipt.createdAt.minute.toString().padLeft(2, '0')}';
    final linked = linkedInvoiceLabel(receipt);
    switch (kindOf(receipt)) {
      case ZimraReceiptKind.creditNote:
        return linked != null
            ? '$time • Refund for invoice #$linked'
            : '$time • Refund / return';
      case ZimraReceiptKind.debitNote:
        return linked != null
            ? '$time • Additional charge on #$linked'
            : '$time • Additional charge';
      case ZimraReceiptKind.fiscalInvoice:
        final n = receipt.items.length;
        return '$time • $n ${n == 1 ? 'item' : 'items'} • ${receipt.payment}';
    }
  }

  static Color amountColor(ZimraReceiptKind kind, {required bool creditSale}) {
    if (creditSale) return Colors.red.shade400;
    switch (kind) {
      case ZimraReceiptKind.creditNote:
        return Colors.deepOrange.shade700;
      case ZimraReceiptKind.debitNote:
        return Colors.indigo.shade700;
      case ZimraReceiptKind.fiscalInvoice:
        return Colors.teal.shade700;
    }
  }
}
