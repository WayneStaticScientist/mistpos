import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/data/models/tax_model.dart';

/// Checkout tax math aligned with ZIMRA tax-inclusive receipts (FDMS v7.2 §4.7).
class SalesTaxCalculator {
  /// Tax amount for a line or basket base at [ratePercent].
  static double taxAmountFromBase({
    required double base,
    required double ratePercent,
    required bool pricesIncludeTax,
  }) {
    if (ratePercent <= 0 || base <= 0) return 0;
    if (pricesIncludeTax) {
      return (base * ratePercent / (100 + ratePercent));
    }
    return base * ratePercent / 100;
  }

  static double _lineBase(
    Map<String, dynamic> cartRow,
    TaxModel tax,
  ) {
    final model = cartRow['item'] as ItemModel;
    final count = (cartRow['count'] as num?)?.toDouble() ?? 0;
    if (count <= 0) return 0;
    final addenum = (cartRow['addenum'] as num?)?.toDouble() ?? 0;
    final qouted = (cartRow['qouted'] as num?)?.toDouble() ?? 0;
    final wholesaleActivated = model.wholesaleActivated;
    final miniItems = model.miniItems;
    final unit = wholesaleActivated && count >= miniItems.toDouble()
        ? model.wholesalePrice
        : model.price + qouted;
    var line = count * (unit + addenum);
    if (cartRow['discountId'] != null) {
      final discount = (cartRow['discount'] as num?)?.toDouble() ?? 0;
      final pct = cartRow['percentageDiscount'] as bool? ?? true;
      line = pct ? line * (1 - discount / 100) : line - discount;
    }
    return line;
  }

  static bool _taxAppliesToRow(Map<String, dynamic> cartRow, TaxModel tax) {
    if (!tax.activated) return false;
    if (tax.selectedIds.isEmpty) return true;
    final model = cartRow['item'];
    final hexId = model.hexId as String? ?? '';
    return tax.selectedIds.contains(hexId);
  }

  static double _taxBaseForRule({
    required TaxModel tax,
    required List<Map<String, dynamic>> checkOutItems,
    required double subtotalAfterDiscounts,
  }) {
    if (tax.selectedIds.isNotEmpty) {
      var base = 0.0;
      for (final row in checkOutItems) {
        if (_taxAppliesToRow(row, tax)) {
          base += _lineBase(row, tax);
        }
      }
      return base;
    }
    return subtotalAfterDiscounts;
  }

  /// VAT totals: [totalTaxAmount] for display; [customerTotal] adds only exclusive taxes.
  static ({double totalTaxAmount, double customerTotal}) resolveCheckout({
    required List<Map<String, dynamic>> checkOutItems,
    required List<TaxModel> taxes,
    required double subtotalAfterDiscounts,
  }) {
    var totalTax = 0.0;
    var exclusiveAdd = 0.0;
    for (final tax in taxes) {
      if (!tax.activated) continue;
      final base = _taxBaseForRule(
        tax: tax,
        checkOutItems: checkOutItems,
        subtotalAfterDiscounts: subtotalAfterDiscounts,
      );
      final amt = taxAmountFromBase(
        base: base,
        ratePercent: tax.value,
        pricesIncludeTax: tax.pricesIncludeTax,
      );
      totalTax += amt;
      if (!tax.pricesIncludeTax) {
        exclusiveAdd += amt;
      }
    }
    return (
      totalTaxAmount: totalTax,
      customerTotal: subtotalAfterDiscounts + exclusiveAdd,
    );
  }

  static double lineTaxForRow({
    required Map<String, dynamic> cartRow,
    required TaxModel tax,
  }) {
    if (!_taxAppliesToRow(cartRow, tax)) return 0;
    return taxAmountFromBase(
      base: _lineBase(cartRow, tax),
      ratePercent: tax.value,
      pricesIncludeTax: tax.pricesIncludeTax,
    );
  }

  /// Primary VAT rate sent on receipt for ZIMRA (highest active rate on sale).
  static double primaryTaxRatePercent(List<TaxModel> taxes) {
    double max = 0;
    for (final t in taxes) {
      if (t.activated && t.value > max) max = t.value;
    }
    return max;
  }
}
