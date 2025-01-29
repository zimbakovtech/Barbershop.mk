import 'package:barbers_mk/models/service.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDate;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final bool Function(DateTime) isDateAvailable;
  final void Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDate,
    required this.onDaySelected,
    required this.isDateAvailable,
    required this.onPageChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Датум',
          style: TextStyle(
              fontSize: 20, color: textPrimary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: navy,
          ),
          child: TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            onPageChanged: (focusedMonth) {
              onPageChanged(focusedMonth);
            },
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: textPrimary)),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: orange),
                  left: BorderSide(color: orange),
                ),
                color: background,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: textPrimary),
              selectedTextStyle: TextStyle(color: textPrimary),
              selectedDecoration: BoxDecoration(
                color: orange,
                shape: BoxShape.circle,
              ),
              cellMargin: EdgeInsets.all(3.0),
            ),
            focusedDay: focusedDay,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: onDaySelected,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isAvailable = isDateAvailable(day);
                final isSelected = isSameDay(day, selectedDate);
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    onTap: () => onDateSelected(day),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border(
                          top: BorderSide(
                              color: isAvailable ? Colors.teal : Colors.red),
                          left: BorderSide(
                              color: isAvailable ? Colors.teal : Colors.red),
                        ),
                        color: isSelected ? orange : background,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: textPrimary),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ServicesWidget extends StatelessWidget {
  final List<Service> services;
  final Service? selectedService;
  final Function(Service) onServiceSelected;

  const ServicesWidget({
    super.key,
    required this.services,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Услуги',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final isSelected = service == selectedService;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () => onServiceSelected(service),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? orange : Colors.black54,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        service.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[300],
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
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: navy,
        ),
        child: const Text(
          'Нема слободни термини за одбраниот даум. ЛИСТА НА ЧЕКАЊЕ',
          style: TextStyle(fontSize: 16, color: textPrimary),
          textAlign: TextAlign.center,
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

class BottomButtonWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final Function(DateTime, String) onDateTimeSelected;

  const BottomButtonWidget({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: () {
          if (selectedDate != null && selectedTime != null) {
            onDateTimeSelected(selectedDate!, selectedTime!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a date and time'),
              ),
            );
          }
        },
        child: const Text(
          'Продолжи',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: background.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class BuildDividerWithText extends StatelessWidget {
  final String text;

  const BuildDividerWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white70)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const Expanded(child: Divider(color: Colors.white70)),
      ],
    );
  }
}

class BuildSocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const BuildSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.grey),
        label: Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
