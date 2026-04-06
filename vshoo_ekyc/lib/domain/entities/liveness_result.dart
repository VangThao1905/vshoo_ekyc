class LivenessResult {
  final bool isLive;
  final double confidence;
  final String? message;

  const LivenessResult({
    required this.isLive,
    required this.confidence,
    this.message,
  });
}
