import '../../domain/entities/ekyc_session.dart';
import '../../domain/failures/ekyc_failure.dart';

enum EkycStep { instruction, captureFront, captureQr, captureBack, captureFace, result }

sealed class EkycState {
  final EkycStep step;
  final EkycSession session;
  const EkycState({required this.step, required this.session});
}

class EkycIdle extends EkycState {
  const EkycIdle({required super.step, required super.session});
}

class EkycLoading extends EkycState {
  final String message;
  const EkycLoading({
    required super.step,
    required super.session,
    required this.message,
  });
}

class EkycStepSuccess extends EkycState {
  const EkycStepSuccess({required super.step, required super.session});
}

class EkycStepFailure extends EkycState {
  final EkycFailure failure;
  const EkycStepFailure({
    required super.step,
    required super.session,
    required this.failure,
  });
}

class EkycCompleted extends EkycState {
  const EkycCompleted({required super.session})
      : super(step: EkycStep.result);
}
