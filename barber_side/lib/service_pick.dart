import 'package:flutter/material.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/models/service.dart';
import 'package:barbers_mk/widgets/service_list.dart';

class ServicePick extends StatefulWidget {
  final Function(Service service) onServiceSelected;
  final int barberId;

  const ServicePick(
      {super.key, required this.onServiceSelected, required this.barberId});

  @override
  State<ServicePick> createState() => _ServicePickState();
}

class _ServicePickState extends State<ServicePick> {
  List<Service> services = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayServices();
  }

  final barberService = BarberService();

  Future<void> _fetchAndDisplayServices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedServices =
          await barberService.fetchServices(barberId: widget.barberId);

      setState(() {
        services = fetchedServices;
      });
    } catch (e) {
      // Optionally handle the error here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator() // Show loading indicator
                        : ServiceList(
                            services: services,
                            onServiceSelected: (service) {
                              widget.onServiceSelected(service);
                            }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
