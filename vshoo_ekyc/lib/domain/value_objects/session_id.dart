import 'dart:math';

class SessionId {
  final String value;

  const SessionId._(this.value);

  factory SessionId(String value) {
    assert(value.isNotEmpty, 'SessionId không được trống');
    return SessionId._(value);
  }

  factory SessionId.generate() {
    final rand = Random.secure();
    final bytes = List.generate(16, (_) => rand.nextInt(256));
    return SessionId._(bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join());
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SessionId && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
