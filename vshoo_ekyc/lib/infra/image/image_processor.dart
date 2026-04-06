import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessor {
  Future<Uint8List> cropAndCompress(Uint8List raw) async {
    final image = img.decodeImage(raw);
    if (image == null) return raw;
    final compressed = img.encodeJpg(image, quality: 85);
    return Uint8List.fromList(compressed);
  }
}
