import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentTab extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime currentWeekStart;
  final DateTime selectedDate;
  final VoidCallback onNextWeek;
  final VoidCallback onPreviousWeek;
  final Function(DateTime) onDaySelected;
  final String Function(DateTime) formatMonth;
  final List<DateTime> Function() getCurrentWeekDates;
  final DateTime Function(DateTime) stripTime;
  final List<dynamic> todaysAppointments;
  final BarberService barberService;

  const AppointmentTab({
    super.key,
    required this.currentMonth,
    required this.currentWeekStart,
    required this.selectedDate,
    required this.onNextWeek,
    required this.onPreviousWeek,
    required this.onDaySelected,
    required this.formatMonth,
    required this.getCurrentWeekDates,
    required this.stripTime,
    required this.todaysAppointments,
    required this.barberService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: navy,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            formatMonth(currentMonth),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: GestureDetector(
                            key: ValueKey<DateTime>(currentWeekStart),
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity == null) {
                                return;
                              }
                              if (details.primaryVelocity! < 0) {
                                onNextWeek();
                              } else if (details.primaryVelocity! > 0) {
                                onPreviousWeek();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: getCurrentWeekDates().map((day) {
                                final isSelected =
                                    stripTime(day) == stripTime(selectedDate);
                                final isToday =
                                    stripTime(day) == stripTime(DateTime.now());
                                return GestureDetector(
                                  onTap: () => onDaySelected(day),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected ? orange : background,
                                          shape: BoxShape.circle,
                                          border: Border(
                                            top: BorderSide(
                                              color: isToday
                                                  ? orange
                                                  : isSelected
                                                      ? orange
                                                      : Colors.grey,
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color: isToday
                                                  ? orange
                                                  : isSelected
                                                      ? orange
                                                      : Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : textPrimary,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        toBeginningOfSentenceCase(
                                            DateFormat('E', 'mk')
                                                .format(day)
                                                .substring(0, 3)),
                                        style: const TextStyle(
                                            fontSize: 12, color: textPrimary),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Термини',
                    style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (todaysAppointments.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Нема термини за одбраниот ден',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 85),
                    itemCount: todaysAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = todaysAppointments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: AppointmentCardWidget(
                          haveCall: true,
                          haveMenu: true,
                          appointment: appointment,
                          barberService: barberService,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
