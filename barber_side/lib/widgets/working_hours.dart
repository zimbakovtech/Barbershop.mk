import 'package:barbers_mk/models/availability.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/availability_card.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';

class EditWorkingHours extends StatefulWidget {
  final int barberId;
  const EditWorkingHours({super.key, required this.barberId});

  @override
  EditWorkingHoursState createState() => EditWorkingHoursState();
}

class EditWorkingHoursState extends State<EditWorkingHours> {
  List<WorkingHours> workingHours = [];
  final barberService = BarberService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getWorkingHours();
  }

  void getWorkingHours() async {
    workingHours = await barberService.fetchWorkingHours(widget.barberId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Работни часови'),
        backgroundColor: navy,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: orange),
            )
          : (workingHours.isEmpty)
              ? const Center(
                  child: Text('No availability found.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: workingHours.length,
                  itemBuilder: (context, index) {
                    final day = workingHours.elementAt(index).day;
                    final hours = workingHours.elementAt(index).timeSlots;

                    return AvailabilityCardWidget(
                      day: day,
                      workingHours: hours,
                      onDelete: () async {
                        await barberService.deleteAvailability(
                            widget.barberId, day);
                        getWorkingHours();
                      },
                    );
                  },
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            backgroundColor: navy,
            foregroundColor: orange,
            onPressed: () {
              showServiceAddDialog(
                  context, barberService, widget.barberId, getWorkingHours);
            },
            child: const Icon(Icons.add_sharp, size: 40),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void showServiceAddDialog(
  BuildContext context,
  BarberService barberService,
  int barberId,
  Function getWorkingHours,
) {
  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            // Use navy as the dialog background
            backgroundColor: navy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Додади работно време',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Одбери ден',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // Horizontal scroller for days of the week
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: daysOfWeek.map((day) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = day;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: background, // Dark grey container
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    selectedDay == day ? orange : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              // Show only first 3 letters
                              day.substring(0, 3),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Одбери почетно и крајно време',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: startTime ?? TimeOfDay.now(),
                            builder: (ctx, child) {
                              // Apply custom theme to TimePicker
                              return Theme(
                                data: Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: orange,
                                    secondary: orange,
                                    onPrimary: textPrimary,
                                    surface: navy,
                                    onSurface: textPrimary,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: orange,
                                    ),
                                  ),
                                  textTheme: const TextTheme(
                                    bodyMedium: TextStyle(color: textPrimary),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              startTime = picked;
                            });
                          }
                        },
                        child: _timeButton(context, startTime, 'Start'),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: endTime ?? TimeOfDay.now(),
                            builder: (ctx, child) {
                              return Theme(
                                data: Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: orange,
                                    secondary: orange,
                                    onPrimary: textPrimary,
                                    surface: navy,
                                    onSurface: textPrimary,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: orange,
                                    ),
                                  ),
                                  textTheme: const TextTheme(
                                    bodyMedium: TextStyle(color: textPrimary),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              endTime = picked;
                            });
                          }
                        },
                        child: _timeButton(context, endTime, 'End'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Откажи',
                  style: TextStyle(color: orange),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedDay == null ||
                      startTime == null ||
                      endTime == null) {
                    setState(() {}); // Just re-render to show any error states
                    return;
                  }

                  try {
                    await barberService.updateAvailability(
                      barberId: barberId,
                      day: selectedDay!.toUpperCase(),
                      start:
                          '${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}',
                      end:
                          '${endTime!.hour}:${endTime!.minute.toString().padLeft(2, '0')}',
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      getWorkingHours();
                    }
                  } finally {
                    // Handle any cleanup or logging if needed
                  }
                },
                child: const Text(
                  'Потврди',
                  style: TextStyle(color: orange),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _timeButton(BuildContext context, TimeOfDay? time, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: time == null ? Colors.grey : orange,
        width: 2,
      ),
      color: background, // Dark grey container for the time button
    ),
    child: Text(
      time != null ? time.format(context) : label,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
