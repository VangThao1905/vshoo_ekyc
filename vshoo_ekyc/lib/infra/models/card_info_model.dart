import 'dart:convert';
import 'dart:typed_data';
import '../../domain/entities/address_entities.dart';
import '../../domain/entities/card_info.dart';
import '../../domain/value_objects/card_number.dart';

/// Parse từ FPT.AI response: data[0]
/// Xử lý cả front side (old/new) và back side (old_back/new_back).
class CardInfoModel {
  // Front fields
  final String? id;
  final String? name;
  final String? dob;
  final String? sex;
  final String? nationality;
  final String? home;
  final String? address;
  final String? doe;
  final String? province;
  final String? district;
  final String? ward;
  final String? street;

  // Back fields
  final String? ethnicity;
  final String? religion;
  final String? features;
  final String? issueDate;
  final String? issueLocation;

  // Metadata
  final String? type;
  final String? typeNew;

  // Confidence — FPT trả prob dưới dạng string "0.99", lấy prob của id hoặc issue_date
  final double confidence;

  const CardInfoModel({
    this.id,
    this.name,
    this.dob,
    this.sex,
    this.nationality,
    this.home,
    this.address,
    this.doe,
    this.province,
    this.district,
    this.ward,
    this.street,
    this.ethnicity,
    this.religion,
    this.features,
    this.issueDate,
    this.issueLocation,
    this.type,
    this.typeNew,
    required this.confidence,
  });

  /// FPT trả field = "N/A" khi không có dữ liệu — normalize về null.
  static String? _nullable(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return (s.isEmpty || s == 'N/A') ? null : s;
  }

  static double _parseProb(dynamic v) {
    if (v == null) return 0;
    return double.tryParse(v.toString()) ?? 0;
  }

  factory CardInfoModel.fromFptJson(Map<String, dynamic> json) {
    final ae = json['address_entities'] as Map<String, dynamic>?;

    // Dùng prob của id (front) hoặc issue_date (back) làm đại diện confidence
    final conf = _parseProb(json['id_prob'] ?? json['issue_date_prob']);

    return CardInfoModel(
      id: _nullable(json['id']),
      name: _nullable(json['name']),
      dob: _nullable(json['dob']),
      sex: _nullable(json['sex']),
      nationality: _nullable(json['nationality']),
      home: _nullable(json['home']),
      address: _nullable(json['address']),
      doe: _nullable(json['doe']),
      province: _nullable(ae?['province']),
      district: _nullable(ae?['district']),
      ward: _nullable(ae?['ward']),
      street: _nullable(ae?['street']),
      ethnicity: _nullable(json['ethnicity']),
      religion: _nullable(json['religion']),
      features: _nullable(json['features']),
      issueDate: _nullable(json['issue_date']),
      issueLocation: _nullable(json['issue_loc']),
      type: _nullable(json['type']),
      typeNew: _nullable(json['type_new']),
      confidence: conf,
    );
  }

  CardInfo toDomain({Uint8List? faceOnCard}) {
    AddressEntities? addressEntities;
    if (province != null || district != null || ward != null || street != null) {
      addressEntities = AddressEntities(
        province: province,
        district: district,
        ward: ward,
        street: street,
      );
    }

    CardNumber? cardNumber;
    if (id != null) {
      try {
        cardNumber = CardNumber(id!);
      } catch (_) {
        // giữ null nếu format không hợp lệ
      }
    }

    return CardInfo(
      cardNumber: cardNumber,
      fullName: name,
      dateOfBirth: dob,
      sex: sex,
      nationality: nationality,
      homeTown: home,
      address: address,
      addressEntities: addressEntities,
      dateOfExpiry: doe,
      ethnicity: ethnicity,
      religion: religion,
      personalFeatures: features,
      issueDate: issueDate,
      issueLocation: issueLocation,
      cardType: type,
      cardTypeNew: typeNew,
      confidence: confidence,
      faceOnCard: faceOnCard,
    );
  }
}
