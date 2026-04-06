class SimilarityScore {
  final double value;

  static const double kMatchThreshold = 0.75;

  SimilarityScore._(this.value);

  factory SimilarityScore(double value) {
    assert(value >= 0 && value <= 1, 'Score phải trong khoảng 0–1');
    return SimilarityScore._(value);
  }

  bool get isMatched => value >= kMatchThreshold;
  String get asPercent => '${(value * 100).toStringAsFixed(1)}%';
}
