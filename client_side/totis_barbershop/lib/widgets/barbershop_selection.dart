import 'package:flutter/material.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/screens/navigation.dart';

class BarbershopSelection extends StatelessWidget {
  const BarbershopSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BARBERS.MK',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Пронајди го својот бербер во секунда',
                  style: TextStyle(
                    fontSize: 18,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: ElevatedButton(
                    onPressed: () {
                      MainPage.of(context)?.changeTabIndex(1);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      backgroundColor: orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'ПРОНАЈДИ ЈА СВОЈАТА БЕРБЕРНИЦА',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: textPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
