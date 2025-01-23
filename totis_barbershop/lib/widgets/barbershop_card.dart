// import 'package:flutter/material.dart';
// import 'package:barbers_mk/providers/barbershop_provider.dart';
// import 'package:barbers_mk/services/barber_service.dart';
// import 'package:barbers_mk/models/barbershop.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:barbers_mk/widgets/colors.dart';

// class BarbershopCard extends ConsumerStatefulWidget {
//   final Barbershop barbershop;

//   const BarbershopCard({
//     super.key,
//     required this.barbershop,
//   });

//   @override
//   ConsumerState<BarbershopCard> createState() => _BarbershopCardState();
// }

// class _BarbershopCardState extends ConsumerState<BarbershopCard> {
//   bool _isProcessing = false;
//   final barberService = BarberService();

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: navy,
//       margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image Section
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(15.0),
//                   topRight: Radius.circular(15.0),
//                 ),
//                 child: Stack(
//                   children: [
//                     Image.network(
//                       widget.barbershop.imageUrl ?? 'lib/assets/icon.png',
//                       width: double.infinity,
//                       height: 180.0,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'lib/assets/icon.png',
//                           width: double.infinity,
//                           height: 180.0,
//                           fit: BoxFit.cover,
//                         );
//                       },
//                     ),
//                     // Favorite Button Positioned at Bottom Right
//                     Positioned(
//                       bottom: 10.0,
//                       right: 10.0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.7),
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           icon: _isProcessing
//                               ? const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: orange,
//                                     strokeWidth: 2.0,
//                                   ),
//                                 )
//                               : Icon(
//                                   widget.barbershop.userFavorite
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: orange,
//                                 ),
//                           onPressed: _isProcessing
//                               ? null
//                               : () async {
//                                   setState(() {
//                                     _isProcessing = true;
//                                   });

//                                   try {
//                                     await barberService.toggleFavorite(
//                                         widget.barbershop.id,
//                                         widget.barbershop.userFavorite);

//                                     await Future.wait([
//                                       ref
//                                           .read(establishmentProvider.notifier)
//                                           .fetchBarbershops(null, null),
//                                       ref
//                                           .read(favoritesProvider.notifier)
//                                           .fetchFavorites(),
//                                     ]);
//                                   } catch (e) {
//                                     if (context.mounted) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                               'Failed to update favorite: $e'),
//                                         ),
//                                       );
//                                     }
//                                   } finally {
//                                     setState(() {
//                                       _isProcessing = false;
//                                     });
//                                   }
//                                 },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Details Section
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // City Name
//                     Text(
//                       widget.barbershop.address?.cityName.toUpperCase() ?? '',
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12.0,
//                       ),
//                     ),
//                     const SizedBox(height: 5.0),
//                     // widget.barbershop Name
//                     Text(
//                       widget.barbershop.name,
//                       style: const TextStyle(
//                         fontSize: 19.0,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     // Additional Details (Location, Time, Rating)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const Icon(Icons.location_on,
//                             color: orange, size: 18.0),
//                         const SizedBox(width: 4.0),
//                         Expanded(
//                           child: Text(
//                             "${widget.barbershop.address?.street ?? ''}, ${widget.barbershop.address?.cityName ?? ''}",
//                             style: const TextStyle(
//                                 fontSize: 14.0, color: Colors.white),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         const Icon(Icons.access_time,
//                             color: orange, size: 18.0),
//                         const SizedBox(width: 4.0),
//                         const Text(
//                           '30 min',
//                           style: TextStyle(fontSize: 14.0, color: Colors.white),
//                         ),
//                         const SizedBox(width: 20),
//                         const Icon(Icons.star, color: orange, size: 18.0),
//                         const SizedBox(width: 4.0),
//                         Text(
//                           widget.barbershop.rating.toString(),
//                           style: const TextStyle(
//                               fontSize: 14.0, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
