import 'package:fpdart/fpdart.dart';
import '../../domain/entities/liveness_result.dart';
import '../../domain/failures/ekyc_failure.dart';
import '../../domain/repositories/ekyc_repository.dart';
import '../dtos/face_capture_dto.dart';

class CheckLivenessUsecase {
  final EkycRepository _repository;

  const CheckLivenessUsecase(this._repository);

  Future<Either<EkycFailure, LivenessResult>> call(FaceCaptureDto dto) {
    return _repository.checkLiveness(dto.processedBytes);
  }
}
