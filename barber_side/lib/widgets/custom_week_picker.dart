import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final double width;
  final double height;
  final DateTime initialSelectedDate;
  final Color selectedColor;
  final Color unselectedColor;
  final Color? background;
  final Color selectedTextColor;
  final int daysCount;
  final String locale;
  final ValueChanged<DateTime> onDateChange;
  final TextStyle dayTextStyle;
  final TextStyle dateTextStyle;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    this.width = 60,
    this.height = 60,
    required this.initialSelectedDate,
    required this.selectedColor,
    required this.unselectedColor,
    this.background,
    required this.selectedTextColor,
    this.daysCount = 365,
    this.locale = 'en_US',
    required this.onDateChange,
    required this.dayTextStyle,
    required this.dateTextStyle,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.daysCount,
      itemBuilder: (context, index) {
        final currentDate = widget.initialDate.add(Duration(days: index));
        final isSelected = _selectedDate.day == currentDate.day &&
            _selectedDate.month == currentDate.month;
        return _buildDateItem(currentDate, isSelected);
      },
    );
  }

  Widget _buildDateItem(DateTime date, bool isSelected) {
    final dayFormat = toBeginningOfSentenceCase(DateFormat('EEE', widget.locale)
        .format(date)
        .toString()
        .substring(0, 3));

    final border = isSelected ? orange : Colors.grey;

    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
            widget.onDateChange(date);
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                border: Border(
                  top: BorderSide(color: border),
                  left: BorderSide(color: border),
                ),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayFormat,
              style: TextStyle(
                fontSize: 12,
                color: textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
