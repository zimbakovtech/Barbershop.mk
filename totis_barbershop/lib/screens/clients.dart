import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final barberService = BarberService();
  List<User> clients = [];

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    clients = await barberService.fetchClients();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Clients'),
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('${client.firstName} ${client.lastName}'),
              subtitle: Text(client.phoneNumber),
            ),
          );
        },
      ),
    );
  }
}
