import 'dart:io';

import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralService {
  String? _token;

  GeneralService() {
    _initToken();
  }

  Future<void> _initToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-api-key': 'af2a3faf-96c9-4db4-b998-5cbf61f46944',
    };
  }

  Future<void> sendDeviceToken(String deviceToken) async {
    String platform = Platform.isIOS ? 'iOS' : 'android';
    const endpoint = 'app/device-token';
    final headers = await _getHeaders();
    final body = {
      'platform': platform,
      'token': deviceToken,
    };

    try {
      await apiFetcher.post(endpoint, body: body, headers: headers);
    } catch (error) {
      throw Exception('Failed to send device token: $error');
    }
  }
}
