import 'package:flutter/material.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'widgets/appointment.dart';
import 'widgets/colors.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  AppointmentHistoryScreenState createState() =>
      AppointmentHistoryScreenState();
}

class AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  late Future<List<Appointment>> _appointmentsFuture;
  final barberService = BarberService();

  @override
  void initState() {
    super.initState();
    _appointmentsFuture =
        barberService.fetchAppointments('?history=true&order=desc');
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
        return orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'canceled':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0,
        backgroundColor: navy,
        title: const Text('Историја на термини'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load appointments: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No appointments found.'),
            );
          }

          final appointments = snapshot.data!;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final status = appointment.status;
              final statusColor = _getStatusColor(status ?? 'unknown');
              final statusIcon = _getStatusIcon(status ?? 'unknown');

              return AppointmentListCard(
                  appointment: appointment,
                  statusColor: statusColor,
                  statusIcon: statusIcon);
            },
          );
        },
      ),
    );
  }
}
