import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/barbershop.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Barbershop>>(
  (ref) {
    final notifier = FavoritesNotifier(BarberService());
    notifier.fetchFavorites();
    return notifier;
  },
);

class FavoritesNotifier extends StateNotifier<List<Barbershop>> {
  final BarberService repository;

  FavoritesNotifier(this.repository) : super([]);

  Future<void> fetchFavorites() async {
    state = await repository.fetchFavorites();
  }
}
