import 'package:barbers_mk/models/appointment.dart';
import 'package:barbers_mk/providers/availability_provider.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/appointments_tab.dart';
import 'package:barbers_mk/widgets/availability_tab.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Appointments extends ConsumerStatefulWidget {
  const Appointments({super.key});

  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends ConsumerState<Appointments> {
  late DateTime _selectedDate;
  late DateTime _availabilitySelectedDate;
  final Set<String> _availabilitySelectedSlots = {};
  bool isLoading = true;
  final BarberService barberService = BarberService();
  List<Appointment> todaysAppointments = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _availabilitySelectedDate = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(availabilityProvider.notifier)
          .fetchSlots(DateFormat('yyyy-MM-dd').format(now));
    });
    setState(() {
      isLoading = false;
    });
  }

  void _onDaySelected(DateTime day) async {
    setState(() {
      isLoading = true;
      _selectedDate = day;
    });
    _getAppointmentsForSelectedDate();
    setState(() {
      isLoading = false;
    });
  }

  String _formatMonth(DateTime date) {
    return toBeginningOfSentenceCase(
      DateFormat('MMMM yyyy', 'mk').format(date),
    );
  }

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  Future<void> _getAppointmentsForSelectedDate() async {
    List<Appointment> newappointments = await BarberService().fetchAppointments(
        '?order_by=datetime&order=asc&date=$_selectedDate&status_not=canceled');

    setState(() {
      todaysAppointments = newappointments;
    });
  }

  void _availabilityOnDaySelected(DateTime day) {
    setState(() {
      _availabilitySelectedDate = day;
      _availabilitySelectedSlots.clear();
    });
    ref
        .read(availabilityProvider.notifier)
        .fetchSlots(DateFormat('yyyy-MM-dd').format(day));
  }

  String _availabilityFormatMonth(DateTime date) {
    return toBeginningOfSentenceCase(
      DateFormat('MMMM yyyy', 'mk').format(date),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availabilitySlots = ref.watch(availabilityProvider);
    availabilitySlots.removeWhere((slot) => slot['status'] == 'appointment');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0.0,
          backgroundColor: background,
          title: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Термини'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.bell,
                  color: textPrimary,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ));
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TabBar(
                  labelColor: textPrimary,
                  unselectedLabelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tabs: const [
                    SizedBox(
                        width: double.infinity, child: Tab(text: 'Термини')),
                    SizedBox(
                        width: double.infinity, child: Tab(text: 'Достапност')),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AppointmentTab(
                    currentMonth:
                        DateTime(_selectedDate.year, _selectedDate.month),
                    isLoading: isLoading,
                    selectedDate: _selectedDate,
                    onDaySelected: _onDaySelected,
                    formatMonth: _formatMonth,
                    stripTime: _stripTime,
                    todaysAppointments: todaysAppointments,
                    barberService: barberService,
                  ),
                  AvailabilityTab(
                    availabilityCurrentMonth: DateTime(
                        _availabilitySelectedDate.year,
                        _availabilitySelectedDate.month),
                    availabilitySelectedDate: _availabilitySelectedDate,
                    availabilitySelectedSlots: _availabilitySelectedSlots,
                    availabilityOnDaySelected: _availabilityOnDaySelected,
                    availabilityFormatMonth: _availabilityFormatMonth,
                    stripTime: _stripTime,
                    availabilitySlots: availabilitySlots,
                    ref: ref,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
