import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/cards/appointment_card.dart';
import 'package:headsup_barbershop/widgets/colors.dart';

class FutureAppointments extends StatelessWidget {
  final List allAppointments;

  const FutureAppointments({
    super.key,
    required this.allAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Идни термини',
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              itemCount: allAppointments.length,
              itemBuilder: (context, index) {
                final appointment = allAppointments[index];

                return AppointmentCardWidget(
                  haveCall: true,
                  haveMenu: true,
                  appointment: appointment,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
