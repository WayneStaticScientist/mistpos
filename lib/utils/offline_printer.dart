import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:mistpos/models/app_settings_model.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:mistpos/utils/esc_pos_builder.dart';

class OfflinePrinter {
  /// Prints the receipt logo. The image file is decoded and converted to
  /// ESC/POS raster bytes before sending, preventing raw file bytes from
  /// being printed as garbage characters.
  static Future<void> printLogo(AppSettingsModel model, EscPosBuilder b) async {
    if (model.receitLogoPath.isNotEmpty) {
      // Calculate pixel width: each receipt character ≈ 12 dots on 58mm paper
      final int maxPixelWidth = model.printerRecietLength * 12;
      final rasterBytes = await _getEscPosRasterImage(
        model.receitLogoPath,
        maxWidth: maxPixelWidth,
      );
      if (rasterBytes != null && rasterBytes.isNotEmpty) {
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

  /// Reads an image file and converts it to ESC/POS raster bytes (GS v 0).
  /// Decodes PNG/JPEG via dart:ui, converts to monochrome, and builds
  /// the proper ESC/POS raster command sequence.
  /// [maxWidth] controls the raster pixel width — derived from receipt char width.
  static Future<Uint8List?> _getEscPosRasterImage(
    String imagePath, {
    int maxWidth = 384,
  }) async {
    try {
      final imageBytes = File(imagePath).readAsBytesSync();
      final raw = Uint8List.fromList(imageBytes);

      // If already ESC/POS raster data (starts with GS v 0), pass through
      if (raw.length >= 4 &&
          raw[0] == 0x1D &&
          raw[1] == 0x76 &&
          raw[2] == 0x30) {
        return raw;
      }

      // Decode PNG/JPEG to pixel data using dart:ui
      final codec = await ui.instantiateImageCodec(raw);
      final frame = await codec.getNextFrame();
      final img = frame.image;

      // Scale to configured receipt width preserving aspect ratio
      final targetWidth = img.width > maxWidth ? maxWidth : img.width;
      final scale = targetWidth / img.width;
      final targetHeight = (img.height * scale).round();

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      canvas.scale(scale);
      canvas.drawImage(img, const ui.Offset(0, 0), ui.Paint());
      final picture = recorder.endRecording();
      final resized = await picture.toImage(targetWidth, targetHeight);
      final byteData =
          await resized.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return null;
      final pixels = byteData.buffer.asUint8List();

      // Build GS v 0 raster command: monochrome conversion
      const int threshold = 160;
      final bytes = <int>[];
      final widthBytes = (targetWidth + 7) ~/ 8; // Round up to byte boundary
      final xL = widthBytes % 256;
      final xH = widthBytes ~/ 256;
      final yL = targetHeight % 256;
      final yH = targetHeight ~/ 256;
      bytes.addAll([0x1D, 0x76, 0x30, 0x00, xL, xH, yL, yH]);

      for (int y = 0; y < targetHeight; y++) {
        for (int x = 0; x < targetWidth; x += 8) {
          int b = 0;
          for (int bit = 0; bit < 8; bit++) {
            final px = x + bit;
            bool isDark = false;
            if (px < targetWidth) {
              final idx = (y * targetWidth + px) * 4;
              final r = pixels[idx];
              final g = pixels[idx + 1];
              final bl = pixels[idx + 2];
              final lum = (0.299 * r + 0.587 * g + 0.114 * bl).round();
              if (lum < threshold) isDark = true;
            }
            b <<= 1;
            if (isDark) b |= 0x01;
          }
          bytes.add(b);
        }
      }

      return Uint8List.fromList(bytes);
    } catch (_) {
      return null;
    }
  }

  /// @deprecated Use _getEscPosRasterImage instead.
  /// Kept for backward compatibility but returns raw file bytes which
  /// should NOT be passed directly to raster().
  static List<int>? getRasterImage(String receitLogoPath) {
    try {
      final imageBytes = File(receitLogoPath).readAsBytesSync();
      return imageBytes;
    } catch (_) {
      return null;
    }
  }
}

