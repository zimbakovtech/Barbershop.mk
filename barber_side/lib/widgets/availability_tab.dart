import 'package:barbers_mk/providers/availability_provider.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AvailabilityTab extends StatefulWidget {
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
  State<AvailabilityTab> createState() => _AvailabilityTabState();
}

class _AvailabilityTabState extends State<AvailabilityTab> {
  void _selectAllSlots() {
    setState(() {
      widget.availabilitySelectedSlots.clear();
      for (var slot in widget.availabilitySlots) {
        widget.availabilitySelectedSlots.add(slot['time_slot']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = widget.availabilityGetCurrentWeekDates();
    final slotsCopy = List<dynamic>.from(widget.availabilitySlots);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: navy,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.availabilityFormatMonth(
                              widget.availabilityCurrentMonth),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: GestureDetector(
                          key: ValueKey<DateTime>(
                              widget.availabilityCurrentWeekStart),
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity == null) {
                              return;
                            }
                            setState(() {
                              if (details.primaryVelocity! < 0) {
                                widget.availabilityGoToNextWeek();
                              } else if (details.primaryVelocity! > 0) {
                                widget.availabilityGoToPreviousWeek();
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: weekDates.map((day) {
                              final isSelected = widget.stripTime(day) ==
                                  widget.stripTime(
                                      widget.availabilitySelectedDate);
                              final isToday = widget.stripTime(day) ==
                                  widget.stripTime(DateTime.now());
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.availabilityOnDaySelected(day);
                                  });
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
                                          color: isSelected
                                              ? Colors.white
                                              : textPrimary,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      toBeginningOfSentenceCase(
                                        DateFormat('E', 'mk')
                                            .format(day)
                                            .substring(0, 3),
                                      )!,
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
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: navy,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              toBeginningOfSentenceCase(
                                DateFormat('EEEE - dd.MM.yyyy', 'mk')
                                    .format(widget.availabilitySelectedDate),
                              )!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: _selectAllSlots,
                              child: const Text(
                                'Select all',
                                style: TextStyle(
                                  color: orange,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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
                        itemCount: slotsCopy.length,
                        itemBuilder: (context, index) {
                          final slot = slotsCopy[index];
                          final timeSlot = slot['time_slot'] ?? '';
                          final status = slot['status'] ?? '';
                          final isSelected = widget.availabilitySelectedSlots
                              .contains(timeSlot);
                          final isOpen =
                              status == 'open' || status == 'availability';
                          final borderColor = isSelected
                              ? orange
                              : isOpen
                                  ? Colors.greenAccent
                                  : Colors.red;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  widget.availabilitySelectedSlots
                                      .remove(timeSlot);
                                } else {
                                  widget.availabilitySelectedSlots
                                      .add(timeSlot);
                                }
                              });
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
                                      color: isSelected ? orange : borderColor,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: isSelected ? orange : borderColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  timeSlot,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Затворени',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Отворени',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Одбрани',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 165),
            ],
          ),
        ),
        Positioned(
          bottom: 95,
          left: 15,
          right: 15,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedSlots = widget.availabilitySlots
                          .where((slot) => widget.availabilitySelectedSlots
                              .contains(slot['time_slot']))
                          .map((slot) => slot['time_slot'].toString())
                          .toList();
                      await widget.ref
                          .read(availabilityProvider.notifier)
                          .updateSlots(
                              updatedSlots,
                              DateFormat('yyyy-MM-dd')
                                  .format(widget.availabilitySelectedDate),
                              true);
                      if (mounted) {
                        setState(() {
                          widget.availabilitySelectedSlots.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.0),
                      child: Text(
                        'Отвори',
                        style: TextStyle(fontSize: 17.0, color: textPrimary),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedSlots = widget.availabilitySlots
                          .where((slot) => widget.availabilitySelectedSlots
                              .contains(slot['time_slot']))
                          .map((slot) => slot['time_slot'].toString())
                          .toList();
                      await widget.ref
                          .read(availabilityProvider.notifier)
                          .updateSlots(
                              updatedSlots,
                              DateFormat('yyyy-MM-dd')
                                  .format(widget.availabilitySelectedDate),
                              false);
                      if (mounted) {
                        setState(() {
                          widget.availabilitySelectedSlots.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.0),
                      child: Text(
                        'Затвори',
                        style: TextStyle(fontSize: 17.0, color: textPrimary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
