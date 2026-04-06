import '../../domain/entities/liveness_result.dart';

class LivenessResultModel {
  final bool isLive;
  final double confidence;
  final String? message;

  const LivenessResultModel({
    required this.isLive,
    required this.confidence,
    this.message,
  });

  factory LivenessResultModel.fromJson(Map<String, dynamic> json) =>
      LivenessResultModel(
        isLive: json['is_live'] as bool? ?? false,
        confidence: (json['confidence'] as num).toDouble(),
        message: json['message'] as String?,
      );

  LivenessResult toDomain() => LivenessResult(
        isLive: isLive,
        confidence: confidence,
        message: message,
      );
}
