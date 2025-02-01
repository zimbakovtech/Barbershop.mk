import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'colors.dart';

class AppointmentDetails extends StatefulWidget {
  final Appointment appointment;
  const AppointmentDetails({super.key, required this.appointment});

  @override
  AppointmentDetailsState createState() => AppointmentDetailsState();
}

class AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Термин', style: TextStyle(color: textPrimary)),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        backgroundColor: background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            const CircleAvatar(
              radius: 60,
              backgroundColor: navy,
              child: Icon(
                Icons.person,
                color: orange,
                size: 55,
              ),
            ),
            const SizedBox(height: 12),
            // Client Name
            Text(
              widget.appointment.clientName ?? '',
              style: const TextStyle(
                color: textPrimary,
                fontSize: 24,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1.0,
                                color: lightBackground,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: navy,
                              child: Icon(Icons.cancel_outlined,
                                  color: orange, size: 24.0),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Откажи',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90.0,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1.0,
                              color: lightBackground,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 26,
                            backgroundColor: navy,
                            child: Icon(CupertinoIcons.phone,
                                color: orange, size: 24.0),
                          ),
                        ),
                      ),
                      const Text(
                        'Барај клиент',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: IconButton(
                          onPressed: () {
                            // Add your onPressed functionality here
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1.0,
                                color: lightBackground,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: navy,
                              child: Icon(
                                Icons.block,
                                color: orange,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'No-Show',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildDetailsSection(),
            const SizedBox(height: 16),

            // Notes Section
            _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Детали за терминот',
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(Icons.calendar_today, widget.appointment.date!),
              _buildDetailRow(
                  Icons.person, widget.appointment.barber?.fullName ?? ''),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(Icons.access_time, widget.appointment.time!),
              _buildDetailRow(Icons.cut,
                  utf8.decode(widget.appointment.service!.name.runes.toList())),
            ],
          ),
          const SizedBox(height: 16),

          // Price and Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(Icons.attach_money,
                  '${widget.appointment.service?.price ?? ''} ден.'),
              _buildDetailRow(Icons.hourglass_bottom,
                  '${widget.appointment.service?.duration} мин'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: orange, size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: textPrimary, fontSize: 16),
        ),
      ],
    );
  }

  // Notes Section
  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: orange, size: 22),
              SizedBox(width: 8),
              Text(
                'Белешки',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Нема белешки за овој термин',
            style: TextStyle(
              color: textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
