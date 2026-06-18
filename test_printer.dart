import 'package:image/image.dart' as img;
void main() {
  final i = img.Image(width: 10, height: 10);
  final p = i.getPixel(0, 0);
  print(p.runtimeType);
}
