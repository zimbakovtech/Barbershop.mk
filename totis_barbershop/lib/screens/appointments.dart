import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Your imports
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:barbers_mk/services/barber_service.dart';
import '../providers/appointment_provider.dart';
import 'package:barbers_mk/widgets/colors.dart';

// Enum remains the same
enum SlideDirection {
  left,
  right,
}

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

  /// Tracks which way to slide the week (left = next, right = previous).
  SlideDirection _slideDirection = SlideDirection.left;

  @override
  void initState() {
    super.initState();
    // Initialize to today's date
    final now = DateTime.now();
    // This is our "current month" pinned to day=1
    _currentMonth = DateTime(now.year, now.month);
    // Find start of the week that 'now' belongs to (Monday as start)
    _currentWeekStart = _findStartOfWeek(now);
    _selectedDate = now;
  }

  /// Returns the Monday of a given date's week.
  /// If you want Sunday as the start, adjust accordingly.
  DateTime _findStartOfWeek(DateTime date) {
    // Monday = weekday=1, Sunday=7
    final dayOfWeek = date.weekday;
    return DateTime(date.year, date.month, date.day - (dayOfWeek - 1));
  }

  // Moves forward by 7 days
  void _goToNextWeek() {
    setState(() {
      _slideDirection = SlideDirection.left; // new content slides in from right
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));

      // If we crossed into a new month, update _currentMonth
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

  // Moves backward by 7 days
  void _goToPreviousWeek() {
    setState(() {
      _slideDirection = SlideDirection.right; // new content slides in from left
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));

      // If we crossed into a previous month, update _currentMonth
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

  // Called on tapping a day circle
  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  /// Returns a "January 2025"-style string for the current month
  String _formatMonth(DateTime date) {
    // Make sure you have called initializeDateFormatting('mk') (or 'en') in main()
    return DateFormat('MMMM yyyy', 'en').format(date);
  }

  /// 7 consecutive days starting at _currentWeekStart
  List<DateTime> _getCurrentWeekDates() {
    return List.generate(
      7,
      (index) => _currentWeekStart.add(Duration(days: index)),
    );
  }

  /// Group appointments by date and return only for _selectedDate
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
    // We only consider appointments that are not canceled
    final allAppointments = ref
        .watch(appointmentProvider)
        .where((appointment) => appointment.status != 'canceled')
        .toList();

    // Subset for the selected date
    final todaysAppointments = _getAppointmentsForSelectedDate(allAppointments);

    return DefaultTabController(
      length: 2, // "Appointments" and "Availability"
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
                  // APPOINTMENTS TAB
                  // Wrap the swiping content in an AnimatedSwitcher to get a smooth transition
                  AnimatedSwitcher(
                    // A unique key for the current week's content
                    key: ValueKey<DateTime>(_currentWeekStart),
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (Widget child, Animation<double> anim) {
                      // Decide which side to slide from
                      final offsetTween = Tween<Offset>(
                        begin: _slideDirection == SlideDirection.left
                            ? const Offset(1.0, 0.0) // next => from right
                            : const Offset(-1.0, 0.0), // previous => from left
                        end: Offset.zero,
                      ).animate(anim);

                      return ClipRect(
                        child: SlideTransition(
                          position: offsetTween,
                          child: FadeTransition(
                            opacity: anim,
                            child: child,
                          ),
                        ),
                      );
                    },
                    // The child that changes when we go next/previous week:
                    child: GestureDetector(
                      // This key ensures that when _currentWeekStart changes,
                      // the child is seen as a new widget, triggering the animation.
                      key: ValueKey<DateTime>(_currentWeekStart),
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity == null) return;
                        if (details.primaryVelocity! < 0) {
                          // Swiped left
                          _goToNextWeek();
                        } else if (details.primaryVelocity! > 0) {
                          // Swiped right
                          _goToPreviousWeek();
                        }
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Month Label
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
                                          // Row of 7 Day Circles
                                          SizedBox(
                                            height: 80,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: _getCurrentWeekDates()
                                                  .map((day) {
                                                final isSelected = _stripTime(
                                                        day) ==
                                                    _stripTime(_selectedDate);

                                                return GestureDetector(
                                                  onTap: () =>
                                                      _onDaySelected(day),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Circular day number
                                                      Container(
                                                        width: 45,
                                                        height: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: background,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: isSelected
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
                                                            color: textPrimary,
                                                            fontWeight:
                                                                isSelected
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal,
                                                          ),
                                                        ),
                                                      ),
                                                      // Optional day abbreviation (Mon, Tue, ...)
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
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        ),
                                      ),
                                    )
                                  else
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 85),
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
                    ),
                  ),
                  // AVAILABILITY TAB
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
