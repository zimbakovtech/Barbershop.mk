import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/appointment.dart';
import '../colors.dart';
import '../../providers/appointment_provider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class AppointmentCardWidget extends ConsumerStatefulWidget {
  final Appointment appointment;
  final bool haveCall;
  final bool haveMenu;
  final VoidCallback? onCancel;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.haveCall,
    required this.haveMenu,
    this.onCancel,
  });

  @override
  ConsumerState<AppointmentCardWidget> createState() =>
      _AppointmentCardWidgetState();
}

class _AppointmentCardWidgetState extends ConsumerState<AppointmentCardWidget> {
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
    return Card(
      color: navy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: background, width: 2),
      ),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appointment.barber!.fullName,
                    style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: -pi / 2,
                            child: const Icon(
                              CupertinoIcons.scissors,
                              color: orange,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 55,
                            child: Text(
                              utf8.decode(widget.appointment.service!.name.runes
                                  .toList()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.appointment.time ?? '',
                            style: const TextStyle(
                              color: textPrimary,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.appointment.date ?? '',
                            style: const TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            widget.haveCall
                ? IconButton(
                    icon: const Icon(
                      CupertinoIcons.phone,
                      color: orange,
                      size: 28,
                    ),
                    onPressed: () async {
                      final phoneNumber =
                          widget.appointment.barber?.phoneNumber;
                      if (phoneNumber != null) {
                        await _makePhoneCall('071987100');
                      }
                    },
                  )
                : const SizedBox(),
            widget.haveMenu
                ? PopupMenuButton<String>(
                    color: navy,
                    icon: const Icon(
                      CupertinoIcons.ellipsis,
                      color: orange,
                      size: 30,
                    ),
                    onSelected: (String result) async {
                      if (result == 'Cancel') {
                        bool confirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Text(
                                'Откажи термин',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              content: const Text(
                                'Дали сте сигурни дека сакате да го откажете овој термин?',
                                style: TextStyle(color: textSecondary),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'Не',
                                    style: TextStyle(color: orange),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Да',
                                    style: TextStyle(color: orange),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed) {
                          try {
                            await ref
                                .read(appointmentProvider.notifier)
                                .cancelAppointment(widget.appointment.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Appointment canceled successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Failed to cancel appointment: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Cancel',
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel,
                              color: orange,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Откажи',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
