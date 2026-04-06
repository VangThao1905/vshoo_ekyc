sealed class EkycFailure {
  final String message;
  const EkycFailure(this.message);
}

class NetworkFailure extends EkycFailure {
  const NetworkFailure(super.message);
}

class OcrFailure extends EkycFailure {
  const OcrFailure(super.message);
}

class LivenessFailure extends EkycFailure {
  const LivenessFailure(super.message);
}

class FaceMatchFailure extends EkycFailure {
  const FaceMatchFailure(super.message);
}

class CameraFailure extends EkycFailure {
  const CameraFailure(super.message);
}
