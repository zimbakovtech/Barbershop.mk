import 'dart:convert';
import 'package:barbers_mk/providers/appointment_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetails extends ConsumerStatefulWidget {
  final Appointment appointment;
  const AppointmentDetails({super.key, required this.appointment});

  @override
  AppointmentDetailsState createState() => AppointmentDetailsState();
}

class AppointmentDetailsState extends ConsumerState<AppointmentDetails> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                          onPressed: () async {
                            try {
                              await ref
                                  .read(appointmentProvider.notifier)
                                  .cancelAppointment(widget.appointment.id!);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Appointment canceled successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to cancel appointment: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
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
                        onPressed: () async {
                          final phoneNumber =
                              widget.appointment.barber?.phoneNumber;
                          if (phoneNumber != null) {
                            await _makePhoneCall('071987100');
                          }
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
                          onPressed: () async {
                            try {
                              await ref
                                  .read(appointmentProvider.notifier)
                                  .noshowAppointment(widget.appointment.id!);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Appointment marked no-show successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to no-show appointment: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
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
              Icon(Icons.message_outlined, color: orange, size: 22),
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
              color: textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
