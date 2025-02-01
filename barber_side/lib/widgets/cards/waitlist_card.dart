import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../colors.dart';
import 'package:flutter/cupertino.dart';
import '../../models/waitlist.dart';
import 'dart:math';

class WaitlistCard extends StatefulWidget {
  final Waitlist waitlist;

  const WaitlistCard({
    super.key,
    required this.waitlist,
  });

  @override
  State<WaitlistCard> createState() => _WaitlistCardState();
}

class _WaitlistCardState extends State<WaitlistCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
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
                      '${widget.waitlist.user.firstName} ${widget.waitlist.user.lastName}',
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
                                utf8.decode(widget.waitlist.service.name.runes
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
                            const Text(
                              'Waiting',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${DateFormat("dd.MM.yyyy").format(widget.waitlist.startDate)} - ${DateFormat("dd.MM.yyyy").format(widget.waitlist.endDate)}',
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
              IconButton(
                onPressed: () {},
                color: navy,
                icon: const Icon(
                  CupertinoIcons.ellipsis,
                  color: orange,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
