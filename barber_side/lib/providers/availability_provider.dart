import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, List>(
  (ref) {
    final notifier = AvailabilityNotifier(BarberService());
    return notifier;
  },
);

class AvailabilityNotifier extends StateNotifier<List> {
  final BarberService repository;
  AvailabilityNotifier(this.repository) : super([]);

  Future<void> fetchSlots(String date) async {
    final slots = await repository.fetchSlots(date: date);
    state = slots;
  }

  Future<void> updateSlots(List slots, String date) async {
    await repository.updateSlots(slots, date);
    await fetchSlots(date);
  }
}
