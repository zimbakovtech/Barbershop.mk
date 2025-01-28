import 'package:barbers_mk/confirmation.dart';
import 'package:barbers_mk/date_pick.dart';
import 'package:barbers_mk/models/service.dart';
import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/service_pick.dart';
import 'package:barbers_mk/widgets/barber_selection.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbers_mk/providers/appointment_provider.dart';
import 'package:barbers_mk/providers/home_screen_provider.dart';
import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/models/barber.dart';

class Barbershop extends ConsumerStatefulWidget {
  final User? user;
  const Barbershop({super.key, this.user});

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
  int _currentStep = 0;
  String? _selectedBarberName;
  Barber? _selectedBarber;
  Service? _selectedService;
  int? _barberId;
  DateTime? _selectedDate;
  String? _selectedTime;

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

  void _resetBooking() {
    setState(() {
      _currentStep = 0;
      _selectedBarberName = null;
      _selectedService = null;
      _barberId = null;
      _selectedDate = null;
      _selectedTime = null;
    });
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
          image: AssetImage('lib/assets/final_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _currentStep == 0
            ? AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  'Welcome, ${widget.user!.firstName}',
                  style: const TextStyle(fontSize: 21, color: textPrimary),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 35.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            : AppBar(
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                backgroundColor: Colors.transparent,
                title: _currentStep == 1
                    ? const Text(
                        'Одбери услуга',
                        style: TextStyle(color: textPrimary),
                      )
                    : _currentStep == 2
                        ? const Text(
                            'Одбери термин',
                            style: TextStyle(color: textPrimary),
                          )
                        : _currentStep == 3
                            ? const Text(
                                'Детали',
                                style: TextStyle(color: textPrimary),
                              )
                            : null,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _currentStep -= 1;
                    });
                  },
                ),
              ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: orange))
            : Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: _currentStep == 0
                        ? const Center(
                            child: Image(
                              image: AssetImage('lib/assets/barbersmk.png'),
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage: NetworkImage(
                                        _selectedBarber!.profilePicture!)),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedBarber!.barbershopName!
                                        .toUpperCase(),
                                    style:
                                        const TextStyle(color: textSecondary),
                                  ),
                                  Text(
                                    _selectedBarber!.fullName,
                                    style: const TextStyle(
                                        color: textPrimary,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: bookingFlow(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget bookingFlow() {
    Widget content;

    if (_currentStep == 0) {
      content = BarberSelectionWidget(
        user: widget.user!,
        barbershopName: barbershopName,
        barbers: barbers,
        onSelectBarber: (barber) {
          setState(() {
            _selectedBarber = barber;
            _selectedBarberName = barber.fullName;
            _barberId = barber.id;
            _currentStep = 1;
          });
        },
        appointment: appointment,
        barberService: barberService,
        onCancel: () {
          setState(() {
            _resetBooking();
          });
        },
      );
    } else if (_currentStep == 1) {
      content = ServicePick(
        onServiceSelected: (service) {
          setState(() {
            _selectedService = service;
            _currentStep = 2;
          });
        },
        barberId: _barberId ?? 0,
      );
    } else if (_currentStep == 2) {
      content = DatePick(
        barberName: _selectedBarberName ?? 'Unknown Barber',
        barberId: _barberId ?? 0,
        service: _selectedService!,
        onDateTimeSelected: (selectedDate, selectedTime) {
          setState(() {
            _selectedDate = selectedDate;
            _selectedTime = selectedTime;
            _currentStep = 3;
          });
        },
      );
    } else if (_currentStep == 3) {
      content = Confirmation(
        barberId: _barberId!,
        barberName: _selectedBarberName!,
        service: _selectedService!,
        date: _selectedDate!,
        time: _selectedTime!,
        onBookingSuccess: () {
          _resetBooking();
        },
      );
    } else {
      content = Container();
    }
    return content;
  }
}
