import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment.dart';

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>(
  (ref) {
    final notifier = AppointmentNotifier(BarberService());
    notifier.fetchAppointments(); // Default fetch with no date
    return notifier;
  },
);

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  final BarberService repository;

  AppointmentNotifier(this.repository) : super([]);

  Future<void> fetchAppointments({String? date}) async {
    const query = '?order_by=datetime&order=asc';
    final queryWithDate =
        (date != null && date.isNotEmpty) ? '$query&date=$date' : query;

    final appointments = await repository.fetchAppointments(queryWithDate);
    state = appointments;
  }

  Future<void> cancelAppointment(int appointmentId) async {
    await repository.cancelAppointment(appointmentId);
    await fetchAppointments(); // Refresh the list after cancellation
  }
}
