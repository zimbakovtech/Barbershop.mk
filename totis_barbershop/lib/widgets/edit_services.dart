import 'package:barbers_mk/models/service.dart';
import 'package:barbers_mk/models/user.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/service_card.dart';
import 'package:flutter/material.dart';

class EditServices extends StatefulWidget {
  const EditServices({super.key});

  @override
  State<EditServices> createState() => _EditServicesState();
}

class _EditServicesState extends State<EditServices> {
  User? user;
  List<Service> services = [];
  final barberService = BarberService();
  @override
  void initState() {
    super.initState();
    getServices();
  }

  void getServices() async {
    final newUser = await barberService.getUserInfo();
    setState(() {
      user = newUser;
    });
    final newServices = await barberService.fetchServices(barberId: user!.id);
    setState(() {
      services = newServices;
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
      ),
      body: services.isEmpty
          ? const Center(child: CircularProgressIndicator(color: orange))
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceCard(
                    service: service,
                    icon: Icons.edit_outlined,
                    onServiceSelected: (service) {
                      showServiceEditDialog(
                          context, service, barberService, user!);
                    });
              },
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
                      setState(() {});
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
    final TextEditingController nameController = TextEditingController();
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
                    TextField(
                      controller: nameController,
                      cursorColor: orange,
                      decoration: const InputDecoration(
                        hintText: 'Внеси име на услуга',
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange)),
                      ),
                      style: const TextStyle(color: Colors.white),
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
                    final name = nameController.text;
                    final price = double.tryParse(priceController.text);
                    final duration = int.tryParse(durationController.text);

                    if (name.isEmpty || price == null || duration == null) {
                      setState(() {});
                      return;
                    }

                    // try {
                    //   await barberService.addService(name, price, duration);
                    //   if (context.mounted) {
                    //     Navigator.of(context).pop();
                    //   }
                    // } catch (error) {
                    //   setState(() {
                    //     errorMessage = 'Грешка при додавање на услугата.';
                    //   });
                    // }
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
