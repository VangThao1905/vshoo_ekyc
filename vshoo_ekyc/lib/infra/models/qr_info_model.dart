import '../../domain/entities/qr_info.dart';

class QrInfoModel {
  final String rawData;
  final String? fullName;
  final String? cardNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  const QrInfoModel({
    required this.rawData,
    this.fullName,
    this.cardNumber,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  factory QrInfoModel.fromJson(Map<String, dynamic> json) => QrInfoModel(
        rawData: json['raw_data'] as String? ?? '',
        fullName: json['full_name'] as String?,
        cardNumber: json['card_number'] as String?,
        dateOfBirth: json['date_of_birth'] as String?,
        gender: json['gender'] as String?,
        address: json['address'] as String?,
      );

  QrInfo toDomain() => QrInfo(
        rawData: rawData,
        fullName: fullName,
        cardNumber: cardNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: address,
      );
}
