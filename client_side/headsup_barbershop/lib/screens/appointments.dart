import 'package:headsup_barbershop/widgets/future_tab.dart';
import 'package:headsup_barbershop/widgets/past_tab.dart';
import '../providers/appointment_provider.dart';
import '../widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Appointments extends ConsumerStatefulWidget {
  const Appointments({super.key});

  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends ConsumerState<Appointments> {
  @override
  Widget build(BuildContext context) {
    final allAppointments = ref
        .watch(appointmentProvider)
        .where((appointment) => appointment.status != 'canceled')
        .toList();

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
                    SizedBox(width: double.infinity, child: Tab(text: 'Идни')),
                    SizedBox(
                        width: double.infinity, child: Tab(text: 'Минати')),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FutureAppointments(
                    allAppointments: allAppointments,
                  ),
                  const PastAppointments(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
