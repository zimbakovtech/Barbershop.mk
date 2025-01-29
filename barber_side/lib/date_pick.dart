import 'package:barbers_mk/models/schedule.dart';
import 'package:barbers_mk/models/service.dart';
import 'package:flutter/material.dart';
import 'services/barber_service.dart';
import 'package:intl/intl.dart';
import 'widgets/widgets.dart';

class DatePick extends StatefulWidget {
  final String barberName;
  final int barberId;
  final Service service;
  final Function(DateTime, String) onDateTimeSelected;

  const DatePick({
    super.key,
    required this.barberName,
    required this.barberId,
    required this.service,
    required this.onDateTimeSelected,
  });

  @override
  State<DatePick> createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  final BarberService barberService = BarberService();
  late Future<Schedule> _scheduleFuture;
  Map<DateTime, bool> _availableDates = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  String? _selectedTime;
  List<String> _availableTimes = [];
  bool _isFetchingTimes = false;
  String? _fetchTimesError;
  int currentMonth = DateTime.now().month; // Store month as int

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _fetchAvailableDates(currentMonth);
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<Schedule> _fetchAvailableDates(int month) async {
    try {
      final schedule = await barberService.fetchSchedule(
          barberId: widget.barberId, month: month.toString());

      setState(() {
        _availableDates = {
          for (var dateInfo in schedule.availableDates)
            _normalizeDate(DateTime.parse(dateInfo.date)): dateInfo.isAvailable
        };
      });

      return schedule;
    } catch (error) {
      setState(() {
        _availableDates = {};
      });
      rethrow;
    }
  }

  bool _isDateAvailable(DateTime date) {
    return _availableDates[_normalizeDate(date)] ?? false;
  }

  void _onDateSelected(DateTime selectedDate) async {
    setState(() {
      _selectedDate = selectedDate;
      _isFetchingTimes = true;
      _fetchTimesError = null;
      _availableTimes = [];
    });

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      List<String> availableTimes = await barberService.fetchTimes(
        barberId: widget.barberId,
        date: formattedDate,
      );

      setState(() {
        _availableTimes = availableTimes;
        _isFetchingTimes = false;
      });
    } catch (error) {
      setState(() {
        _isFetchingTimes = false;
        _fetchTimesError = 'Error fetching times: $error';
      });
    }
  }

  void _onPageChanged(DateTime month) {
    int newMonth = month.month;

    if (newMonth != currentMonth) {
      setState(() {
        currentMonth = newMonth;
        DateTime newFocusedDay = DateTime(month.year, month.month, 1);

        // Ensure newFocusedDay is not before firstDay
        DateTime firstDay = DateTime.now(); // Assuming the first day is today
        if (newFocusedDay.isBefore(firstDay)) {
          newFocusedDay = firstDay;
        }

        _focusedDay = newFocusedDay;
        _scheduleFuture = _fetchAvailableDates(currentMonth);
      });
    }
  }

  void _onTimeSelected(String selectedTime) {
    setState(() {
      _selectedTime = selectedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Schedule>(
        future: _scheduleFuture,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                CalendarWidget(
                  focusedDay: _focusedDay,
                  selectedDate: _selectedDate,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (_isDateAvailable(selectedDay)) {
                      setState(() {
                        _focusedDay = selectedDay;
                      });
                      _onDateSelected(selectedDay);
                    }
                  },
                  isDateAvailable: _isDateAvailable,
                  onDateSelected: _onDateSelected,
                  onPageChanged: _onPageChanged,
                ),
                const SizedBox(height: 20),
                AvailableTimesWidget(
                  selectedDate: _selectedDate,
                  isFetchingTimes: _isFetchingTimes,
                  fetchTimesError: _fetchTimesError,
                  availableTimes: _availableTimes,
                  selectedTime: _selectedTime,
                  onTimeSelected: _onTimeSelected,
                ),
                const SizedBox(height: 20),
                BottomButtonWidget(
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  onDateTimeSelected: widget.onDateTimeSelected,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
