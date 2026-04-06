import 'card_info.dart';
import 'qr_info.dart';
import 'liveness_result.dart';
import 'face_match_result.dart';
import '../value_objects/session_id.dart';

class EkycSession {
  final SessionId sessionId;
  final DateTime startedAt;

  CardInfo? frontCard;
  QrInfo? qrInfo;
  CardInfo? backCard;
  LivenessResult? livenessResult;
  FaceMatchResult? faceMatchResult;

  EkycSession({required this.sessionId}) : startedAt = DateTime.now();

  bool get isVerified =>
      (livenessResult?.isLive ?? false) &&
      (faceMatchResult?.score.isMatched ?? false);
}
