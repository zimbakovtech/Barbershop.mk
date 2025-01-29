import 'package:barbers_mk/appointment_history.dart';
import 'package:barbers_mk/login_register/login.dart';
import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/edit_services.dart';
import 'package:barbers_mk/widgets/statistics.dart';
import 'package:barbers_mk/widgets/working_hours.dart';
import 'package:flutter/material.dart';

class BuildProfileItem extends StatefulWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final User? user;

  const BuildProfileItem(
      {super.key,
      required this.context,
      required this.title,
      required this.icon,
      this.user});

  @override
  State<BuildProfileItem> createState() => _BuildProfileItemState();
}

class _BuildProfileItemState extends State<BuildProfileItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: orange),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 20.0, color: textSecondary),
        onTap: () {
          // Handle navigation based on title
          if (widget.title == 'Промени лозинка') {
            _showChangePasswordDialog(context);
          } else if (widget.title == 'Промени телефон') {
            _showChangePhoneDialog(context);
          } else if (widget.title == 'Историjа') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AppointmentHistoryScreen()),
            );
          } else if (widget.title == 'Статистика') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Statistics()),
            );
          } else if (widget.title == "Мои услуги") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditServices(user: widget.user!)),
            );
          } else if (widget.title == "Работни часови") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditWorkingHours(barberId: widget.user!.id)),
            );
          }
        });
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final barberService = BarberService();

    bool passwordsMatch = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String? errorMessage;

            return AlertDialog(
              backgroundColor: navy,
              title: const Text(
                'Промени лозинка',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: passwordController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси стара лозинка',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: newPasswordController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси нова лозинка',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      onChanged: (value) => setState(() {
                        if (newPasswordController.text != value) {
                          errorMessage = 'Лозинките не се совпаѓаат.';
                          passwordsMatch = false;
                        } else {
                          errorMessage = null;
                          passwordsMatch = true;
                        }
                      }),
                      cursorColor: passwordsMatch ? orange : Colors.red,
                      decoration: InputDecoration(
                        hintText: 'Потврди нова лозинка',
                        hintStyle: const TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: passwordsMatch ? orange : Colors.red)),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Откажи',
                    style: TextStyle(color: orange),
                  ),
                ),
                TextButton(
                  onPressed: passwordsMatch
                      ? () async {
                          final oldPassword = passwordController.text;
                          final newPassword = newPasswordController.text;
                          final confirmPassword =
                              confirmPasswordController.text;

                          if (newPassword.isEmpty ||
                              confirmPassword.isEmpty ||
                              oldPassword.isEmpty) {
                            setState(() {
                              errorMessage =
                                  'Сите полиња мора да бидат пополнети.';
                            });
                            return;
                          }

                          if (newPassword != confirmPassword) {
                            setState(() {
                              errorMessage = 'Лозинките не се совпаѓаат.';
                              passwordsMatch = false;
                            });
                            return;
                          } else {
                            setState(() {
                              passwordsMatch = true;
                              errorMessage = null;
                            });
                          }

                          try {
                            await barberService.updatePassword(
                                oldPassword, newPassword);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (error) {
                            setState(() {
                              errorMessage =
                                  'Грешка при ажурирање на лозинката.';
                            });
                          }
                        }
                      : null,
                  child: Text(
                    'Потврди',
                    style:
                        TextStyle(color: passwordsMatch ? orange : Colors.grey),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showChangePhoneDialog(BuildContext context) {
    final TextEditingController phoneController =
        TextEditingController(text: widget.user!.phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: navy,
          title: const Text('Промени телефон',
              style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: phoneController,
            cursorColor: orange,
            decoration: const InputDecoration(
              hintText: 'Внеси нов телефон',
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: orange)),
            ),
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Откажи', style: TextStyle(color: orange)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.user!.phoneNumber = phoneController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Потврди', style: TextStyle(color: orange)),
            ),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class LanguageSection extends StatefulWidget {
  String? language;
  LanguageSection({super.key, this.language});

  @override
  State<LanguageSection> createState() => _LanguageSectionState();
}

class _LanguageSectionState extends State<LanguageSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jазик',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        RadioListTile(
          value: 'Македонски',
          groupValue: widget.language,
          onChanged: (value) {
            setState(() {
              widget.language = value;
            });
          },
          activeColor: orange,
          title:
              const Text('Македонски', style: TextStyle(color: Colors.white)),
        ),
        RadioListTile(
          value: 'Англиски',
          groupValue: widget.language,
          onChanged: (value) {
            setState(() {
              widget.language = value;
            });
          },
          activeColor: orange,
          title: const Text('Англиски', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class SupportSection extends StatefulWidget {
  final BuildContext context;
  const SupportSection({super.key, required this.context});

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  final barberService = BarberService();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'За barbers.mk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        BuildProfileItem(context: context, title: 'FAQ', icon: Icons.help),
        BuildProfileItem(
            context: context,
            title: 'Политика за приватност',
            icon: Icons.privacy_tip),
        ListTile(
          leading: const Icon(Icons.logout, color: orange),
          title: const Text(
            'Одjави се',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onTap: () async {
            try {
              await barberService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
