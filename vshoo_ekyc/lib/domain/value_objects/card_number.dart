class CardNumber {
  final String value;

  CardNumber._(this.value);

  factory CardNumber(String value) {
    final cleaned = value.replaceAll(RegExp(r'\s+'), '');
    assert(cleaned.isNotEmpty, 'Card number không được trống');
    return CardNumber._(cleaned);
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CardNumber && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
