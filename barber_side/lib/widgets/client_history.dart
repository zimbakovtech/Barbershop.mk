import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/widgets/cards/app_history_card.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';

class ClientHistory extends StatelessWidget {
  final List<Appointment> appointments;

  const ClientHistory({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: const Text('Историjа на термини'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: AppointmentListCard(
                appointment: appointment,
                statusColor: Colors.green,
                statusIcon: Icons.check_circle),
          );
        },
      ),
    );
  }
}
