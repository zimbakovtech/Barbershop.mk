class Service {
  final int id;
  final String icon;
  final String name;
  int? price;
  int? duration;

  Service({
    required this.id,
    required this.icon,
    required this.name,
    this.price,
    this.duration,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
    );
  }
}
