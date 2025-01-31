import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/colors.dart';
import 'package:intl/intl.dart';
import '../../models/schedule.dart';
import '../../models/service.dart';
import '../services/barber_service.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/widgets.dart';

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
  DateTime? _selectedDate;
  String? _selectedTime;
  List<String> _availableTimes = [];
  bool _isFetchingTimes = false;
  String? _fetchTimesError;

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _fetchAvailableDates(DateTime.now().month);
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<Schedule> _fetchAvailableDates(int month) async {
    try {
      final schedule = await barberService.fetchSchedule(
        barberId: widget.barberId,
        month: month.toString(),
      );
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
        serviceId: widget.service.id,
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Датум',
                    style: TextStyle(
                      fontSize: 20,
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Text(
                            toBeginningOfSentenceCase(
                              DateFormat('MMMM yyyy', 'mk')
                                  .format(_selectedDate ?? DateTime.now()),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        CustomDatePicker(
                          initialDate: DateTime.now(),
                          initialSelectedDate: _selectedDate ?? DateTime.now(),
                          selectedTextColor: Colors.white,
                          daysCount: 20,
                          locale: 'mk_MK',
                          onDateChange: (date) {
                            _onDateSelected(date);
                          },
                          isDateAvailable: _isDateAvailable,
                        ),
                      ],
                    ),
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
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
