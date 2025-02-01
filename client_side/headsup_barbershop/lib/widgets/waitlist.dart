import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headsup_barbershop/models/barber.dart';
import 'package:headsup_barbershop/widgets/colors.dart';

class WaitList extends StatefulWidget {
  final Barber selectedBarber;
  final String barbershopName;

  const WaitList(
      {super.key, required this.selectedBarber, required this.barbershopName});

  @override
  WaitListState createState() => WaitListState();
}

class WaitListState extends State<WaitList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/final_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Листа на чекање',
              style: TextStyle(color: textPrimary)),
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                CupertinoIcons.back,
                color: textPrimary,
              )),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          NetworkImage(widget.selectedBarber.profilePicture!)),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.barbershopName.toUpperCase(),
                      style: const TextStyle(color: textSecondary),
                    ),
                    Text(
                      widget.selectedBarber.fullName,
                      style: const TextStyle(
                          color: textPrimary,
                          fontSize: 21,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
