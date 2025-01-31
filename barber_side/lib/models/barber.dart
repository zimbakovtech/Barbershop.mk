class Barber {
  final int id;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  List<Barber>? barbers;

  Barber({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.barbers,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Unknown',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profilePicture: json['profile_picture'],
      barbers: json['establishment'] != null &&
              json['establishment']['barbers'] != null
          ? (json['establishment']['barbers'] as List)
              .map((e) => Barber.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
