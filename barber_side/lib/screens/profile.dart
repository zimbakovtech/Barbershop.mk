import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/models/user.dart';

class Profile extends StatefulWidget {
  final User? user;
  const Profile({super.key, this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? language = 'Македонски';
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
            const Divider(color: Colors.white54),
            const SizedBox(height: 10),
            BuildProfileItem(
                context: context,
                title: 'Промени лозинка',
                icon: Icons.lock,
                user: widget.user),
            BuildProfileItem(
                context: context,
                title: 'Промени телефон',
                icon: Icons.phone_outlined,
                user: widget.user),
            const Divider(color: Colors.white54),
            const SizedBox(height: 10),
            BuildProfileItem(
                context: context,
                title: 'Статистика',
                icon: Icons.bar_chart,
                user: widget.user),
            BuildProfileItem(
                context: context,
                title: 'Мои услуги',
                icon: Icons.cut,
                user: widget.user),
            BuildProfileItem(
                context: context,
                title: 'Работни часови',
                icon: Icons.schedule,
                user: widget.user),
            BuildProfileItem(
                context: context,
                title: 'Историjа',
                icon: Icons.history,
                user: widget.user),
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
    );
  }
}
