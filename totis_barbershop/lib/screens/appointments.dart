import 'package:barbers_mk/providers/appointment_provider.dart';
import 'package:barbers_mk/providers/availability_provider.dart';
import 'package:barbers_mk/widgets/appointments_tab.dart';
import 'package:barbers_mk/widgets/availability_tab.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Appointments extends ConsumerStatefulWidget {
  const Appointments({super.key});

  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends ConsumerState<Appointments> {
  late DateTime _currentMonth;
  late DateTime _currentWeekStart;
  late DateTime _selectedDate;
  late DateTime _availabilityCurrentMonth;
  late DateTime _availabilityCurrentWeekStart;
  late DateTime _availabilitySelectedDate;
  final Set<String> _availabilitySelectedSlots = {};
  late dynamic barberService;

  @override
  void initState() {
    super.initState();
    barberService = null;
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _currentWeekStart = _findStartOfWeek(now);
    _selectedDate = now;
    _availabilityCurrentMonth = DateTime(now.year, now.month);
    _availabilityCurrentWeekStart = _availabilityFindStartOfWeek(now);
    _availabilitySelectedDate = now;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(availabilityProvider.notifier)
          .fetchSlots(DateFormat('yyyy-MM-dd').format(now));
    });
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

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

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

  DateTime _availabilityFindStartOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    return DateTime(date.year, date.month, date.day - (dayOfWeek - 1));
  }

  void _availabilityGoToNextWeek() {
    setState(() {
      _availabilityCurrentWeekStart =
          _availabilityCurrentWeekStart.add(const Duration(days: 7));
      if (_availabilityCurrentWeekStart.month !=
              _availabilityCurrentMonth.month ||
          _availabilityCurrentWeekStart.year !=
              _availabilityCurrentMonth.year) {
        final nextMonth = _availabilityCurrentMonth.month + 1;
        final yearAdjustment = nextMonth > 12 ? 1 : 0;
        final normalizedMonth = ((nextMonth - 1) % 12) + 1;
        _availabilityCurrentMonth = DateTime(
            _availabilityCurrentMonth.year + yearAdjustment, normalizedMonth);
      }
    });
    ref
        .read(availabilityProvider.notifier)
        .fetchSlots(DateFormat('yyyy-MM-dd').format(_availabilitySelectedDate));
  }

  void _availabilityGoToPreviousWeek() {
    setState(() {
      _availabilityCurrentWeekStart =
          _availabilityCurrentWeekStart.subtract(const Duration(days: 7));
      if (_availabilityCurrentWeekStart.month !=
              _availabilityCurrentMonth.month ||
          _availabilityCurrentWeekStart.year !=
              _availabilityCurrentMonth.year) {
        final prevMonth = _availabilityCurrentMonth.month - 1;
        final yearAdjustment = prevMonth < 1 ? -1 : 0;
        final normalizedMonth = ((prevMonth - 1) % 12) + 1;
        _availabilityCurrentMonth = DateTime(
            _availabilityCurrentMonth.year + yearAdjustment, normalizedMonth);
      }
    });
    ref
        .read(availabilityProvider.notifier)
        .fetchSlots(DateFormat('yyyy-MM-dd').format(_availabilitySelectedDate));
  }

  void _availabilityOnDaySelected(DateTime day) {
    setState(() {
      _availabilitySelectedDate = day;
      _availabilitySelectedSlots.clear();
    });
    ref
        .read(availabilityProvider.notifier)
        .fetchSlots(DateFormat('yyyy-MM-dd').format(day));
  }

  String _availabilityFormatMonth(DateTime date) {
    return DateFormat('MMMM yyyy', 'en').format(date);
  }

  List<DateTime> _availabilityGetCurrentWeekDates() {
    return List.generate(
        7, (index) => _availabilityCurrentWeekStart.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final allAppointments = ref
        .watch(appointmentProvider)
        .where((appointment) => appointment.status != 'canceled')
        .toList();
    final todaysAppointments = _getAppointmentsForSelectedDate(allAppointments);
    final availabilitySlots = ref.watch(availabilityProvider);
    for (final slot in availabilitySlots) {
      if (slot['status'] == 'appointment') {
        availabilitySlots.remove(slot);
      }
    }
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
                color: navy,
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
                  AppointmentTab(
                    currentMonth: _currentMonth,
                    currentWeekStart: _currentWeekStart,
                    selectedDate: _selectedDate,
                    onNextWeek: _goToNextWeek,
                    onPreviousWeek: _goToPreviousWeek,
                    onDaySelected: _onDaySelected,
                    formatMonth: _formatMonth,
                    getCurrentWeekDates: _getCurrentWeekDates,
                    stripTime: _stripTime,
                    todaysAppointments: todaysAppointments,
                    barberService: barberService,
                  ),
                  AvailabilityTab(
                    availabilityCurrentMonth: _availabilityCurrentMonth,
                    availabilityCurrentWeekStart: _availabilityCurrentWeekStart,
                    availabilitySelectedDate: _availabilitySelectedDate,
                    availabilitySelectedSlots: _availabilitySelectedSlots,
                    availabilityGoToNextWeek: _availabilityGoToNextWeek,
                    availabilityGoToPreviousWeek: _availabilityGoToPreviousWeek,
                    availabilityOnDaySelected: _availabilityOnDaySelected,
                    availabilityFormatMonth: _availabilityFormatMonth,
                    availabilityGetCurrentWeekDates:
                        _availabilityGetCurrentWeekDates,
                    stripTime: _stripTime,
                    availabilitySlots: availabilitySlots,
                    ref: ref,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
