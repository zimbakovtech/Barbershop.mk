import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/screens/clients.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'profile.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'appointments.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static MainPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainPageState>();

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  int _lastTappedIndex = -1;
  DateTime _lastTapTime = DateTime.now();
  final BarberService _barberService = BarberService();
  User? user;
  bool isLoading = true;

  List<Widget> _screens = [
    const Barbershop(key: ValueKey('Home')),
    const Appointments(),
    const Clients(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    try {
      user = await _barberService.getUserInfo();
    } finally {
      setState(() {
        _screens = [
          Barbershop(user: user),
          const Appointments(),
          const Clients(),
          Profile(user: user),
        ];
        isLoading = false;
      });
    }
  }

  final List<Key> _screenKeys = List.generate(4, (index) => UniqueKey());

  void changeTabIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: isLoading
          ? Container(
              color: background,
              child: const Center(
                child: CircularProgressIndicator(color: orange),
              ),
            )
          : IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: navy,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: 80,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            final now = DateTime.now();
            if (_currentIndex == index &&
                _lastTappedIndex == index &&
                now.difference(_lastTapTime) <
                    const Duration(milliseconds: 300)) {
              setState(() {
                _screenKeys[index] = UniqueKey();

                if (index == 0) {
                  _screens[index] = Barbershop(
                      key: ValueKey(DateTime.now().toString()), user: user);
                } else if (index == 1) {
                  _screens[index] =
                      Appointments(key: ValueKey(DateTime.now().toString()));
                } else if (index == 2) {
                  _screens[index] =
                      Clients(key: ValueKey(DateTime.now().toString()));
                }
              });
            } else {
              setState(() {
                _currentIndex = index;
                _lastTappedIndex = index;
                _lastTapTime = now;
              });
            }
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: orange,
          unselectedFontSize: 13.5,
          selectedFontSize: 15,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Дома',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Термини',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Клиенти',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профил',
            ),
          ],
        ),
      ),
    );
  }
}
