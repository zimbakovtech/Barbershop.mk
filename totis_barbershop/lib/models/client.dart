import 'package:barbers_mk/models/appointment.dart';

class Client {
  final int id;
  final String fullName;
  String phoneNumber;
  final String lastAppointmentDate;
  final String? profilePicture;
  final int totalAppointments;
  List<Appointment>? pastAppointments;
  List<Appointment>? futureAppointments;
  final int? totalRevenue;
  String? token;

  Client({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.profilePicture,
    required this.lastAppointmentDate,
    required this.totalAppointments,
    this.pastAppointments,
    this.futureAppointments,
    this.totalRevenue,
    this.token,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      lastAppointmentDate: json['last_appointment_date'],
      totalAppointments: json['total_appointments'],
      pastAppointments: (json['past_appointments'] != null &&
              json['past_appointments']['content'] != null)
          ? (json['past_appointments']['content'] as List)
              .map((e) => Appointment.fromJson(e))
              .toList()
          : [],
      futureAppointments: (json['future_appointments'] != null &&
              json['future_appointments']['content'] != null)
          ? (json['future_appointments']['content'] as List)
              .map((e) => Appointment.fromJson(e))
              .toList()
          : [],
      profilePicture: json['profile_picture'],
      totalRevenue: json['total_revenue'],
      token: null,
    );
  }
}
