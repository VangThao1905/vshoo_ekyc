import 'package:fpdart/fpdart.dart';
import '../../domain/entities/card_info.dart';
import '../../domain/failures/ekyc_failure.dart';
import '../../domain/repositories/ekyc_repository.dart';
import '../dtos/card_capture_dto.dart';

class UploadFrontCardUsecase {
  final EkycRepository _repository;

  const UploadFrontCardUsecase(this._repository);

  Future<Either<EkycFailure, CardInfo>> call(CardCaptureDto dto) {
    return _repository.uploadFrontCard(dto.processedBytes);
  }
}
