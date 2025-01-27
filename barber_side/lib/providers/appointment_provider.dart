import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment.dart';

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>(
  (ref) {
    final notifier = AppointmentNotifier(BarberService());
    notifier.fetchAppointments();
    return notifier;
  },
);

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  final BarberService repository;
  AppointmentNotifier(this.repository) : super([]);
  Future<void> fetchAppointments() async {
    final appointments =
        await repository.fetchAppointments('?order_by=datetime&order=asc');
    state = appointments; // Notify listeners with the updated list
  }

  Future<void> cancelAppointment(int appointmentId) async {
    await repository.cancelAppointment(appointmentId); // Cancel on the backend
    await fetchAppointments(); // Refresh the state after cancellation
  }
}
