import 'package:flutter/cupertino.dart';
import 'package:headsup_barbershop/services/barber_service.dart';
import '../widgets/colors.dart';
import '../widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class Profile extends StatefulWidget {
  User? user;
  Profile({super.key, this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? language = 'Македонски';

  void _onChange() async {
    final newUser = await BarberService().getUserInfo();
    setState(() {
      widget.user = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40.0),
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: widget.user!.profilePicture != null
                        ? NetworkImage(widget.user!.profilePicture!)
                        : const AssetImage('lib/assets/barber.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.user!.firstName} ${widget.user!.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.user!.email!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Divider(color: textSecondary),
            BuildProfileItem(
              context: context,
              title: 'Промени име и презиме',
              icon: Icons.person,
              user: widget.user,
              onChange: _onChange,
            ),
            BuildProfileItem(
                context: context,
                title: 'Промени лозинка',
                icon: Icons.lock,
                user: widget.user,
                onChange: _onChange),
            BuildProfileItem(
                context: context,
                title: 'Промени телефон',
                icon: CupertinoIcons.phone,
                user: widget.user,
                onChange: _onChange),
            const Divider(color: textSecondary),
            const SizedBox(height: 10),
            LanguageSection(language: language),
            const Divider(color: textSecondary),
            const SizedBox(height: 10),
            SupportSection(
              context: context,
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
