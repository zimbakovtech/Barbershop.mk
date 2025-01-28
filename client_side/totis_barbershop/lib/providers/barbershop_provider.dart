import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/barbershop.dart';

final establishmentProvider =
    StateNotifierProvider<EstablishmentNotifier, List<Barbershop>>(
  (ref) {
    final notifier = EstablishmentNotifier(BarberService());
    notifier.fetchBarbershops(null, null);
    return notifier;
  },
);

class EstablishmentNotifier extends StateNotifier<List<Barbershop>> {
  final BarberService repository;

  EstablishmentNotifier(this.repository) : super([]);

  Future<void> fetchBarbershops(String? search, String? cityId) async {
    state = await repository.fetchBarbershops(search: search, cityId: cityId);
  }
}
