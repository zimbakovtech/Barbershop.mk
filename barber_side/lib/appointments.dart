import 'package:barbers_mk/widgets/cards/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'providers/appointment_provider.dart';
import 'package:barbers_mk/widgets/colors.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  AppointmentsScreenState createState() => AppointmentsScreenState();
}

class AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  final barberService = BarberService();

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentProvider).where((appointment) {
      return appointment.status != 'canceled';
    }).toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0,
        backgroundColor: navy,
        title: const Text('Мои термини'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];

            return AppointmentCardWidget(
              haveCall: true,
              haveMenu: true,
              appointment: appointment,
              barberService: BarberService(),
            );
          },
        ),
      ),
    );
  }
}
