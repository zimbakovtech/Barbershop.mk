import 'package:barbers_mk/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import '../screens/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';
import '../widgets/colors.dart';
import '../models/user.dart';
import '/services/barber_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _statusMessage = '';
  User? _user;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    final generalService = GeneralService();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Please enter both email and password';
        });
      }
      return;
    }

    try {
      _user = await BarberService().login(email, password);

      if (mounted) {
        setState(() {
          _statusMessage = 'Login successful!';
          final String fcmToken =
              prefs.getString('fcmToken') ?? 'NoDeviceToken';
          generalService.sendDeviceToken(fcmToken);
        });
        if (_user!.userType == 'barber') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BarbershopApp(
                      customer: false,
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BarbershopApp(
                      customer: true,
                    )),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e.toString().contains('credentials')) {
            _statusMessage = 'Wrong email or password';
          } else {
            _statusMessage = 'Login failed: ${e.toString()}';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/barbershop.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SingleChildScrollView(
                // Prevent overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BARBERS.MK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Welcome, please log in!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Material(
                            elevation: 5,
                            color: Colors.transparent,
                            shadowColor: background,
                            borderRadius: BorderRadius.circular(10),
                            child: BuildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.person,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Material(
                            elevation: 5,
                            color: Colors.transparent,
                            shadowColor: background,
                            borderRadius: BorderRadius.circular(10),
                            child: BuildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Handle forgot password
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orange,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                shadowColor: background,
                              ),
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const BuildDividerWithText(text: 'OR'),
                          const SizedBox(height: 20),
                          BuildSocialButton(
                            label: 'Continue with Google',
                            icon: Icons.g_mobiledata_outlined,
                            onPressed: () {
                              // Handle Google login
                            },
                          ),
                          const SizedBox(height: 10),
                          BuildSocialButton(
                            label: 'Continue with Facebook',
                            icon: Icons.facebook,
                            onPressed: () {
                              // Handle Facebook login
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Don\'t have an account? Sign up',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
