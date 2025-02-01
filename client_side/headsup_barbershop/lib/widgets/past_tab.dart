import 'package:flutter/material.dart';
import 'package:headsup_barbershop/widgets/cards/app_history_card.dart';
import 'package:headsup_barbershop/widgets/colors.dart';
import '../services/barber_service.dart';
import '../models/appointment.dart';

class PastAppointments extends StatefulWidget {
  const PastAppointments({super.key});

  @override
  PastAppointmentsState createState() => PastAppointmentsState();
}

class PastAppointmentsState extends State<PastAppointments> {
  final ScrollController _scrollController = ScrollController();
  final List<Appointment> _appointments = [];

  bool _isLoading = false;
  final bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchAppointments() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newAppointments = await BarberService().fetchAppointments(
          '?history=true&order=desc&limit=$_limit&page=$_currentPage');
      setState(() {
        _appointments.addAll(newAppointments);
        _currentPage++; // Move to the next page
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _fetchAppointments();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
        return orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'canceled':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appointments.isEmpty && _isLoading) {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Минати термини',
              style: TextStyle(
                color: textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(color: orange),
          )
        ],
      );
    }
    if (_appointments.isEmpty) {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Минати термини',
              style: TextStyle(
                color: textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              'Нема минати термини',
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Минати термини',
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _appointments.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _appointments.length) {
                  return _hasMore
                      ? const Center(
                          child: CircularProgressIndicator(color: orange))
                      : const SizedBox.shrink();
                }
                final appointment = _appointments[index];
                final statusColor = _getStatusColor(appointment.status ?? '');
                final statusIcon = _getStatusIcon(appointment.status ?? '');
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: AppointmentListCard(
                    appointment: appointment,
                    statusColor: statusColor,
                    statusIcon: statusIcon,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
