import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:barbers_mk/services/barber_service.dart';
import '../providers/appointment_provider.dart';
import 'package:barbers_mk/widgets/colors.dart';

class Appointments extends ConsumerStatefulWidget {
  const Appointments({super.key});

  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends ConsumerState<Appointments> {
  final barberService = BarberService();
  late DateTime _currentMonth;
  late DateTime _currentWeekStart;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _currentWeekStart = _findStartOfWeek(now);
    _selectedDate = now;
  }

  DateTime _findStartOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    return DateTime(date.year, date.month, date.day - (dayOfWeek - 1));
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      if (_currentWeekStart.month != _currentMonth.month ||
          _currentWeekStart.year != _currentMonth.year) {
        final nextMonth = _currentMonth.month + 1;
        final yearAdjustment = nextMonth > 12 ? 1 : 0;
        final normalizedMonth = ((nextMonth - 1) % 12) + 1;
        _currentMonth =
            DateTime(_currentMonth.year + yearAdjustment, normalizedMonth);
      }
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      if (_currentWeekStart.month != _currentMonth.month ||
          _currentWeekStart.year != _currentMonth.year) {
        final prevMonth = _currentMonth.month - 1;
        final yearAdjustment = prevMonth < 1 ? -1 : 0;
        final normalizedMonth = ((prevMonth - 1) % 12) + 1;
        _currentMonth =
            DateTime(_currentMonth.year + yearAdjustment, normalizedMonth);
      }
    });
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  String _formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy', 'en').format(date);
  }

  List<DateTime> _getCurrentWeekDates() {
    return List.generate(
        7, (index) => _currentWeekStart.add(Duration(days: index)));
  }

  List<dynamic> _getAppointmentsForSelectedDate(List<dynamic> allAppointments) {
    final grouped = <DateTime, List<dynamic>>{};
    for (final apt in allAppointments) {
      try {
        final date = DateFormat('dd-MM-yyyy').parse(apt.date!);
        grouped[_stripTime(date)] = [...(grouped[_stripTime(date)] ?? []), apt];
      } catch (_) {}
    }
    return grouped[_stripTime(_selectedDate)] ?? [];
  }

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    final allAppointments = ref
        .watch(appointmentProvider)
        .where((appointment) => appointment.status != 'canceled')
        .toList();
    final todaysAppointments = _getAppointmentsForSelectedDate(allAppointments);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: navy,
          title: const Text('Термини'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TabBar(
                  labelColor: textPrimary,
                  unselectedLabelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tabs: const [
                    SizedBox(
                        width: double.infinity,
                        child: Tab(text: 'Appointments')),
                    SizedBox(
                        width: double.infinity,
                        child: Tab(text: 'Availability')),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          _formatMonth(_currentMonth),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 80,
                                        child:
                                            // child: AnimatedSwitcher(
                                            //   duration:
                                            //       const Duration(milliseconds: 300),
                                            //   transitionBuilder:
                                            //       (child, animation) {
                                            //     return SlideTransition(
                                            //       position: Tween<Offset>(
                                            //         begin: const Offset(1, 0),
                                            //         end: Offset.zero,
                                            //       ).animate(animation),
                                            //       child: child,
                                            //     );
                                            //   },
                                            //   child:
                                            GestureDetector(
                                          key: ValueKey<DateTime>(
                                              _currentWeekStart),
                                          onHorizontalDragEnd: (details) {
                                            if (details.primaryVelocity == null)
                                              return;
                                            if (details.primaryVelocity! < 0) {
                                              _goToNextWeek();
                                            } else if (details
                                                    .primaryVelocity! >
                                                0) {
                                              _goToPreviousWeek();
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: _getCurrentWeekDates()
                                                .map((day) {
                                              final isSelected =
                                                  _stripTime(day) ==
                                                      _stripTime(_selectedDate);
                                              final isToday = _stripTime(day) ==
                                                  _stripTime(DateTime.now());
                                              return GestureDetector(
                                                onTap: () =>
                                                    _onDaySelected(day),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? orange
                                                            : background,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: isToday
                                                              ? orange
                                                              : Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '${day.day}',
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : textPrimary,
                                                          fontWeight: isSelected
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('E', 'en')
                                                          .format(day),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: textPrimary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(
                                  'Термини',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (todaysAppointments.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Нема термини за одбраниот ден',
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 85),
                                  itemCount: todaysAppointments.length,
                                  itemBuilder: (context, index) {
                                    final appointment =
                                        todaysAppointments[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
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
                  ),
                  Center(
                    child: Text(
                      'No availability data',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
