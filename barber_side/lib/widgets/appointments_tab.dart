import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/cards/appointment_card.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';

class AppointmentTab extends StatefulWidget {
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
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  late DateTime _selectedDate = DateTime.now();

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.formatMonth(widget.currentMonth),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                              height: 70,
                              child: CustomDatePicker(
                                initialDate: DateTime.now(),
                                width: 60,
                                height: 60,
                                initialSelectedDate: _selectedDate,
                                selectedColor: orange,
                                unselectedColor: Colors.grey,
                                selectedTextColor: textPrimary,
                                background: navy,
                                daysCount: 90,
                                locale: 'mk_MK',
                                onDateChange: (newDate) {
                                  setState(() {
                                    _selectedDate = newDate;
                                    widget.onDaySelected(newDate);
                                  });
                                },
                                dayTextStyle: const TextStyle(
                                  color: textPrimary,
                                  fontSize: 14,
                                ),
                                dateTextStyle: const TextStyle(
                                  color: textPrimary,
                                  fontSize: 18,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: background,
                                    blurRadius: 5,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              )),
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
                widget.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: orange,
                        ),
                      )
                    : widget.todaysAppointments.isEmpty
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
                            itemCount: widget.todaysAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment =
                                  widget.todaysAppointments[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: AppointmentCardWidget(
                                  haveCall: true,
                                  haveMenu: true,
                                  appointment: appointment,
                                  barberService: widget.barberService,
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
