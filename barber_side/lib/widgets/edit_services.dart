import 'package:barbers_mk/models/service.dart';
import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/service_card.dart';
import 'package:flutter/material.dart';

class EditServices extends StatefulWidget {
  final User user;
  const EditServices({super.key, required this.user});

  @override
  State<EditServices> createState() => _EditServicesState();
}

class _EditServicesState extends State<EditServices> {
  List<Service> services = [];
  List<Service> allServices = [];
  Service? selectedService;
  final barberService = BarberService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getServices();
    isLoading = false;
    getAllServices();
  }

  void getServices() async {
    isLoading = true;
    final newServices =
        await barberService.fetchServices(barberId: widget.user.id);
    setState(() {
      services = newServices;
      isLoading = false;
    });
  }

  void getAllServices() async {
    final newServices = await barberService.fetchAllServices();
    setState(() {
      allServices = newServices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: const Text('Мои услуги'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: orange))
          : services.isNotEmpty
              ? ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceCard(
                        service: service,
                        icon: Icons.edit_outlined,
                        delete: true,
                        onServiceDeleted: () async {
                          await barberService.deleteService(service.id);
                          getServices();
                        },
                        onServiceSelected: (service) {
                          showServiceEditDialog(
                              context, service, barberService, widget.user);
                        });
                  },
                )
              : const Center(
                  child: Text('Сеуште немате услуги'),
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            backgroundColor: navy,
            foregroundColor: orange,
            onPressed: () {
              showServiceAddDialog(context, barberService);
            },
            child: const Icon(Icons.add_sharp, size: 40),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void showServiceEditDialog(BuildContext context, Service service,
      BarberService barberService, User user) {
    final TextEditingController priceController =
        TextEditingController(text: service.price.toString());
    final TextEditingController durationController =
        TextEditingController(text: service.duration.toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: navy,
              title: Text(
                'Промени информации за ${service.name}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: priceController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси цена на услуга',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: durationController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси времетраеnjе на услуга',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                    ),
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
                  onPressed: () async {
                    final price = int.tryParse(priceController.text);
                    final duration = int.tryParse(durationController.text);

                    if (price == null || duration == null) {
                      setState(() {});
                      return;
                    }
                    try {
                      await barberService.updateService(
                          serviceId: service.id,
                          price: price,
                          duration: duration,
                          userId: user.id);
                      if (context.mounted) {
                        getServices();
                        Navigator.of(context).pop();
                      }
                    } catch (error) {
                      getServices();
                    }
                  },
                  child: const Text(
                    'Потврди',
                    style: TextStyle(color: orange),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showServiceAddDialog(BuildContext context, BarberService barberService) {
    final TextEditingController priceController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: navy,
              title: const Text(
                'Додади услуга',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: allServices.map((service) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedService = service;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: background, // Dark grey container
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedService == service
                                      ? orange
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                service.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси цена на услуга',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: durationController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси времетраење на услуга',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                    ),
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
                  onPressed: () async {
                    final price = int.tryParse(priceController.text);
                    final duration = int.tryParse(durationController.text);

                    if (selectedService == null ||
                        price == null ||
                        duration == null) {
                      setState(() {});
                      return;
                    }

                    try {
                      await barberService.addService(
                          widget.user.id, selectedService!.id, price, duration);
                      if (context.mounted) {
                        getServices();
                        Navigator.of(context).pop();
                      }
                    } finally {}
                  },
                  child: const Text(
                    'Потврди',
                    style: TextStyle(color: orange),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
