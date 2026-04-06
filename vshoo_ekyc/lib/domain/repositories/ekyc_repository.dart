import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../entities/card_info.dart';
import '../entities/qr_info.dart';
import '../entities/liveness_result.dart';
import '../entities/face_match_result.dart';
import '../failures/ekyc_failure.dart';

abstract interface class EkycRepository {
  Future<Either<EkycFailure, CardInfo>> uploadFrontCard(Uint8List imageBytes);
  Future<Either<EkycFailure, QrInfo>> parseQrCode(String rawData);
  Future<Either<EkycFailure, CardInfo>> uploadBackCard(Uint8List imageBytes);
  Future<Either<EkycFailure, LivenessResult>> checkLiveness(Uint8List faceBytes);
  Future<Either<EkycFailure, FaceMatchResult>> matchFace({
    required Uint8List faceFromCard,
    required Uint8List faceFromLiveness,
  });
}
