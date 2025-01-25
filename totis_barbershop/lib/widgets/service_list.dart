import 'package:barbers_mk/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:barbers_mk/models/service.dart';

class ServiceList extends StatelessWidget {
  final List<Service> services;
  final Function(Service) onServiceSelected;

  const ServiceList({
    super.key,
    required this.services,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return ServiceCard(
            service: service,
            icon: Icons.arrow_forward_ios,
            onServiceSelected: onServiceSelected);
      },
    );
  }
}
