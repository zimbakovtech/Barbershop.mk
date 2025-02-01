import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/schedule.dart';
import '../../models/service.dart';
import '../services/barber_service.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/bottom_button.dart';

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
            return const Center(
                child: CircularProgressIndicator(color: orange));
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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

class AvailableTimesWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final bool isFetchingTimes;
  final String? fetchTimesError;
  final List<String> availableTimes;
  final String? selectedTime;
  final Function(String) onTimeSelected;

  const AvailableTimesWidget({
    super.key,
    required this.selectedDate,
    required this.isFetchingTimes,
    required this.fetchTimesError,
    required this.availableTimes,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return Container();
    } else if (isFetchingTimes) {
      return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator(color: orange)));
    } else if (fetchTimesError != null) {
      return Text(
        fetchTimesError!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    } else if (availableTimes.isEmpty) {
      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: navy,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Нема слободни термини за одбраниот даум.',
                style: TextStyle(fontSize: 14, color: textPrimary),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'ЛИСТА НА ЧЕКАЊЕ',
                  style: TextStyle(
                    fontSize: 16,
                    color: orange,
                    decoration: TextDecoration.underline,
                    decorationColor: orange,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Време',
            style: TextStyle(
                fontSize: 20, color: textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: navy,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                final time = availableTimes[index];
                final isSelected = time == selectedTime;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => onTimeSelected(time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected ? orange : background,
                        // border: isSelected
                        //     ? const Border(
                        //         top: BorderSide(color: orange),
                        //         left: BorderSide(color: orange),
                        //       )
                        //     : null,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: const TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
