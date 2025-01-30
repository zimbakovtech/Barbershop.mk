import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class AppointmentTab extends StatelessWidget {
  final DateTime currentMonth;
  final bool isLoading;
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;
  final String Function(DateTime) formatMonth;
  final DateTime Function(DateTime) stripTime;
  final List<dynamic> todaysAppointments;
  final BarberService barberService;

  const AppointmentTab({
    super.key,
    required this.currentMonth,
    required this.isLoading,
    required this.selectedDate,
    required this.onDaySelected,
    required this.formatMonth,
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
                          height: 90,
                          child: DatePicker(
                            DateTime.now(),
                            width: 60,
                            height: 80,
                            initialSelectedDate: selectedDate,
                            selectionColor: orange,
                            selectedTextColor: Colors.white,
                            daysCount: 365,
                            locale: 'mk_MK',
                            onDateChange: onDaySelected,
                            dayTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            dateTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            monthTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: orange,
                        ),
                      )
                    : todaysAppointments.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('Нема термини за одбраниот ден',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: todaysAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = todaysAppointments[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
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
