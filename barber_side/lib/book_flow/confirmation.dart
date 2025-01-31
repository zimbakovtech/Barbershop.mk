import 'dart:convert';
import 'package:barbers_mk/models/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barbers_mk/widgets/colors.dart';
import '../services/barber_service.dart';
import '../providers/appointment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Confirmation extends ConsumerStatefulWidget {
  final int barberId;
  final String barberName;
  final Service service;
  final DateTime date;
  final String time;
  final VoidCallback onBookingSuccess;

  const Confirmation({
    super.key,
    required this.barberId,
    required this.barberName,
    required this.service,
    required this.date,
    required this.time,
    required this.onBookingSuccess,
  });

  @override
  ConsumerState<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends ConsumerState<Confirmation> {
  final BarberService barberService = BarberService();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _nameController,
                  cursorColor: orange,
                  decoration: const InputDecoration(
                    hintText: 'Име и Презиме',
                    hintStyle: TextStyle(color: textSecondary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: orange),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: orange),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    // Date and Barber Name Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: orange),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd.MM.yyyy').format(widget.date),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person, color: orange),
                            const SizedBox(width: 8),
                            Text(
                              widget.barberName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: orange),
                            const SizedBox(width: 8),
                            Text(
                              widget.time,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.cut, color: orange),
                            const SizedBox(width: 8),
                            Text(
                              utf8.decode(widget.service.name.runes.toList()),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.attach_money, color: orange),
                            const SizedBox(width: 8),
                            Text(
                              "${widget.service.price} ден.",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.hourglass_bottom, color: orange),
                            const SizedBox(width: 8),
                            Text(
                              "${widget.service.duration} min",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () async {
                    try {
                      await barberService.bookAppointment(
                        widget.barberId,
                        _nameController.text,
                        widget.service.id,
                        widget.date,
                        widget.time,
                      );
                      await ref
                          .read(appointmentProvider.notifier)
                          .fetchAppointments();
                      widget.onBookingSuccess();
                    } catch (e) {
                      // Handle error
                    }
                  },
                  child: const Text(
                    'Закажи',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
