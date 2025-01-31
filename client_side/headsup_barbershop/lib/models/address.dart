class Address {
  final String street;
  final int cityId;
  final String cityName;

  Address({
    required this.street,
    required this.cityId,
    required this.cityName,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      cityId: json['city_id'],
      cityName: json['city_name'],
    );
  }
}
