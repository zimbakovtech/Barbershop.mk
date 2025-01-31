import 'package:intl/intl.dart';
import 'barbershop.dart';
import 'barber.dart';
import 'service.dart';

class Appointment {
  int? id;
  int? barberId;
  int? userId;
  String? userPhoneNumber;
  String? clientName;
  int? clientPhoneNumber;
  String? status;
  String? date;
  String? time;
  Barbershop? barbershop;
  Barber? barber;
  Service? service;

  Appointment({
    this.id,
    this.barberId,
    this.userId,
    this.userPhoneNumber,
    this.clientName,
    this.clientPhoneNumber,
    this.status,
    this.date,
    this.time,
    this.barbershop,
    this.barber,
    this.service,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final DateTime datetime = DateTime.parse(json['datetime']);
    final String formattedDate = DateFormat('dd-MM-yyyy').format(datetime);
    final String formattedTime = DateFormat('HH:mm').format(datetime);

    return Appointment(
      id: json['id'],
      barberId: json['barber_id'],
      userId: json['user_id'],
      userPhoneNumber: json['user_phone_number'],
      clientName: json['client_name'],
      clientPhoneNumber: json['client_phone_number'],
      status: json['status'],
      date: formattedDate,
      time: formattedTime,
      barbershop: Barbershop.fromJson(json['establishment']),
      barber: Barber.fromJson(json['barber']),
      service: Service.fromJson(json['service']),
    );
  }
}
