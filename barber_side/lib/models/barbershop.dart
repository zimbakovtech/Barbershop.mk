import 'address.dart';
import 'barber.dart';

class Barbershop {
  final int id;
  final String name;
  final String shortName;
  final Address? address;
  final String? phoneNumber;
  final String? imageUrl;
  final double? rating;
  bool userFavorite;
  List<Barber> barbers = [];
  Barbershop({
    required this.id,
    required this.name,
    required this.shortName,
    this.address,
    this.phoneNumber,
    this.imageUrl,
    this.rating,
    required this.userFavorite,
    this.barbers = const [],
  });

  factory Barbershop.fromJson(Map<String, dynamic> json) {
    return Barbershop(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      phoneNumber: json['phone_number'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: json['rating'] != null ? json['rating'].toDouble() : 0.0,
      userFavorite: json['user_favorite'] ?? false,
      barbers: json['barbers'] != null
          ? List<Barber>.from(
              json['barbers'].map((barber) => Barber.fromJson(barber)))
          : [],
    );
  }
  Barbershop copyWith({
    int? id,
    String? name,
    String? shortName,
    Address? address,
    String? phoneNumber,
    String? imageUrl,
    double? rating,
    required bool userFavorite,
    List<Barber>? barbers,
  }) {
    return Barbershop(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      userFavorite: userFavorite,
      barbers: barbers ?? this.barbers,
    );
  }
}
