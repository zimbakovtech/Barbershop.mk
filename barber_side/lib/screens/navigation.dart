import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/screens/clients.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:flutter/cupertino.dart';
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
  final PageController _pageController = PageController();
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

  void changeTabIndex(int index) {
    _pageController.jumpToPage(index);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: orange))
          : PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              children: _screens,
              onPageChanged: (index) => setState(() => _currentIndex = index),
            ),
      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildCustomNavBar() {
    return SafeArea(
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: navy,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: background.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => changeTabIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: orange,
            unselectedItemColor: Colors.white54,
            selectedFontSize: 15,
            unselectedFontSize: 13.5,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house),
                activeIcon: Icon(CupertinoIcons.house_fill),
                label: 'Дома',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Термини',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_2),
                activeIcon: Icon(CupertinoIcons.person_2_fill),
                label: 'Клиенти',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_fill),
                label: 'Профил',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
