import 'package:barbers_mk/models/service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class ServiceCard extends StatelessWidget {
  final Service service;
  final IconData icon;
  final Function(Service) onServiceSelected;

  const ServiceCard({
    super.key,
    required this.service,
    required this.icon,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              onServiceSelected(service);
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1E26),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(15.0, 10.0, 6.0, 10.0),
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: const Icon(
                      CupertinoIcons.scissors,
                      color: orange,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "${service.price.toString()} мкд",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${service.duration.toString()} min",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    onPressed: () {
                      onServiceSelected(service);
                    },
                    icon: Icon(
                      icon,
                      color: orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
