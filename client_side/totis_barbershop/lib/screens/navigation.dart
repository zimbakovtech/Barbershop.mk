import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart'; 
import 'profile.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'appointments.dart';
import 'barber_screen.dart';

class BarbershopApp extends StatelessWidget {
  final bool customer;
  const BarbershopApp({super.key, this.customer = true});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: MainPage(customer: customer),
    );
  }
}

class MainPage extends StatefulWidget {
  final bool customer;
  const MainPage({super.key, this.customer = true});

  static MainPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainPageState>();

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  int _lastTappedIndex = -1;
  DateTime _lastTapTime = DateTime.now();

  List<Widget> _screens = [
    const Barbershop(key: ValueKey('Home')),
    const Search(key: ValueKey('Search')),
    const Favorites(key: ValueKey('Favorites')),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.customer) {
      _screens = [
        const BarberScreen(key: ValueKey('Home')),
        const Appointments(key: ValueKey('Appointments')),
        const Clients(),
        const Profile(),
      ];
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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              // Prevent overflow in areas with system UI (like notches or navigation gestures)
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SizedBox(
                  height: 80, // Adjust the height as needed
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
                                key: ValueKey(DateTime.now().toString()));
                          } else if (index == 1) {
                            _screens[index] = Search(
                                key: ValueKey(DateTime.now().toString()));
                          } else if (index == 2) {
                            _screens[index] = Favorites(
                                key: ValueKey(DateTime.now().toString()));
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
                    backgroundColor: navy,
                    selectedItemColor: orange,
                    unselectedItemColor: Colors.white54,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.home_filled),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: widget.customer
                            ? const Icon(CupertinoIcons.search)
                            : const Icon(Icons.calendar_today),
                        label: widget.customer ? 'Search' : 'Appointments',
                      ),
                      BottomNavigationBarItem(
                        icon: widget.customer
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.people),
                        label: widget.customer ? 'Favorites' : 'Clients',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
