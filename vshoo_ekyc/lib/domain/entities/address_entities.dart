class AddressEntities {
  final String? province;
  final String? district;
  final String? ward;
  final String? street;

  const AddressEntities({
    this.province,
    this.district,
    this.ward,
    this.street,
  });

  String get full => [street, ward, district, province]
      .where((e) => e != null && e != 'N/A' && e.isNotEmpty)
      .join(', ');
}
