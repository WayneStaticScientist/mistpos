import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class EscPosBuilder {
  final Generator _generator;
  final List<int> _bytes = [];

  EscPosBuilder(this._generator);

  List<int> get bytes => _bytes;

  void text(String text, {PosAlign align = PosAlign.left, bool bold = false}) {
    _bytes.addAll(_generator.text(text, styles: PosStyles(align: align, bold: bold)));
  }

  void feed(int n) {
    _bytes.addAll(_generator.feed(n));
  }

  void cut() {
    _bytes.addAll(_generator.cut());
  }

  void qrCode(String text) {
    _bytes.addAll(_generator.qrcode(text));
  }

  void raster(List<int> rasterBytes) {
    // EscPosBuilder raster expects raw GS v 0 raster bytes
    _bytes.addAll(rasterBytes);
  }
}
