import '../services/barber_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/barbershop.dart';

final homescreenprovider =
    StateNotifierProvider<HomeScreenNotifier, Barbershop>(
  (ref) {
    final notifier = HomeScreenNotifier(BarberService());
    notifier.fetchHomeScreen();
    return notifier;
  },
);

class HomeScreenNotifier extends StateNotifier<Barbershop> {
  final BarberService repository;

  HomeScreenNotifier(this.repository)
      : super(Barbershop(id: 0, name: '', shortName: '', userFavorite: false));

  Future<void> fetchHomeScreen() async {
    state = await repository.fetchHomeScreen();
  }
}
