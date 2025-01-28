// import 'package:barbers_mk/models/service.dart';
// import 'package:barbers_mk/widgets/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:barbers_mk/service_pick.dart';
// import 'package:barbers_mk/date_pick.dart';
// import 'package:barbers_mk/confirmation.dart';
// import 'package:barbers_mk/services/barber_service.dart';
// import 'package:barbers_mk/widgets/barber_selection.dart';
// import 'package:barbers_mk/models/barber.dart';
// import 'package:barbers_mk/models/appointment.dart';

// class BookingFlow extends StatefulWidget {
//   final String barbershopName;
//   final List<Barber> barbers;
//   final Appointment appointment;
//   final BarberService barberService;

//   const BookingFlow({
//     required this.barbershopName,
//     required this.barbers,
//     required this.appointment,
//     required this.barberService,
//     super.key,
//   });

//   @override
//   BookingFlowState createState() => BookingFlowState();
// }

// class BookingFlowState extends State<BookingFlow> {
//   int _currentStep = 0;
//   String? _selectedBarberName;
//   Service? _selectedService;
//   int? _barberId;
//   DateTime? _selectedDate;
//   String? _selectedTime;

//   void _resetBooking() {
//     setState(() {
//       _currentStep = 0;
//       _selectedBarberName = null;
//       _selectedService = null;
//       _barberId = null;
//       _selectedDate = null;
//       _selectedTime = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget content;

//     if (_currentStep == 0) {
//       content = BarberSelectionWidget(
//         barbershopName: widget.barbershopName,
//         barbers: widget.barbers,
//         onSelectBarber: (name, id) {
//           setState(() {
//             _selectedBarberName = name;
//             _barberId = id;
//             _currentStep = 1;
//           });
//         },
//         appointment: widget.appointment,
//         barberService: widget.barberService,
//         onCancel: () {
//           setState(() {
//             _resetBooking();
//           });
//         },
//       );
//     } else if (_currentStep == 1) {
//       content = ServicePick(
//         onServiceSelected: (service) {
//           setState(() {
//             _selectedService = service;
//             _currentStep = 2;
//           });
//         },
//         barberId: _barberId ?? 0,
//       );
//     } else if (_currentStep == 2) {
//       content = DatePick(
//         barberName: _selectedBarberName ?? 'Unknown Barber',
//         barberId: _barberId ?? 0,
//         service: _selectedService!,
//         onDateTimeSelected: (selectedDate, selectedTime) {
//           setState(() {
//             _selectedDate = selectedDate;
//             _selectedTime = selectedTime;
//             _currentStep = 3;
//           });
//         },
//       );
//     } else if (_currentStep == 3) {
//       content = Confirmation(
//         barberId: _barberId!,
//         barberName: _selectedBarberName!,
//         service: _selectedService!,
//         date: _selectedDate!,
//         time: _selectedTime!,
//         onBookingSuccess: () {
//           _resetBooking();
//         },
//       );
//     } else {
//       content = Container();
//     }

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         scrolledUnderElevation: 0.0,
//         toolbarHeight: _currentStep == 0 ? 0 : 50,
//         backgroundColor: _currentStep >= 2 ? background : Colors.transparent,
//         leading: _currentStep > 0
//             ? IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   setState(() {
//                     _currentStep--;
//                   });
//                 },
//               )
//             : null,
//       ),
//       body: content,
//     );
//   }
// }
