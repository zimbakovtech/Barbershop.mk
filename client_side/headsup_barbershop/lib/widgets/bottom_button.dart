import 'package:flutter/material.dart';
import '../widgets/colors.dart';

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
