import '../../domain/entities/face_match_result.dart';
import '../../domain/value_objects/similarity_score.dart';

class FaceMatchResultModel {
  final double similarityScore;
  final String confidence;

  const FaceMatchResultModel({
    required this.similarityScore,
    required this.confidence,
  });

  factory FaceMatchResultModel.fromJson(Map<String, dynamic> json) =>
      FaceMatchResultModel(
        similarityScore: (json['similarity_score'] as num).toDouble(),
        confidence: json['confidence'] as String,
      );

  FaceMatchResult toDomain() => FaceMatchResult(
        score: SimilarityScore(similarityScore),
        confidence: confidence,
      );
}
