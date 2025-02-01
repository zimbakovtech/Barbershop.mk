import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/colors.dart';
import '../../services/barber_service.dart';
import '../../models/service.dart';
import '../../widgets/service_list.dart';

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

  Future<void> _fetchAndDisplayServices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedServices =
          await BarberService().fetchServices(barberId: widget.barberId);

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
                    isLoading
                        ? const CircularProgressIndicator(
                            color: orange) // Show loading indicator
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
