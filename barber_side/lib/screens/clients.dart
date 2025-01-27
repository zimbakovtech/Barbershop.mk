import 'package:barbers_mk/models/client.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/client_details.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final barberService = BarberService();
  List<Client> clients = [];
  List<Client> filteredClients = [];
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      clients = await barberService.fetchClients();
      filteredClients = clients; // Initialize filtered list
      setState(() {});
    } finally {}
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        searchQuery = query.toLowerCase();
        filteredClients = clients
            .where((client) =>
                client.fullName.toLowerCase().contains(searchQuery) ||
                client.phoneNumber.toLowerCase().contains(searchQuery))
            .toList();
      });
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _onSearchChanged,
              onSubmitted: (value) async {
                await fetchClients();
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                hintText: 'Search by name...',
                hintStyle: const TextStyle(color: Colors.white70),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                fillColor: navy,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: navy),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: navy),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: orange),
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minHeight: 45),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background, // Dark background
      appBar: AppBar(
        title: const Text('Clients'),
        backgroundColor: background,
      ),
      body: Column(
        children: [
          _buildSearchBar(), // Add search bar here
          Expanded(
            child: filteredClients.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return ClientCard(
                        id: client.id,
                        fullName: client.fullName,
                        phoneNumber: client.phoneNumber,
                        profilePicture:
                            client.profilePicture ?? 'lib/assets/avatar.jpg',
                        lastAppointmentDate:
                            DateTime.parse(client.lastAppointmentDate),
                        totalAppointments: client.totalAppointments,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No clients found.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
          ),
        ],
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
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: profilePicture != 'lib/assets/avatar.jpg'
                    ? Image.network(
                        profilePicture,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        profilePicture,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Appointment: $formattedDate',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: orange,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$totalAppointments appointments',
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
