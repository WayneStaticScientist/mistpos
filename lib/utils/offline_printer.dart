import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';

class OfflinePrinter {
  static void printLogo(AppSettingsModel model, EscPosBuilder b) {
    if (model.receitLogoPath.isNotEmpty) {
      final rasterImage = getRasterImage(model.receitLogoPath);
      if (rasterImage != null) {
        b.feed(1);
        b.raster(rasterImage);
        b.feed(1);
      }
    }
  }

  static void printReceitItems({
    required AppSettingsModel model,
    required EscPosBuilder b,
    required ItemReceitModel itemReceitModel,
    required User user,
    required List<TaxModel> salesTaxes,
  }) {
    int receitWidth = model.printerRecietLength;
    String padRight(String text, int length) => text.padRight(length, ' ');
    for (final item in itemReceitModel.items) {
      log("printing ${item.name}");
      final itemPrice = item.addenum + item.price;
      final totalItemPrice = itemPrice * item.count;
      final totalStr = CurrenceConverter.getCurrenceFloatInStrings(
        totalItemPrice,
        user.baseCurrence,
      );
      final itemName = item.name.substring(
        0,
        math.min(item.name.length, (receitWidth * 0.65).toInt()),
      );
      String label =
          padRight(itemName, receitWidth - totalStr.length) + totalStr;
      b.text(label);
      final unitPriceStr = CurrenceConverter.getCurrenceFloatInStrings(
        itemPrice,
        user.baseCurrence,
      );
      String priceModel = "${item.count} x $unitPriceStr";
      if (item.discount > 0 && item.discountId != null) {
        priceModel +=
            " - ${(item.percentageDiscount ? '${item.discount}%' : CurrenceConverter.getCurrenceFloatInStrings(item.discount, user.baseCurrence))}";
      }
      b.text(priceModel);
      if (item.refunded) {
        String refundModel = "refund  ${item.originalCount} ->  ${item.count}";
        b.text(refundModel);
      }
    }
    // --- SEPARATOR ---
    b.text('.' * receitWidth);
    b.feed(1);
    final totalDueStr = CurrenceConverter.getCurrenceFloatInStrings(
      itemReceitModel.total,
      user.baseCurrence,
    );
    final changeStr = CurrenceConverter.getCurrenceFloatInStrings(
      itemReceitModel.change,
      user.baseCurrence,
    );

    if (itemReceitModel.discounts.isNotEmpty) {
      b.feed(1);
      b.text('--- DISCOUNTS ---', align: PosAlign.center, bold: true);
      b.feed(1);
      for (final discount in itemReceitModel.discounts) {
        final discountStr = discount.percentageDiscount == false
            ? CurrenceConverter.getCurrenceFloatInStrings(
                discount.discount ?? 0.0,
                user.baseCurrence,
              )
            : '${discount.discount}%';
        String label = '${discount.name ?? '-no=name-'} - $discountStr';
        b.text(label);
      }
    }
    if (salesTaxes.isNotEmpty) {
      b.feed(1);
      b.text('--- Taxes ---', align: PosAlign.center, bold: true);
      b.feed(1);
      for (final tax in salesTaxes) {
        final taxString = '${tax.value}%';
        String label = '${tax.label} - $taxString';
        b.text(label);
      }
    }
    final totalLine =
        padRight('TOTAL DUE:', receitWidth - totalDueStr.length) + totalDueStr;
    b.text(totalLine, bold: true);
    final change =
        padRight('CHANGE:', receitWidth - changeStr.length) + changeStr;
    b.text(change, bold: true);
    b.feed(2);
    b.text('.' * receitWidth);
  }

  static List<int>? getRasterImage(String receitLogoPath) {
    try {
      final imageBytes = File(receitLogoPath).readAsBytesSync();
      return imageBytes;
    } catch (_) {
      return null;
    }
  }
}
