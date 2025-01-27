import 'package:barbers_mk/models/appointment.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentListCard extends StatelessWidget {
  final Appointment appointment;
  final Color statusColor;
  final IconData statusIcon;

  const AppointmentListCard({
    super.key,
    required this.appointment,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: navy,
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appointment.clientName}',
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: -pi / 2,
                            child: const Icon(
                              CupertinoIcons.scissors,
                              color: orange,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 55,
                            child: Text(
                              appointment.service?.name ?? 'Unknown',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.time ?? 'Unknown time',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            appointment.date ?? 'Unknown date',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.2),
              child: Icon(statusIcon, color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}
