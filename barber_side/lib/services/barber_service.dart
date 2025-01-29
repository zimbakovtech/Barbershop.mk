import 'package:barbers_mk/models/availability.dart';
import '../models/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../models/barber.dart';
import '../models/barbershop.dart';
import '../models/client.dart';
import '../models/schedule.dart';
import '../models/service.dart';
import '../models/user.dart';

class BarberService {
  String? _token;

  BarberService() {
    _initToken();
  }

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

      final List<dynamic> data = response['content'] as List<dynamic>;
      return data
          .map((appointmentJson) =>
              Appointment.fromJson(appointmentJson as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Error fetching appointments: $error');
    }
  }

  Future<List<Service>> fetchAllServices() async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get('services', headers: headers);

      if (response is List) {
        return response
            .map((item) => Service.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format: expected a list');
      }
    } catch (error) {
      throw Exception('Error fetching services: $error');
    }
  }

  Future<void> addService(
      int barberId, int serviceId, int price, int duration) async {
    final body = {
      'service_id': serviceId,
      'price': price,
      'duration': duration,
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.post('barbers/$barberId/services',
          body: body, headers: headers);
    } catch (error) {
      throw Exception('Error adding service: $error');
    }
  }

  Future<void> deleteService(int serviceId) async {
    try {
      final headers = await _getHeaders();
      await apiFetcher.delete('barbers/services/$serviceId', headers: headers);
    } catch (error) {
      throw Exception('Error deleting service: $error');
    }
  }

  Future<List<Client>> fetchClients({String? search}) async {
    String apiUrl = 'barbers/clients';
    Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(uri.toString(), headers: headers);

      return (response['content'] as List<dynamic>)
          .map((client) => Client.fromJson(client as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Error fetching clients: $error');
    }
  }

  Future<List> fetchSlots({required String date}) async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get('barbers/schedule/slots?date=$date',
          headers: headers);

      return response['slots'];
    } catch (error) {
      throw Exception('Error fetching slots: $error');
    }
  }

  Future<Schedule> fetchSchedule({
    required int barberId,
    required String month,
  }) async {
    final String apiUrl = 'barbers/$barberId/schedule?month=$month';

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

  Future<List<WorkingHours>> fetchWorkingHours(int barberId) async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get('barbers/$barberId/availabilities',
          headers: headers);
      final schedule = response['schedule'] as Map<String, dynamic>;
      return schedule.entries.map((entry) {
        final day = entry.key;
        final timeSlots = entry.value as List<dynamic>;
        return WorkingHours.fromJson(day, timeSlots);
      }).toList();
    } catch (error) {
      throw Exception('Error fetching working hours: $error');
    }
  }

  Future<void> deleteAvailability(int barberId, String day) async {
    final endpoint = 'barbers/$barberId/availabilities?day_of_week=$day';

    try {
      final headers = await _getHeaders();
      await apiFetcher.delete(endpoint, headers: headers);
    } catch (e) {
      throw Exception('Error deleting availability: $e');
    }
  }

  Future<void> updateAvailability(
      {required int barberId,
      required String day,
      required String start,
      required String end}) async {
    final body = {
      'barber_id': barberId,
      'day_of_week': day,
      'start_time': start,
      'end_time': end,
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.post('barbers/$barberId/availabilities',
          body: body, headers: headers);
    } catch (e) {
      throw Exception('Error updating availability: $e');
    }
  }

  Future<void> bookAppointment(int barberId, String clientName, int serviceId,
      DateTime date, String time) async {
    final endpoint = 'barbers/$barberId/appointments';
    final body = {
      'service_id': serviceId,
      'client_name': clientName,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': time,
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

  Future<void> updateService(
      {required int serviceId,
      required int price,
      required int duration,
      required int userId}) async {
    final body = {
      'service_id': serviceId,
      'price': price,
      'duration': duration,
    };

    try {
      final headers = await _getHeaders();
      await apiFetcher.post('barbers/$userId/services',
          body: body, headers: headers);
    } catch (e) {
      throw Exception('Error updating service: $e');
    }
  }

  Future<void> updateSlots(List slots, String date, bool toggle) async {
    final body = {'date': date, 'slots': slots, "open": toggle};

    try {
      final headers = await _getHeaders();
      await apiFetcher.post('barbers/schedule/slots',
          body: body, headers: headers);
    } catch (e) {
      throw Exception('Error updating slots: $e');
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

      // final response = await apiFetcher.get(
      //   'establishments',
      //   headers: headers,
      // );

      Map<String, dynamic> response = {
        "id": 2,
        "name": "Head's Up Barbershop",
        "short_name": "Head's Up",
        "address": {
          "street": "Goce Delcev 23",
          "city_id": 10,
          "city_name": "Strumica"
        },
        "phone_number": "077854332",
        "image_url":
            "https://barber-cdn.s3.eu-central-1.amazonaws.com/images/establishments/1729724417.jpg",
        "rating": 5,
        "user_favorite": false,
        "user_home_screen": false,
        "created_at": "2024-10-22T23:49:42Z",
        "updated_at": "2025-01-23T10:15:32Z",
        "barbers": [
          {
            "id": 2,
            "full_name": "Trajce Zlatkov",
            "email": "trajce@zlatkov.com",
            "phone_number": "077854332",
            "profile_picture":
                "https://images.newrepublic.com/9bba0e56c589fb3e06191969202abb446327a86a.jpeg?auto=format&fit=crop&crop=faces&q=65&w=1000&h=undefined&ar=3%3A2&ixlib=react-9.0.3&w=1000",
            "average_rating": 0,
            "establishment": {
              "id": 2,
              "name": "Head's Up Barbershop",
              "short_name": "Head's Up",
              "rating": 0,
              "user_favorite": false,
              "user_home_screen": false,
              "barbers": null,
              "created_at": "0001-01-01T00:00:00Z",
              "updated_at": "0001-01-01T00:00:00Z"
            },
            "created_at": "0001-01-01T00:00:00Z",
            "updated_at": "0001-01-01T00:00:00Z"
          },
          {
            "id": 2,
            "full_name": "Marko Petrov",
            "email": "marko@petrov.com",
            "phone_number": "077854332",
            "profile_picture":
                "https://images.squarespace-cdn.com/content/v1/5d52feb1aa6f990001929012/e89c181b-dd09-420e-8e80-06aa47a5a37a/todecacho.png",
            "average_rating": 0,
            "establishment": {
              "id": 2,
              "name": "Head's Up Barbershop",
              "short_name": "Head's Up",
              "rating": 0,
              "user_favorite": false,
              "user_home_screen": false,
              "barbers": null,
              "created_at": "0001-01-01T00:00:00Z",
              "updated_at": "0001-01-01T00:00:00Z"
            },
            "created_at": "0001-01-01T00:00:00Z",
            "updated_at": "0001-01-01T00:00:00Z"
          }
        ]
      };
      return Barbershop.fromJson(response);
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

  Future<Client> getClientById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(
        'barbers/clients/$id',
        headers: headers,
      );
      return Client.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }

  Future<Barber> getBarberInfo() async {
    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(
        'barbers/me',
        headers: headers,
      );
      return Barber.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching barber info: $e');
    }
  }

  // Add these two new methods to your BarberService class
  Future<List<ServiceStat>> getServiceStats() async {
    try {
      final headers = await _getHeaders();
      final response =
          await apiFetcher.get('statistics/services/popular', headers: headers);
      return (response as List)
          .map((json) => ServiceStat.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching service statistics: $e');
    }
  }

  Future<CustomerStats> getCustomerStats() async {
    try {
      final headers = await _getHeaders();
      final response =
          await apiFetcher.get('statistics/customers', headers: headers);
      return CustomerStats.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching customer statistics: $e');
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
