import 'package:barbers_mk/models/availability.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailabilityCardWidget extends ConsumerStatefulWidget {
  final String day;
  final List<TimeSlot> workingHours;
  final VoidCallback onDelete;

  const AvailabilityCardWidget({
    super.key,
    required this.day,
    required this.workingHours,
    required this.onDelete,
  });

  @override
  ConsumerState<AvailabilityCardWidget> createState() =>
      _AvailabilityCardWidgetState();
}

class _AvailabilityCardWidgetState
    extends ConsumerState<AvailabilityCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: navy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: background, width: 2),
      ),
      elevation: 3.0,
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
                    widget.day,
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.workingHours.map(
                    (hours) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${hours.startTime} - ${hours.endTime}',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 14,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: orange,
                size: 28,
              ),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
