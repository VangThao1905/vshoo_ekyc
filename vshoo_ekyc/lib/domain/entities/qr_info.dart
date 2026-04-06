class QrInfo {
  final String rawData;
  final String? fullName;
  final String? cardNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  const QrInfo({
    required this.rawData,
    this.fullName,
    this.cardNumber,
    this.dateOfBirth,
    this.gender,
    this.address,
  });
}
