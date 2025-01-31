import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/colors.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime initialSelectedDate;
  final Color selectedTextColor;
  final int daysCount;
  final String locale;
  final ValueChanged<DateTime> onDateChange;
  final bool Function(DateTime) isDateAvailable;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.initialSelectedDate,
    required this.selectedTextColor,
    this.daysCount = 365,
    this.locale = 'en_US',
    required this.onDateChange,
    required this.isDateAvailable,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late PageController _pageController;
  late DateTime _firstMonday;
  late DateTime _lastDate;
  late int _totalPages;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
    _firstMonday = _getFirstMonday(widget.initialDate);
    _lastDate = widget.initialDate.add(Duration(days: widget.daysCount - 1));
    _totalPages = _calculateTotalPages();
    _currentPage = _calculateInitialPage();
    _pageController = PageController(initialPage: _currentPage);

    // Trigger initial date selection callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateChange(_selectedDate);
    });
  }

  DateTime _getFirstMonday(DateTime date) {
    return date.subtract(Duration(days: (date.weekday - DateTime.monday) % 7));
  }

  int _calculateTotalPages() {
    final totalDays = _lastDate.difference(_firstMonday).inDays + 1;
    return (totalDays / 7).ceil();
  }

  int _calculateInitialPage() {
    final selectedDateOffset = _selectedDate.difference(_firstMonday).inDays;
    return (selectedDateOffset / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _totalPages,
        scrollDirection: Axis.horizontal,
        onPageChanged: (int page) => setState(() => _currentPage = page),
        itemBuilder: (context, pageIndex) {
          final weekStart = _firstMonday.add(Duration(days: pageIndex * 7));
          return Row(
            children: List.generate(7, (index) {
              final currentDate = weekStart.add(Duration(days: index));
              final isInValidRange = currentDate.isAfter(
                      widget.initialDate.subtract(const Duration(days: 1))) &&
                  !currentDate.isAfter(_lastDate);
              final isDisabled = !isInValidRange;
              final isToday = _isToday(currentDate);
              final isSelected = _isSelected(currentDate);

              return _buildDateItem(
                  currentDate, isSelected, isDisabled, isToday);
            }),
          );
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  Widget _buildDateItem(
      DateTime date, bool isSelected, bool isDisabled, bool isToday) {
    final dayFormat = toBeginningOfSentenceCase(
      DateFormat('EEE', widget.locale).format(date).substring(0, 3),
    );

    Color borderColor = Colors.grey;
    Color textColor = Colors.grey;
    Color backgroundColor = background;

    if (!isDisabled) {
      if (isSelected) {
        borderColor = orange;
        textColor = widget.selectedTextColor;
        backgroundColor = orange;
      } else if (isToday) {
        borderColor = orange;
        textColor = textPrimary;
      } else {
        borderColor =
            widget.isDateAvailable(date) ? Colors.teal : Colors.redAccent;
        textColor = textPrimary;
      }
    } else if (isToday) {
      borderColor = orange;
    }

    return Expanded(
      child: GestureDetector(
        onTap: isDisabled ? null : () => _handleDateSelection(date),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                border: Border(
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                ),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
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
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDateSelection(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateChange(date);
  }
}
