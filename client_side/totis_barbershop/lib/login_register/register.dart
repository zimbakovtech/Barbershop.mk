import 'package:flutter/material.dart';
import '../screens/navigation.dart';
import '../widgets/widgets.dart';
import '../widgets/colors.dart';
import '/services/barber_service.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String _statusMessage = '';

  Future<void> _register() async {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String passwordConfirmation =
        _passwordConfirmationController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty ||
        phoneNumber.isEmpty) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Please fill in all fields';
        });
      }
      return;
    }

    if (password != passwordConfirmation) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Passwords do not match';
        });
      }
      return;
    }

    try {
      await BarberService().register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
      );

      if (mounted) {
        setState(() {
          _statusMessage = 'Registration successful! Token saved.';
        });
      }

      // Navigate to the main app
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BarbershopApp(
                    customer: true,
                  )),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Registration failed: ${e.toString()}';
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
                        fontFamily: GoogleFonts.cinzel().fontFamily,
                      ),
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
                            'Create an account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 40),
                          BuildTextField(
                            controller: _firstNameController,
                            label: 'First Name',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 20),
                          BuildTextField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 20),
                          BuildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 20),
                          BuildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock,
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          BuildTextField(
                            controller: _passwordConfirmationController,
                            label: 'Confirm Password',
                            icon: Icons.lock,
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          BuildTextField(
                            controller: _phoneNumberController,
                            label: 'Phone Number',
                            icon: Icons.phone,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orange,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white),
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
