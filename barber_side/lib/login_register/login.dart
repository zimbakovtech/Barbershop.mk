import 'package:barbers_mk/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/colors.dart';
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
      await BarberService().login(email, password);

      if (mounted) {
        setState(() {
          _statusMessage = 'Login successful!';
          final String fcmToken =
              prefs.getString('fcmToken') ?? 'NoDeviceToken';
          generalService.sendDeviceToken(fcmToken);
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BarbershopApp()),
        );
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
                      'BARBERS Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
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

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: background.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class BuildDividerWithText extends StatelessWidget {
  final String text;

  const BuildDividerWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white70)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const Expanded(child: Divider(color: Colors.white70)),
      ],
    );
  }
}
