import 'package:barbers_mk/book_flow.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/models/barber.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter/material.dart';

class BarberScreen extends StatefulWidget {
  const BarberScreen({super.key});

  @override
  State<BarberScreen> createState() => _BarberScreenState();
}

class _BarberScreenState extends State<BarberScreen> {
  final BarberService barberService = BarberService();
  Barber? barber;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    try {
      final fetchedBarber = await barberService.getBarberInfo();
      setState(() {
        barber = fetchedBarber;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching barber info: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/barbershop.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: barber == null
            ? const Center(child: CircularProgressIndicator())
            : BookingFlow(
                barbershopName: barber?.barbershopName ?? 'Unknown Barbershop',
                barbers: barber?.barbers ?? [],
                appointment: Appointment(),
                barberService: barberService,
              ),
      ),
    );
  }
}
