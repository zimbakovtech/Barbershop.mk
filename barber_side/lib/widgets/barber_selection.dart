import 'package:barbers_mk/models/user.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/widgets/barber_card.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:barbers_mk/models/barber.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/services/barber_service.dart';

class BarberSelectionWidget extends StatelessWidget {
  final User user;
  final String barbershopName;
  final List<Barber> barbers;
  final Function(Barber) onSelectBarber;
  final Appointment appointment;
  final BarberService barberService;
  final VoidCallback onCancel;

  const BarberSelectionWidget({
    super.key,
    required this.user,
    required this.barbershopName,
    required this.barbers,
    required this.onSelectBarber,
    required this.appointment,
    required this.barberService,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const int crossAxisCount = 2;
    final double itemWidth =
        (screenWidth - 40.0 - (20.0 * (crossAxisCount - 1))) / crossAxisCount;
    bool hasAppointment = appointment.id != null && appointment.date != null;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (barbers.isEmpty)
              const Text(
                'No barbers available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 45.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: itemWidth / 250,
                    ),
                    itemCount: barbers.length,
                    itemBuilder: (context, index) {
                      final barber = barbers[index];
                      return BarberCardWidget(
                        barber: barber,
                        onSelectBarber: () {
                          onSelectBarber(barber);
                        },
                      );
                    },
                  ),
                ),
              ),
            if (hasAppointment) const SizedBox(height: 70),
          ],
        ),
        if (hasAppointment)
          Positioned(
            bottom: 90,
            left: 10,
            right: 10,
            child: AppointmentCardWidget(
              haveCall: true,
              haveMenu: true,
              appointment: appointment,
              barberService: barberService,
              onCancel: onCancel,
            ),
          ),
      ],
    );
  }
}
