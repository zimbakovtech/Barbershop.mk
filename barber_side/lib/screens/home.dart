import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbers_mk/providers/appointment_provider.dart';
import 'package:barbers_mk/providers/home_screen_provider.dart';
import 'package:barbers_mk/book_flow.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/models/barber.dart';

class Barbershop extends ConsumerStatefulWidget {
  const Barbershop({super.key});

  @override
  ConsumerState<Barbershop> createState() => _BarbershopState();
}

class _BarbershopState extends ConsumerState<Barbershop> {
  List<Barber> barbers = [];
  bool isLoading = true;
  final barberService = BarberService();
  String barbershopName = '';
  String picture = '';
  List<Appointment> appointments = [];
  Appointment appointment = Appointment();

  @override
  void initState() {
    super.initState();
    _loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadData() async {
    final barbershop = ref.read(homescreenprovider);
    barbershopName = barbershop.name;
    barbers = barbershop.barbers;

    appointments = ref.read(appointmentProvider);
    appointment = appointments.firstWhere(
      (app) => app.status != 'canceled',
      orElse: () => Appointment(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barbershop = ref.watch(homescreenprovider);
    final appointments = ref.watch(appointmentProvider);

    barbershopName = barbershop.name;
    barbers = barbershop.barbers;

    appointment = appointments.firstWhere(
      (app) => app.status != 'canceled',
      orElse: () => Appointment(),
    );

    setState(() {
      isLoading = false;
    });

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/barbershop.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: orange))
              : BookingFlow(
                  barbershopName: barbershopName,
                  barbers: barbers,
                  appointment: appointment,
                  barberService: barberService,
                )),
    );
  }
}
