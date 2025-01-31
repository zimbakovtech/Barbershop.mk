import 'package:flutter/material.dart';
import '../services/barber_service.dart';
import '../models/notification.dart';
import '../widgets/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ScrollController _scrollController = ScrollController();
  final List<NotificationModel> _notifications = [];
  int _currentPage = 1;
  bool _hasNext = true;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasNext &&
        !_isLoading) {
      _loadNextPage();
    }
  }

  Future<void> _loadNotifications() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await BarberService().fetchNotifications(_currentPage);
      setState(() {
        _notifications.addAll(response['notifications']);
        _hasNext = response['hasNext'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (!_hasNext || _isLoading) return;
    setState(() => _currentPage++);
    await _loadNotifications();
  }

  /// Pull-to-refresh function
  Future<void> _refreshNotifications() async {
    setState(() {
      _currentPage = 1;
      _hasNext = true;
      _notifications.clear();
    });

    try {
      final response = await BarberService().fetchNotifications(_currentPage);
      setState(() {
        _notifications.addAll(response['notifications']);
        _hasNext = response['hasNext'];
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: background,
        title: const Text('Известувања', style: TextStyle(color: textPrimary)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Text('Грешка: $_error', style: const TextStyle(color: navy)),
      );
    }

    if (_notifications.isEmpty && !_isLoading) {
      return const Center(
        child: Text('Нема нови известувања', style: TextStyle(color: navy)),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      color: orange,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _notifications.length + (_hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _notifications.length) {
            return _buildLoader();
          }
          return NotificationCard(notification: _notifications[index]);
        },
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator(color: orange)),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: navy),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Timestamp Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  notification.formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Message Content
            Text(
              notification.message,
              style: const TextStyle(
                color: textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
