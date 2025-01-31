import '../screens/navigation.dart';
import '../services/firebase_messaging_service.dart';
import '../widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_options.dart';
import '../login_register/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('mk');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCheckingLogin = true;
  Widget? _homeScreen;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token != null) {
        _homeScreen = const BarbershopApp();
      } else {
        _homeScreen = const LoginScreen();
      }
    } catch (e) {
      _homeScreen = const LoginScreen();
    }

    if (mounted) {
      setState(() {
        _isCheckingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isCheckingLogin
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: orange),
              ),
            )
          : _homeScreen,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      navigatorObservers: [NavigatorObserverWithFCM()],
    );
  }
}

class NavigatorObserverWithFCM extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is MaterialPageRoute) {
      FirebaseMessagingService.initializeFirebaseMessaging(
          route.navigator!.context);
    }
  }
}
