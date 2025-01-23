import 'package:barbers_mk/widgets/appointment.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/models/client.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/appointment_card.dart';

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
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(client!.profilePicture!),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    client!.fullName,
                    style: const TextStyle(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call, color: orange),
                        onPressed: () {
                          // Add logic for calling
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        client!.phoneNumber,
                        style:
                            const TextStyle(fontSize: 16, color: textPrimary),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: orange,
                        ),
                        onPressed: () {
                          // Add logic for messaging
                        },
                      ),
                    ],
                  ),
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
                        width: double.infinity,
                        child: Tab(text: 'Идни термини')),
                    SizedBox(
                        width: double.infinity,
                        child: Tab(text: 'Минати термини')),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Past Appointments Tab

                  // Future Appointments Tab
                  ListView.builder(
                    itemCount: client!.futureAppointments!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: AppointmentCardWidget(
                          haveCall: false,
                          haveMenu: true,
                          appointment: client!.futureAppointments![index],
                          barberService: barberService,
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: client!.pastAppointments!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: AppointmentListCard(
                              appointment: client!.pastAppointments![index],
                              statusColor: Colors.green,
                              statusIcon: Icons.check_circle));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
