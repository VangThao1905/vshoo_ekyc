import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ekyc_session.dart';
import '../../domain/failures/ekyc_failure.dart';
import '../../domain/value_objects/session_id.dart';
import '../../infra/image/image_processor.dart';
import '../dtos/card_capture_dto.dart';
import '../dtos/face_capture_dto.dart';
import '../use_cases/upload_front_card_usecase.dart';
import '../use_cases/scan_qr_usecase.dart';
import '../use_cases/upload_back_card_usecase.dart';
import '../use_cases/check_liveness_usecase.dart';
import '../use_cases/match_face_usecase.dart';
import 'ekyc_state.dart';

class EkycCubit extends Cubit<EkycState> {
  final UploadFrontCardUsecase _uploadFront;
  final ScanQrUsecase _scanQr;
  final UploadBackCardUsecase _uploadBack;
  final CheckLivenessUsecase _checkLiveness;
  final MatchFaceUsecase _matchFace;
  final ImageProcessor _imageProcessor;

  EkycCubit({
    required UploadFrontCardUsecase uploadFront,
    required ScanQrUsecase scanQr,
    required UploadBackCardUsecase uploadBack,
    required CheckLivenessUsecase checkLiveness,
    required MatchFaceUsecase matchFace,
    required ImageProcessor imageProcessor,
    required SessionId sessionId,
  })  : _uploadFront = uploadFront,
        _scanQr = scanQr,
        _uploadBack = uploadBack,
        _checkLiveness = checkLiveness,
        _matchFace = matchFace,
        _imageProcessor = imageProcessor,
        super(EkycIdle(
          step: EkycStep.instruction,
          session: EkycSession(sessionId: sessionId),
        ));

  // ── Navigation ────────────────────────────────────────────────
  void startFlow() => _emitIdle(EkycStep.captureFront);

  void _nextStep() {
    final steps = EkycStep.values;
    final currentIndex = steps.indexOf(state.step);
    if (currentIndex < steps.length - 1) {
      _emitIdle(steps[currentIndex + 1]);
    }
  }

  void _emitIdle(EkycStep step) =>
      emit(EkycIdle(step: step, session: state.session));

  // ── Use case calls ────────────────────────────────────────────
  Future<void> onFrontCardCaptured(Uint8List rawBytes) async {
    emit(EkycLoading(
      step: state.step,
      session: state.session,
      message: 'Đang nhận diện mặt trước CCCD...',
    ));

    final processed = await _imageProcessor.cropAndCompress(rawBytes);
    final result = await _uploadFront(CardCaptureDto(processedBytes: processed));

    result.fold(
      (failure) => emit(EkycStepFailure(
        step: state.step,
        session: state.session,
        failure: failure,
      )),
      (cardInfo) {
        state.session.frontCard = cardInfo;
        emit(EkycStepSuccess(step: state.step, session: state.session));
        _nextStep();
      },
    );
  }

  Future<void> onQrScanned(String rawData) async {
    emit(EkycLoading(
      step: state.step,
      session: state.session,
      message: 'Đang xử lý mã QR...',
    ));

    final result = await _scanQr(rawData);

    result.fold(
      (failure) => emit(EkycStepFailure(
        step: state.step,
        session: state.session,
        failure: failure,
      )),
      (qrInfo) {
        state.session.qrInfo = qrInfo;
        emit(EkycStepSuccess(step: state.step, session: state.session));
        _nextStep();
      },
    );
  }

  Future<void> onBackCardCaptured(Uint8List rawBytes) async {
    emit(EkycLoading(
      step: state.step,
      session: state.session,
      message: 'Đang nhận diện mặt sau CCCD...',
    ));

    final processed = await _imageProcessor.cropAndCompress(rawBytes);
    final result = await _uploadBack(CardCaptureDto(processedBytes: processed));

    result.fold(
      (failure) => emit(EkycStepFailure(
        step: state.step,
        session: state.session,
        failure: failure,
      )),
      (cardInfo) {
        state.session.backCard = cardInfo;
        emit(EkycStepSuccess(step: state.step, session: state.session));
        _nextStep();
      },
    );
  }

  Future<void> onFaceCaptured(Uint8List rawBytes) async {
    emit(EkycLoading(
      step: state.step,
      session: state.session,
      message: 'Đang kiểm tra liveness...',
    ));

    final processed = await _imageProcessor.cropAndCompress(rawBytes);
    final livenessResult = await _checkLiveness(FaceCaptureDto(processedBytes: processed));

    await livenessResult.fold(
      (failure) async => emit(EkycStepFailure(
        step: state.step,
        session: state.session,
        failure: failure,
      )),
      (liveness) async {
        state.session.livenessResult = liveness;

        if (!liveness.isLive) {
          emit(EkycStepFailure(
            step: state.step,
            session: state.session,
            failure: const LivenessFailure('Không phát hiện khuôn mặt thật'),
          ));
          return;
        }

        emit(EkycLoading(
          step: state.step,
          session: state.session,
          message: 'Đang so khớp khuôn mặt...',
        ));

        final faceOnCard = state.session.frontCard?.faceOnCard;
        if (faceOnCard == null) {
          emit(EkycStepFailure(
            step: state.step,
            session: state.session,
            failure: const OcrFailure('Không tìm thấy ảnh khuôn mặt trên CCCD'),
          ));
          return;
        }

        final matchResult = await _matchFace(
          faceFromCard: faceOnCard,
          faceFromLiveness: processed,
        );

        matchResult.fold(
          (failure) => emit(EkycStepFailure(
            step: state.step,
            session: state.session,
            failure: failure,
          )),
          (faceMatch) {
            state.session.faceMatchResult = faceMatch;
            emit(EkycCompleted(session: state.session));
          },
        );
      },
    );
  }

  void retry() => _emitIdle(state.step);
}
