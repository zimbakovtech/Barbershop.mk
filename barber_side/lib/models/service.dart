class Service {
  final int id;
  final String icon;
  final String name;
  final int price;
  final int duration;

  Service({
    required this.id,
    required this.icon,
    required this.name,
    required this.price,
    required this.duration,
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
