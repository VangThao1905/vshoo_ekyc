class EkycConfig {
  /// Base URL của backend riêng (liveness, face-match, v.v.)
  final String baseUrl;
  final String apiKey;
  final String sessionId;

  /// API key của FPT.AI — dùng riêng cho OCR card recognition
  final String fptApiKey;

  const EkycConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.sessionId,
    required this.fptApiKey,
  });
}
