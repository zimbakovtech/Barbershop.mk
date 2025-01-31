import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/colors.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Appointments Tab'),
      ),
    );
  }
}
