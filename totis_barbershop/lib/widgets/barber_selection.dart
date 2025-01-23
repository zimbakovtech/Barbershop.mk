import 'package:flutter/material.dart';
import 'package:barbers_mk/widgets/barber_card.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:barbers_mk/models/barber.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberSelectionWidget extends StatelessWidget {
  final String barbershopName;
  final List<Barber> barbers;
  final Function(String name, int id) onSelectBarber;
  final Appointment appointment;
  final BarberService barberService;
  final VoidCallback onCancel;

  const BarberSelectionWidget({
    super.key,
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      barbershopName.toUpperCase(),
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Stack(
                    //   children: [
                    //     Container(
                    //       height: 200,
                    //       decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //           image: const AssetImage('lib/assets/image.png'),
                    //           colorFilter: ColorFilter.mode(
                    //               Colors.black.withOpacity(0.5),
                    //               BlendMode.darken),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //     Center(
                    //       child: Container(
                    //         height: 200,
                    //         alignment: Alignment.center,
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               barbershopName.split(' ')[0].toUpperCase(),
                    //               style: GoogleFonts.montserrat(
                    //                 fontSize: 45,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             Text(
                    //               barbershopName.split(' ').length > 1
                    //                   ? barbershopName
                    //                       .split(' ')[1]
                    //                       .toUpperCase()
                    //                   : '',
                    //               style: GoogleFonts.montserrat(
                    //                 fontSize: 45,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 30),
                    Text(
                      'Одберете го вашиот бербер',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // Display message if no barbers are available
                    if (barbers.isEmpty)
                      const Text(
                        'No barbers available',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    else
                      // Grid of barbers
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 45.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                              childAspectRatio:
                                  itemWidth / 250, // Adjust as needed
                            ),
                            itemCount: barbers.length,
                            itemBuilder: (context, index) {
                              final barber = barbers[index];
                              return BarberCardWidget(
                                barber: barber,
                                onSelectBarber: () {
                                  onSelectBarber(barber.fullName, barber.id);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    if (hasAppointment) const SizedBox(height: 70),
                  ],
                ),
              ),
              // Conditionally display the Positioned widget only if there's an appointment
              if (hasAppointment)
                Positioned(
                  bottom: 5, // Slightly above the bottom for floating effect
                  left: 10,
                  right: 10,
                  child: AppointmentCardWidget(
                    appointment: appointment,
                    barberService: barberService,
                    onCancel: onCancel,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
