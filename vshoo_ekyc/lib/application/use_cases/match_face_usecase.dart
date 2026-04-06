import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/face_match_result.dart';
import '../../domain/failures/ekyc_failure.dart';
import '../../domain/repositories/ekyc_repository.dart';

class MatchFaceUsecase {
  final EkycRepository _repository;

  const MatchFaceUsecase(this._repository);

  Future<Either<EkycFailure, FaceMatchResult>> call({
    required Uint8List faceFromCard,
    required Uint8List faceFromLiveness,
  }) {
    return _repository.matchFace(
      faceFromCard: faceFromCard,
      faceFromLiveness: faceFromLiveness,
    );
  }
}
