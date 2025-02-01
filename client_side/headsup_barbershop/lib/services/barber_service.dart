import 'package:headsup_barbershop/models/waitlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../models/barber.dart';
import '../models/barbershop.dart';
import '../models/schedule.dart';
import '../models/service.dart';
import '../models/user.dart';
import '../models/notification.dart';

class BarberService {
  static final BarberService _instance = BarberService._internal();

  factory BarberService() {
    return _instance;
  }

  BarberService._internal() {
    _initToken();
  }

  String? _token;

  Future<void> _initToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    if (_token == null) {
      await _initToken();
    }
    return {
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<List<Barber>> fetchBarbers({required int barbershopId}) async {
    final String endpoint = 'establishments/$barbershopId';

    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(endpoint, headers: headers);
      final List<dynamic> barberList = response['barbers'] ?? [];

      return barberList
          .map<Barber>((barber) => Barber.fromJson(barber))
          .toList();
    } catch (error) {
      throw Exception('Error fetching barbers: $error');
    }
  }

  Future<List<Service>> fetchServices({required int barberId}) async {
    try {
      final headers = await _getHeaders();
      final response =
          await apiFetcher.get('barbers/$barberId/services', headers: headers);
      final List<dynamic> services = response['services'] ?? [];

      return services.map((service) => Service.fromJson(service)).toList();
    } catch (error) {
      throw Exception('Error fetching services: $error');
    }
  }

  Future<List<Appointment>> fetchAppointments(String? endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get('barbers/appointments$endpoint',
          headers: headers);

      if (response == null || response.isEmpty) {
        return [];
      }
      if (response['content'] == null) {
        return [];
      }
      final List<dynamic> data = response['content'] as List<dynamic>;
      return data
          .map((appointmentJson) =>
              Appointment.fromJson(appointmentJson as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Error fetching appointments: $error');
    }
  }

  Future<Schedule> fetchSchedule({
    required int barberId,
    required String month,
  }) async {
    final String apiUrl = 'barbers/$barberId/schedule';

    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(
        apiUrl,
        headers: headers,
      );
      return Schedule.fromJson(response);
    } catch (error) {
      throw Exception('Error fetching schedule: $error');
    }
  }

  Future<List<String>> fetchTimes({
    required int barberId,
    required String date,
    required int serviceId,
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await apiFetcher.get(
        'barbers/$barberId/schedule?date=$date&service_id=$serviceId',
        headers: headers,
      );

      final List<dynamic> slots = response['slots'] ?? [];

      return slots.map((slot) => slot.toString()).toList();
    } catch (error) {
      throw Exception('Error fetching times: $error');
    }
  }

  Future<Map<String, dynamic>> fetchNotifications(int page) async {
    final String endpoint = 'notifications?page=$page';

    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(endpoint, headers: headers);

      final List<dynamic> content = response['content'] ?? [];
      final List<NotificationModel> notifications =
          content.map((json) => NotificationModel.fromJson(json)).toList();

      final bool hasNext = response['has_next'] ?? false;

      return {
        'notifications': notifications,
        'hasNext': hasNext,
      };
    } catch (error) {
      throw Exception('Error fetching notifications: $error');
    }
  }

  Future<void> scheduleWaitList(
      String startDate, String endDate, int serviceId, int barberId) async {
    final body = {
      'start_date': startDate,
      'end_date': endDate,
      'service_id': serviceId
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.post('barbers/$barberId/waitlist',
          body: body, headers: headers);
    } catch (e) {
      throw Exception('Error scheduling waitlist: $e');
    }
  }

  Future<List<Waitlist>> getWaitlist() async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get('users/waitlist', headers: headers);
      return (response as List<dynamic>)
          .map((json) => Waitlist.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error getting waitlist: $e');
    }
  }

  Future<void> deleteWaitlist(int waitlistId) async {
    try {
      final headers = await _getHeaders();
      await apiFetcher.delete('barbers/2/waitlist/$waitlistId',
          headers: headers);
    } catch (e) {
      throw Exception('Error deleting waitlist: $e');
    }
  }

  Future<void> updateUserInfo({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final body = {
      if (firstName != null && lastName != null) 'first_name': firstName,
      if (firstName != null && lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.put('users/update', body: body, headers: headers);
    } catch (e) {
      throw Exception('Error updating user info: $e');
    }
  }

  Future<void> bookAppointment(
      {required int barberId,
      required int serviceId,
      required DateTime date,
      required String time,
      String? note}) async {
    final endpoint = 'barbers/$barberId/appointments';
    final body = {
      'service_id': serviceId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': time,
      'note': note,
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.post(endpoint, body: body, headers: headers);
    } catch (e) {
      throw Exception('Error booking appointment: $e');
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final endpoint = 'appointments/$appointmentId/cancel';

    try {
      final headers = await _getHeaders();
      await apiFetcher.put(endpoint, headers: headers);
    } catch (e) {
      throw Exception('Error cancelling appointment: $e');
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final body = {
      'old_password': oldPassword,
      'new_password': newPassword,
      'password_confirmation': newPassword,
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.put('users/password', body: body, headers: headers);
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }

  Future<Barbershop> fetchHomeScreen() async {
    try {
      final headers = await _getHeaders();

      final response = await apiFetcher.get(
        'establishments/home',
        headers: headers,
      );
      return Barbershop.fromJson(response[0]);
    } catch (error) {
      throw Exception('Error fetching home screen data: $error');
    }
  }

  Future<User> getUserInfo() async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(
        'user',
        headers: headers,
      );
      return User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await apiFetcher
          .post('login', body: {'email': email, 'password': password});
      if (response is Map<String, dynamic> && response.containsKey('token')) {
        final User user = User.fromJson(response['user']);
        user.token = response['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', user.token ?? '');
        _token = user.token;
        return user;
      } else {
        throw Exception('Login failed: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
  }) async {
    const String endpoint = 'register';

    try {
      final response = await apiFetcher.post(endpoint, body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone_number': phoneNumber,
      });

      if (response is Map<String, dynamic> && response.containsKey('token')) {
        final String token = response['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        _token = token;
        return token;
      } else {
        throw Exception('Registration failed: ${response.toString()}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _token = null;
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }
}
