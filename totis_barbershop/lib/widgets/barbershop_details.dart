import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbers_mk/models/barbershop.dart';
import 'package:barbers_mk/models/barber.dart';
import 'package:barbers_mk/services/barber_service.dart';
import 'package:barbers_mk/widgets/colors.dart';
import 'package:barbers_mk/widgets/barber_card.dart';
import 'package:barbers_mk/providers/home_screen_provider.dart';

class BarbershopDetails extends ConsumerStatefulWidget {
  final Barbershop barbershop;
  final Function(Barber) onBarberSelected;

  const BarbershopDetails({
    super.key,
    required this.barbershop,
    required this.onBarberSelected,
  });

  @override
  ConsumerState<BarbershopDetails> createState() => _BarbershopDetailsState();
}

class _BarbershopDetailsState extends ConsumerState<BarbershopDetails> {
  List<Barber> barbers = [];
  bool isLoading = true;
  final BarberService barberService = BarberService();

  @override
  void initState() {
    super.initState();
    _fetchBarbers();
  }

  Future<void> _fetchBarbers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedBarbers = await barberService.fetchBarbers(
        barbershopId: widget.barbershop.id,
      );

      setState(() {
        barbers = fetchedBarbers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch barbers: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const int crossAxisCount = 2;
    final double itemWidth =
        (screenWidth - 40.0 - (20.0 * (crossAxisCount - 1))) / crossAxisCount;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: orange),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('lib/assets/image.png'),
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.darken),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Text(
                          widget.barbershop.shortName.toString().toUpperCase(),
                          style: GoogleFonts.montserrat(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          if (index < widget.barbershop.rating!.floor()) {
                            return const Icon(
                              Icons.star,
                              color: orange,
                              size: 30,
                            );
                          } else if (index < widget.barbershop.rating!) {
                            return const Icon(
                              Icons.star_half,
                              color: orange,
                              size: 30,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: orange,
                              size: 30,
                            );
                          }
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.barbershop.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: orange),
                          const SizedBox(width: 8),
                          Text(
                            widget.barbershop.address!.street,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.access_time, color: orange),
                          SizedBox(width: 8),
                          Text(
                            'No Working Hours Provided',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: orange),
                          const SizedBox(width: 8),
                          Text(
                            widget.barbershop.phoneNumber ??
                                'No phone number available',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await barberService.setHomeScreenEstablishment(
                                widget.barbershop.id);
                            await ref
                                .read(homescreenprovider.notifier)
                                .fetchHomeScreen();
                          },
                          icon: const Icon(
                            Icons.home_filled,
                            color: Colors.white,
                            size: 22,
                          ),
                          label: const Text(
                            'Зачувај на почетна',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            elevation: 5,
                            shadowColor: Colors.black26,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Barbers',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (barbers.isEmpty)
                        const Text(
                          'No barbers available.',
                          style: TextStyle(color: Colors.white70),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                              childAspectRatio: itemWidth / 250,
                            ),
                            itemCount: barbers.length,
                            itemBuilder: (context, index) {
                              final barber = barbers[index];
                              return BarberCardWidget(
                                barber: barber,
                                onSelectBarber: () {
                                  widget.onBarberSelected(barber);
                                },
                              );
                            },
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
