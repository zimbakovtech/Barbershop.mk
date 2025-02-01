import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:headsup_barbershop/models/waitlist.dart';
import 'package:headsup_barbershop/services/barber_service.dart';
import 'package:headsup_barbershop/widgets/colors.dart';
import 'package:intl/intl.dart';

class WaitListScreen extends StatefulWidget {
  const WaitListScreen({super.key});

  @override
  State<WaitListScreen> createState() => WaitListScreenState();
}

class WaitListScreenState extends State<WaitListScreen> {
  List<Waitlist> _waitList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _getWaitList();
    setState(() {
      isLoading = false;
    });
  }

  void _getWaitList() async {
    final newWaitlist = await BarberService().getWaitlist();
    setState(() {
      _waitList = newWaitlist;
      print(_waitList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('Листа на чекање'),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: orange))
          : ListView.builder(
              itemCount: _waitList.length,
              itemBuilder: (context, index) {
                final waitlist = _waitList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 4.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: navy,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.cut,
                                      color: orange, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    utf8.decode(
                                        waitlist.service.name.runes.toList()),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: orange, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    waitlist.barber.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Од: ${DateFormat('dd.MM.yyyy').format(waitlist.startDate)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'До: ${DateFormat('dd.MM.yyyy').format(waitlist.endDate)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              IconButton(
                                onPressed: () async {
                                  await BarberService()
                                      .deleteWaitlist(waitlist.id);
                                  setState(() {
                                    _getWaitList();
                                  });
                                },
                                icon: const Icon(Icons.delete,
                                    color: orange, size: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
