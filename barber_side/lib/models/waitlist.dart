import 'package:barbers_mk/models/barber.dart';
import 'package:barbers_mk/models/service.dart';
import 'package:barbers_mk/models/user.dart';

class Waitlist {
  final int id;
  final int userId;
  final int barberId;
  final int tenantId;
  final String status;
  final int serviceId;
  final User user;
  final Barber barber;
  final Service service;
  final DateTime startDate;
  final DateTime endDate;

  Waitlist({
    required this.id,
    required this.userId,
    required this.barberId,
    required this.tenantId,
    required this.status,
    required this.serviceId,
    required this.user,
    required this.barber,
    required this.service,
    required this.startDate,
    required this.endDate,
  });

  factory Waitlist.fromJson(Map<String, dynamic> json) {
    return Waitlist(
      id: json['id'],
      userId: json['user_id'],
      barberId: json['barber_id'],
      tenantId: json['tenant_id'],
      status: json['status'],
      serviceId: json['service_id'],
      user: User.fromJson(json['user']),
      barber: Barber.fromJson(json['barber']),
      service: Service.fromJson(json['service']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}
