import 'package:barbers_mk/providers/availability_provider.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AvailabilityTab extends StatelessWidget {
  final DateTime availabilityCurrentMonth;
  final DateTime availabilityCurrentWeekStart;
  final DateTime availabilitySelectedDate;
  final Set<String> availabilitySelectedSlots;
  final VoidCallback availabilityGoToNextWeek;
  final VoidCallback availabilityGoToPreviousWeek;
  final Function(DateTime) availabilityOnDaySelected;
  final String Function(DateTime) availabilityFormatMonth;
  final List<DateTime> Function() availabilityGetCurrentWeekDates;
  final DateTime Function(DateTime) stripTime;
  final List<dynamic> availabilitySlots;
  final WidgetRef ref;

  const AvailabilityTab({
    super.key,
    required this.availabilityCurrentMonth,
    required this.availabilityCurrentWeekStart,
    required this.availabilitySelectedDate,
    required this.availabilitySelectedSlots,
    required this.availabilityGoToNextWeek,
    required this.availabilityGoToPreviousWeek,
    required this.availabilityOnDaySelected,
    required this.availabilityFormatMonth,
    required this.availabilityGetCurrentWeekDates,
    required this.stripTime,
    required this.availabilitySlots,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            color: navy,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    availabilityFormatMonth(availabilityCurrentMonth),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: GestureDetector(
                    key: ValueKey<DateTime>(availabilityCurrentWeekStart),
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity == null) {
                        return;
                      }
                      if (details.primaryVelocity! < 0) {
                        availabilityGoToNextWeek();
                      } else if (details.primaryVelocity! > 0) {
                        availabilityGoToPreviousWeek();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: availabilityGetCurrentWeekDates().map((day) {
                        final isSelected = stripTime(day) ==
                            stripTime(availabilitySelectedDate);
                        final isToday =
                            stripTime(day) == stripTime(DateTime.now());
                        return GestureDetector(
                          onTap: () {
                            availabilityOnDaySelected(day);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: isSelected ? orange : background,
                                  shape: BoxShape.circle,
                                  border: Border(
                                    top: BorderSide(
                                      color: isToday
                                          ? orange
                                          : isSelected
                                              ? orange
                                              : Colors.grey,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: isToday
                                          ? orange
                                          : isSelected
                                              ? orange
                                              : Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color:
                                        isSelected ? Colors.white : textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('E', 'en').format(day),
                                style: const TextStyle(
                                    fontSize: 12, color: textPrimary),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    color: navy,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            DateFormat('EEEE - dd.MM.yyyy')
                                .format(availabilitySelectedDate),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GridView.builder(
                          padding: const EdgeInsets.all(3),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 0,
                            childAspectRatio: 1.35,
                          ),
                          itemCount: availabilitySlots.length,
                          itemBuilder: (context, index) {
                            final slot = availabilitySlots[index];
                            final timeSlot = slot['time_slot'] ?? '';
                            final status = slot['status'] ?? '';
                            final isSelected =
                                availabilitySelectedSlots.contains(timeSlot);
                            final isOpen =
                                status == 'open' || status == 'availability';
                            final borderColor = isSelected
                                ? orange
                                : isOpen
                                    ? Colors.green
                                    : Colors.red;
                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  availabilitySelectedSlots.remove(timeSlot);
                                } else {
                                  availabilitySelectedSlots.add(timeSlot);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: background,
                                    borderRadius: BorderRadius.circular(30),
                                    shape: BoxShape.rectangle,
                                    border: Border(
                                      top: BorderSide(
                                          color:
                                              isSelected ? orange : borderColor,
                                          width: 1),
                                      left: BorderSide(
                                          color:
                                              isSelected ? orange : borderColor,
                                          width: 1),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(timeSlot,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedSlots = <String>[];
                        for (final slot in availabilitySlots) {
                          final timeSlot = slot['time_slot'];
                          if (availabilitySelectedSlots.contains(timeSlot)) {
                            updatedSlots.add(timeSlot);
                          }
                        }
                        await ref
                            .read(availabilityProvider.notifier)
                            .updateSlots(
                              updatedSlots,
                              DateFormat('yyyy-MM-dd')
                                  .format(availabilitySelectedDate),
                            );
                        availabilitySelectedSlots.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 13.0),
                        child: Text('Отвори / Затвори',
                            style:
                                TextStyle(fontSize: 17.0, color: textPrimary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 85),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
