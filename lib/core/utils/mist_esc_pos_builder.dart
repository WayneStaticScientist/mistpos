import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

/// Local ESC/POS builder (same API as pos_universal_printer) with a corrected
/// [qrCode] sequence — the published package sends store/print in the wrong order.
enum PosAlign { left, center, right }

class EscPosBuilder {
  final List<int> _bytes = <int>[];

  void init() {
    _bytes.addAll([0x1B, 0x40]);
  }

  void text(String text, {PosAlign align = PosAlign.left, bool bold = false}) {
    setAlign(align);
    if (bold) {
      _bytes.addAll([0x1B, 0x45, 0x01]);
    }
    _bytes.addAll(utf8.encode(text));
    _bytes.add(0x0A);
    if (bold) {
      _bytes.addAll([0x1B, 0x45, 0x00]);
    }
  }

  void setAlign(PosAlign align) {
    final n = switch (align) {
      PosAlign.center => 1,
      PosAlign.right => 2,
      PosAlign.left => 0,
    };
    _bytes.addAll([0x1B, 0x61, n]);
  }

  void feed(int lines) {
    if (lines <= 0) return;
    _bytes.addAll([0x1B, 0x64, lines]);
  }

  void cut() {
    _bytes.addAll([0x1D, 0x56, 0x42, 0x00]);
  }

  void barcode(String data) {
    final bytes = utf8.encode(data);
    _bytes.addAll([0x1D, 0x68, 0x50]);
    _bytes.addAll([0x1D, 0x6B, 0x49, bytes.length]);
    _bytes.addAll(bytes);
  }

  /// Native thermal QR (ESC/POS model 2) via esc_pos_utils_plus command order.
  void qrCode(String data) {
    if (data.isEmpty) return;
    final qr = QRCode(data, QRSize.size4, QRCorrection.M);
    _bytes.addAll(qr.bytes);
  }

  void raster(List<int> bitmap) {
    _bytes.addAll(bitmap);
  }

  List<int> build() => List<int>.from(_bytes);
}

class EscPosHelper {
  static List<int> openDrawer({int m = 0, int t1 = 25, int t2 = 250}) {
    return [0x1B, 0x70, m, t1, t2];
  }
}
