import 'package:barbers_mk/widgets/client_history.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/models/client.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';
import 'package:intl/intl.dart';

class ClientDetails extends StatefulWidget {
  final int id;
  const ClientDetails({super.key, required this.id});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails>
    with SingleTickerProviderStateMixin {
  final barberService = BarberService();
  Client? client;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getInfo();
  }

  void getInfo() async {
    client = await barberService.getClientById(widget.id);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: background,
        title: Text(client!.fullName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(client!.profilePicture!),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    client!.fullName,
                    style: const TextStyle(
                        color: textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 85.0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClientHistory(
                                          appointments:
                                              client!.pastAppointments!),
                                    ),
                                  );
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
                                    child: Icon(Icons.calendar_today,
                                        color: orange, size: 24.0),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'Client History',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 85.0,
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
                                  child: Icon(Icons.phone_outlined,
                                      color: orange, size: 24.0),
                                ),
                              ),
                            ),
                            const Text(
                              'Call Client',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 85.0,
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
                              'Ban Client',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Tabs for Appointments
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TabBar(
                  labelColor: textPrimary,
                  controller: _tabController,
                  unselectedLabelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tabs: const [
                    SizedBox(
                        width: double.infinity, child: Tab(text: 'Статистика')),
                    SizedBox(
                        width: double.infinity, child: Tab(text: 'Термини')),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 85.0),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Past Appointments Tab
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Card(
                            color: navy,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Статистика',
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: Container(
                                                height: 65.0,
                                                width: 65.0,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 2.0,
                                                      color: orange,
                                                    ),
                                                    color: navy),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_today,
                                                      color: orange,
                                                      size: 20.0,
                                                    ),
                                                    Text(
                                                      '${client!.totalAppointments}',
                                                      style: const TextStyle(
                                                        color: textPrimary,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            const SizedBox(
                                              width: 80.0,
                                              child: Text(
                                                'Вкупно термини',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: textPrimary,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              height: 85.0,
                                              width: 85.0,
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 2.0,
                                                    color: orange,
                                                  ),
                                                  color: navy),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Icon(
                                                    Icons.attach_money,
                                                    color: orange,
                                                    size: 35.0,
                                                  ),
                                                  Text(
                                                    '${client!.totalRevenue}',
                                                    style: const TextStyle(
                                                      color: textPrimary,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            const SizedBox(
                                              width: 80.0,
                                              child: Text(
                                                'Вкупен приход',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: textPrimary,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: Container(
                                                height: 65.0,
                                                width: 65.0,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 2.0,
                                                      color: orange,
                                                    ),
                                                    color: navy),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const Icon(
                                                      Icons.event,
                                                      color: orange,
                                                      size: 25.0,
                                                    ),
                                                    Text(
                                                      DateFormat('dd MMM').format(
                                                          DateTime.parse(client!
                                                              .lastAppointmentDate)),
                                                      style: const TextStyle(
                                                        color: textPrimary,
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            const SizedBox(height: 4.0),
                                            const SizedBox(
                                              width: 80.0,
                                              child: Text(
                                                'Последен термин',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: textPrimary,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: client!.futureAppointments!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            child: AppointmentCardWidget(
                              haveCall: false,
                              haveMenu: true,
                              appointment: client!.futureAppointments![index],
                              barberService: barberService,
                            ),
                          );
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
