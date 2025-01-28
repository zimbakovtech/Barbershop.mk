import 'package:flutter/material.dart';
import 'package:barbers_mk/models/barber.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberCardWidget extends StatelessWidget {
  final Barber barber;
  final VoidCallback onSelectBarber;

  const BarberCardWidget({
    super.key,
    required this.barber,
    required this.onSelectBarber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: navy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: lightBackground, width: 1.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: barber.profilePicture != null
                  ? NetworkImage(barber.profilePicture!)
                  : const AssetImage('lib/assets/icon.png') as ImageProvider,
              backgroundColor: Colors.grey[200],
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: lightBackground, width: 1.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              barber.fullName,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onSelectBarber,
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              ),
              child: Text(
                'Резервирај',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
