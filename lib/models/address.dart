class Address {
  final int id;
  final String street;
  final String city;
  final String zipCode;
  final String country;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
