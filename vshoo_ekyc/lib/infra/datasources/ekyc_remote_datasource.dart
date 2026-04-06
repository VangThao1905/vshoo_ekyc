import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/card_info_model.dart';
import '../models/qr_info_model.dart';
import '../models/liveness_result_model.dart';
import '../models/face_match_result_model.dart';
import 'ekyc_config.dart';
import 'ekyc_constants.dart';

/// Exception nội bộ để carry FPT.AI errorCode lên repository.
class FptApiException implements Exception {
  final int errorCode;
  final String errorMessage;
  const FptApiException(this.errorCode, this.errorMessage);

  @override
  String toString() => 'FptApiException($errorCode): $errorMessage';
}

class EkycRemoteDatasource {
  /// Dio dành cho FPT.AI OCR — base URL và headers khác hoàn toàn.
  final Dio _fptDio;

  /// Dio dành cho backend riêng (liveness, face-match).
  final Dio _backendDio;

  EkycRemoteDatasource(EkycConfig config)
      : _fptDio = Dio(BaseOptions(
          baseUrl: EkycConstants.fptBaseUrl,
          headers: {'api-key': config.fptApiKey},
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        )),
        _backendDio = Dio(BaseOptions(
          baseUrl: config.baseUrl,
          headers: {
            'Authorization': 'Bearer ${config.apiKey}',
            'X-Session-Id': config.sessionId,
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  // ── Card OCR (FPT.AI) ─────────────────────────────────────────

  /// Upload ảnh CCCD lên FPT.AI và trả về model parse từ data[0].
  /// [side] chỉ dùng để đặt tên file ('front' | 'back') cho readability.
  Future<CardInfoModel> uploadCard(Uint8List bytes, String side) async {
    final res = await _fptDio.post(
      EkycConstants.fptCardOcrPath,
      data: FormData.fromMap({
        'image': MultipartFile.fromBytes(bytes, filename: '$side.jpg'),
      }),
    );

    final body = res.data as Map<String, dynamic>;
    _assertFptSuccess(body);

    final dataList = body['data'] as List<dynamic>;
    if (dataList.isEmpty) {
      throw const FptApiException(3, 'Không tìm thấy CCCD trong ảnh');
    }

    return CardInfoModel.fromFptJson(dataList[0] as Map<String, dynamic>);
  }

  /// Kiểm tra errorCode từ FPT.AI, ném FptApiException nếu có lỗi.
  void _assertFptSuccess(Map<String, dynamic> body) {
    final errorCode = (body['errorCode'] as num?)?.toInt() ?? -1;
    if (errorCode != 0) {
      final msg = _fptErrorMessage(errorCode, body['errorMessage'] as String?);
      throw FptApiException(errorCode, msg);
    }
  }

  String _fptErrorMessage(int code, String? raw) {
    return switch (code) {
      1 => 'Tham số không hợp lệ, vui lòng thử lại',
      2 => 'Ảnh CCCD bị thiếu góc, không thể nhận diện',
      3 => 'Không tìm thấy CCCD trong ảnh hoặc ảnh quá mờ/tối',
      7 => 'File không phải ảnh hợp lệ',
      8 => 'File ảnh bị hỏng hoặc định dạng không được hỗ trợ',
      _ => raw?.isNotEmpty == true ? raw! : 'Lỗi OCR (code $code)',
    };
  }

  // ── QR Code ───────────────────────────────────────────────────

  Future<QrInfoModel> parseQr(String rawData) async {
    final res = await _backendDio.post(
      '/v1/ocr/qr',
      data: {'raw_data': rawData},
    );
    return QrInfoModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  // ── Liveness ──────────────────────────────────────────────────

  Future<LivenessResultModel> checkLiveness(Uint8List bytes) async {
    final res = await _backendDio.post(
      '/v1/liveness',
      data: FormData.fromMap({
        'image': MultipartFile.fromBytes(bytes, filename: 'selfie.jpg'),
      }),
    );
    return LivenessResultModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  // ── Face Match ────────────────────────────────────────────────

  Future<FaceMatchResultModel> matchFace(Uint8List face1, Uint8List face2) async {
    final res = await _backendDio.post(
      '/v1/face-match',
      data: FormData.fromMap({
        'face1': MultipartFile.fromBytes(face1, filename: 'face_card.jpg'),
        'face2': MultipartFile.fromBytes(face2, filename: 'face_live.jpg'),
      }),
    );
    return FaceMatchResultModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}
