import 'dart:typed_data';

class CardCaptureDto {
  final Uint8List processedBytes;
  const CardCaptureDto({required this.processedBytes});
}
