import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:intl/intl.dart';
import '../providers/appointment_provider.dart';
import 'package:barbers_mk/widgets/colors.dart';

class Appointments extends ConsumerStatefulWidget {
  const Appointments({super.key});

  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends ConsumerState<Appointments> {
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
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 85.0),
        child: ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];

            try {
              // Adjust the parsing method based on the expected date format
              final appointmentDate =
                  DateFormat('dd-MM-yyyy').parse(appointment.date!);
              final now = DateTime.now();

              // Determine the label
              String label;
              if (appointmentDate.year == now.year &&
                  appointmentDate.month == now.month &&
                  appointmentDate.day == now.day) {
                label = 'Денес';
              } else if (appointmentDate.year == now.year &&
                  appointmentDate.month == now.month &&
                  appointmentDate.day == now.day + 1) {
                label = 'Утре';
              } else {
                label = DateFormat('dd.MM').format(appointmentDate);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0 ||
                      DateFormat('dd-MM-yyyy')
                              .parse(appointments[index - 1].date!)
                              .day !=
                          appointmentDate.day)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  AppointmentCardWidget(
                    appointment: appointment,
                    barberService: BarberService(),
                  ),
                ],
              );
            } catch (e) {
              return Text(
                'Error parsing date: ${appointment.date!}',
                style: const TextStyle(color: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}
