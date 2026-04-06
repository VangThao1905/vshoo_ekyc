import 'dart:typed_data';
import '../value_objects/card_number.dart';
import 'address_entities.dart';

/// Unified entity cho cả mặt trước (front) và mặt sau (back) CCCD/CMND.
/// Các field chỉ có ở front: id, name, dob, sex, nationality, home, address, doe.
/// Các field chỉ có ở back: ethnicity, religion, features, issueDate, issueLocation.
class CardInfo {
  // ── Front side fields ─────────────────────────────────────────
  final CardNumber? cardNumber;
  final String? fullName;
  final String? dateOfBirth;
  final String? sex;
  final String? nationality;
  final String? homeTown;         // "home" trong FPT response
  final String? address;
  final AddressEntities? addressEntities;
  final String? dateOfExpiry;     // "doe"

  // ── Back side fields ──────────────────────────────────────────
  final String? ethnicity;
  final String? religion;
  final String? personalFeatures;  // "features"
  final String? issueDate;
  final String? issueLocation;

  // ── Metadata ──────────────────────────────────────────────────
  /// 'old' | 'old_back' | 'new' | 'new_back'
  final String? cardType;
  /// 'cmnd_09_front' | 'cmnd_12_front' | 'cccd_12_front' | 'old_back' | 'new_back'
  final String? cardTypeNew;
  final double confidence;

  // ── Face image (crop từ mặt trước) ───────────────────────────
  final Uint8List? faceOnCard;

  bool get isFrontSide =>
      cardType == 'old' || cardType == 'new';
  bool get isBackSide =>
      cardType == 'old_back' || cardType == 'new_back';

  const CardInfo({
    this.cardNumber,
    this.fullName,
    this.dateOfBirth,
    this.sex,
    this.nationality,
    this.homeTown,
    this.address,
    this.addressEntities,
    this.dateOfExpiry,
    this.ethnicity,
    this.religion,
    this.personalFeatures,
    this.issueDate,
    this.issueLocation,
    this.cardType,
    this.cardTypeNew,
    required this.confidence,
    this.faceOnCard,
  });
}
