import 'dart:io';
import 'dart:math' as math;

import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/data/models/tax_model.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:image/image.dart' as img;
import 'package:pos_universal_printer/pos_universal_printer.dart';

class OfflinePrinter {
  static void printLogo(AppSettingsModel model, EscPosBuilder b) {
    if (model.receitLogoPath.isNotEmpty) {
      final rasterBytes = getRasterImage(model.receitLogoPath);
      if (rasterBytes != null) {
        b.feed(1);
        b.raster(rasterBytes);
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
          padRight(
            itemName.length > (receitWidth - totalStr.length - 2)
                ? '${itemName.substring(0, receitWidth - totalStr.length - 4)}..'
                : itemName,
            receitWidth - totalStr.length,
          ) +
          totalStr;
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
      final decoded = img.decodeImage(imageBytes);
      if (decoded == null) return null;
      return _imageToRaster(decoded);
    } catch (_) {
      return null;
    }
  }

  static List<int> _imageToRaster(img.Image image) {
    img.Image resized = image;
    if (image.width > 384) {
      resized = img.copyResize(image, width: 384);
    }

    final int widthPx = resized.width;
    final int heightPx = resized.height;
    final int widthBytes = (widthPx + 7) ~/ 8;

    final List<int> bytes = [];
    
    // GS v 0 command (raster bit image)
    bytes.addAll([0x1D, 0x76, 0x30, 0x00]); 
    bytes.add(widthBytes % 256);
    bytes.add(widthBytes ~/ 256);
    bytes.add(heightPx % 256);
    bytes.add(heightPx ~/ 256);

    for (int y = 0; y < heightPx; y++) {
      for (int x = 0; x < widthBytes; x++) {
        int byte = 0;
        for (int b = 0; b < 8; b++) {
          final int px = x * 8 + b;
          if (px < widthPx) {
            final pixel = resized.getPixel(px, y);
            final luminance = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b);
            if (luminance < 128 && pixel.a > 0) {
              byte |= (1 << (7 - b));
            }
          }
        }
        bytes.add(byte);
      }
    }
    return bytes;
  }
}
