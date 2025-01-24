import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final BarberService _barberService = BarberService();

  User? user;
  bool isLoading = true;
  String? language = 'Македонски';

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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: orange,
          ),
        ),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Failed to load user information.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 19, 20, 21),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 80.0),
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user!.profilePicture != null
                          ? NetworkImage(user!.profilePicture!)
                          : const AssetImage('lib/assets/barber.jpg'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${user!.firstName} ${user!.lastName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user!.email!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Divider(color: Colors.white54),
              const SizedBox(height: 10),
              BuildProfileItem(
                  context: context,
                  title: 'Промени лозинка',
                  icon: Icons.lock,
                  user: user!),
              BuildProfileItem(
                  context: context,
                  title: 'Промени телефон',
                  icon: Icons.phone_outlined,
                  user: user!),
              const Divider(color: Colors.white54),
              const SizedBox(height: 10),
              BuildProfileItem(
                  context: context,
                  title: 'Мои термини',
                  icon: Icons.calendar_today,
                  user: user!),
              BuildProfileItem(
                  context: context,
                  title: 'Историjа',
                  icon: Icons.history,
                  user: user!),
              const Divider(color: Colors.white54),
              const SizedBox(height: 10),
              LanguageSection(language: language),
              const Divider(color: Colors.white54),
              const SizedBox(height: 10),
              SupportSection(
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
