import 'package:fpdart/fpdart.dart';
import '../../domain/entities/qr_info.dart';
import '../../domain/failures/ekyc_failure.dart';
import '../../domain/repositories/ekyc_repository.dart';

class ScanQrUsecase {
  final EkycRepository _repository;

  const ScanQrUsecase(this._repository);

  Future<Either<EkycFailure, QrInfo>> call(String rawData) {
    return _repository.parseQrCode(rawData);
  }
}
