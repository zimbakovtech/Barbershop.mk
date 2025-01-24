import 'package:barbers_mk/models/client.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/client_details.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final barberService = BarberService();
  List<Client> clients = [];

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      clients = await barberService.fetchClients();
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background, // Dark background
      appBar: AppBar(title: const Text('Clients'), backgroundColor: background),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return ClientCard(
            id: client.id,
            fullName: client.fullName,
            phoneNumber: client.phoneNumber,
            profilePicture: client.profilePicture!,
            lastAppointmentDate: DateTime.parse(client.lastAppointmentDate),
            totalAppointments: client.totalAppointments,
          );
        },
      ),
    );
  }
}

class ClientCard extends StatelessWidget {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String profilePicture;
  final DateTime lastAppointmentDate;
  final int totalAppointments;

  const ClientCard({
    super.key,
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.profilePicture,
    required this.lastAppointmentDate,
    required this.totalAppointments,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date in a user-friendly way (e.g. "Jan 20, 2025"):
    final formattedDate =
        DateFormat('MMM dd, yyyy').format(lastAppointmentDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientDetails(id: id),
          ),
        );
      },
      child: Card(
        color: navy,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Profile picture on the left
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  profilePicture,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Main text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Last appointment on top
                    Text(
                      'Last Appointment: $formattedDate',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Client’s name in the middle
                    Text(
                      fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Calendar icon and the total appointment count
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: orange,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$totalAppointments термини',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow on the right
              const Icon(
                Icons.chevron_right,
                size: 30,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
