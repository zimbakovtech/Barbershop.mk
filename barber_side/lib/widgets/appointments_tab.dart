import 'package:barbers_mk/models/waitlist.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/cards/appointment_card.dart';
import 'package:barbers_mk/widgets/cards/waitlist_card.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/custom_week_picker.dart';
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
  List<Waitlist> waitlist = [];
  String _selectedView = 'Термини';

  @override
  void initState() {
    super.initState();
    getWaitlist();
  }

  void getWaitlist() async {
    final response = await widget.barberService.getWaitlist();
    setState(() {
      waitlist = response;
    });
  }

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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: navy,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.formatMonth(widget.currentMonth),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: DropdownButton<String>(
                    value: _selectedView,
                    dropdownColor: background,
                    underline: Container(),
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedView = newValue!;
                      });
                    },
                    items: <String>['Термини', 'Листа на чекање']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    icon: Padding(
                      // Reduced multiplier to 0.3 for closer positioning
                      padding:
                          EdgeInsets.only(left: _selectedView.length * 0.3),
                      child:
                          const Icon(Icons.arrow_drop_down, color: textPrimary),
                    ),
                  ),
                ),
                _selectedView == 'Термини'
                    ? widget.isLoading
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: widget.todaysAppointments.length,
                                itemBuilder: (context, index) {
                                  final appointment =
                                      widget.todaysAppointments[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: AppointmentCardWidget(
                                      haveCall: true,
                                      haveMenu: true,
                                      appointment: appointment,
                                      barberService: widget.barberService,
                                    ),
                                  );
                                },
                              )
                    : waitlist.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('Нема клиенти на листата за чекање',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: waitlist.length,
                            itemBuilder: (context, index) {
                              final waitlistItem = waitlist[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: WaitlistCard(
                                  waitlist: waitlistItem,
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
