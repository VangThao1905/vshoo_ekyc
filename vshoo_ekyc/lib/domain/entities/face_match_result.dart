import '../value_objects/similarity_score.dart';

class FaceMatchResult {
  final SimilarityScore score;
  final String confidence; // "high" | "medium" | "low"

  const FaceMatchResult({required this.score, required this.confidence});
}
