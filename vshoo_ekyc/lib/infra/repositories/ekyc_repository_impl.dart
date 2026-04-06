import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/card_info.dart';
import '../../domain/entities/qr_info.dart';
import '../../domain/entities/liveness_result.dart';
import '../../domain/entities/face_match_result.dart';
import '../../domain/failures/ekyc_failure.dart';
import '../../domain/repositories/ekyc_repository.dart';
import '../datasources/ekyc_remote_datasource.dart';

class EkycRepositoryImpl implements EkycRepository {
  final EkycRemoteDatasource _datasource;

  const EkycRepositoryImpl(this._datasource);

  @override
  Future<Either<EkycFailure, CardInfo>> uploadFrontCard(Uint8List bytes) async {
    try {
      final model = await _datasource.uploadCard(bytes, 'front');
      return Right(model.toDomain());
    } on FptApiException catch (e) {
      return Left(OcrFailure(e.errorMessage));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Lỗi mạng'));
    } catch (e) {
      return Left(OcrFailure('OCR mặt trước thất bại: $e'));
    }
  }

  @override
  Future<Either<EkycFailure, QrInfo>> parseQrCode(String rawData) async {
    try {
      final model = await _datasource.parseQr(rawData);
      return Right(model.toDomain());
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Lỗi mạng'));
    }
  }

  @override
  Future<Either<EkycFailure, CardInfo>> uploadBackCard(Uint8List bytes) async {
    try {
      final model = await _datasource.uploadCard(bytes, 'back');
      return Right(model.toDomain());
    } on FptApiException catch (e) {
      return Left(OcrFailure(e.errorMessage));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Lỗi mạng'));
    } catch (e) {
      return Left(OcrFailure('OCR mặt sau thất bại: $e'));
    }
  }

  @override
  Future<Either<EkycFailure, LivenessResult>> checkLiveness(Uint8List bytes) async {
    try {
      final model = await _datasource.checkLiveness(bytes);
      return Right(model.toDomain());
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Lỗi mạng'));
    } catch (e) {
      return Left(LivenessFailure('Liveness thất bại: $e'));
    }
  }

  @override
  Future<Either<EkycFailure, FaceMatchResult>> matchFace({
    required Uint8List faceFromCard,
    required Uint8List faceFromLiveness,
  }) async {
    try {
      final model = await _datasource.matchFace(faceFromCard, faceFromLiveness);
      return Right(model.toDomain());
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Lỗi mạng'));
    } catch (e) {
      return Left(FaceMatchFailure('So khớp thất bại: $e'));
    }
  }
}
