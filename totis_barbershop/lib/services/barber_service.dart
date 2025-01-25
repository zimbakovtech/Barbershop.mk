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
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-api-key': 'af2a3faf-96c9-4db4-b998-5cbf61f46944',
    };
  }

  Future<void> bookAppointment(
      int barberId, int serviceId, DateTime date, String time) async {
    final endpoint = 'barbers/$barberId/appointments';
    final body = {
      'service_id': serviceId,
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

  Future<List<Barbershop>> fetchBarbershops(
      {String? search, String? cityId}) async {
    const String apiUrl = 'establishments';
    Map<String, String> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (cityId != null && cityId != 'Any') {
      queryParams['city'] = cityId;
    }

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final headers = await _getHeaders();
      final response = await apiFetcher.get(uri.toString(), headers: headers);
      final List<dynamic> data = response['content'];

      return data.map((shop) => Barbershop.fromJson(shop)).toList();
    } catch (error) {
      throw Exception('Error fetching barbershops: $error');
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

  Future<List<Client>> fetchClients() async {
    try {
      final headers = await _getHeaders();
      final response =
          await apiFetcher.get('barbers/clients', headers: headers);

      return (response as List<dynamic>)
          .map((client) => Client.fromJson(client as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Error fetching clients: $error');
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

  Future<Schedule> fetchSchedule({
    required int barberId,
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
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await apiFetcher.get(
        'barbers/$barberId/schedule?date=$date',
        headers: headers,
      );

      final List<dynamic> slots = response['slots'] ?? [];

      return slots.map((slot) => slot.toString()).toList();
    } catch (error) {
      throw Exception('Error fetching times: $error');
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
        "name": "Toti's Barbershop",
        "short_name": "Toti's",
        "address": {
          "street": "Ul. Elizabet br. 21",
          "city_id": 10,
          "city_name": "Strumica"
        },
        "phone_number": "078121244",
        "image_url":
            "https://barber-cdn.s3.eu-central-1.amazonaws.com/images/establishments/1729724417.jpg",
        "rating": 3,
        "user_favorite": false,
        "user_home_screen": false,
        "created_at": "2024-10-22T23:49:42Z",
        "updated_at": "2025-01-23T10:15:32Z",
        "barbers": [
          {
            "id": 2,
            "full_name": "Toti Nikolov",
            "email": "toti@nikolov.com",
            "phone_number": "078812111",
            "profile_picture":
                "https://barber-cdn.s3.eu-central-1.amazonaws.com/images/establishments/1730587390.png",
            "average_rating": 0,
            "establishment": {
              "id": 2,
              "name": "Toti's Barbershop",
              "short_name": "Toti's",
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
