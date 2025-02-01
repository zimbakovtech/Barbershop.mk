import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class RequestOptions {
  final String method;
  final Map<String, String>? headers;
  final int timeout;
  final dynamic body;

  RequestOptions({
    this.method = 'GET',
    this.headers,
    this.timeout = 8000,
    this.body,
  });
}

class ApiFetcher {
  final String baseURL;
  final Map<String, String> defaultHeaders;
  String? _token;

  ApiFetcher(this.baseURL, this.defaultHeaders);

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<dynamic> fetchData(
    String endpoint, {
    RequestOptions? options,
  }) async {
    final url = Uri.parse('$baseURL/$endpoint');
    final requestOptions = options ?? RequestOptions();

    final headers = {
      ...defaultHeaders,
      'Authorization': 'Bearer $_token',
      if (requestOptions.headers != null) ...requestOptions.headers!,
    };

    try {
      final response = await _sendRequest(
        url,
        method: requestOptions.method,
        headers: headers,
        body: requestOptions.body,
        timeout: requestOptions.timeout,
      );

      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return null;
        }
      } else {
        throw Exception(
            'Failed with status: $statusCode, body: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request to $url timed out');
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  Future<http.Response> _sendRequest(
    Uri url, {
    required String method,
    Map<String, String>? headers,
    dynamic body,
    required int timeout,
  }) async {
    http.Response response;
    final client = http.Client();
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await client
              .get(url, headers: headers)
              .timeout(Duration(milliseconds: timeout));
          break;
        case 'POST':
          response = await client
              .post(url, headers: headers, body: json.encode(body))
              .timeout(Duration(milliseconds: timeout));
          break;
        case 'PUT':
          response = await client
              .put(url, headers: headers, body: json.encode(body))
              .timeout(Duration(milliseconds: timeout));
          break;
        case 'DELETE':
          response = await client
              .delete(url, headers: headers)
              .timeout(Duration(milliseconds: timeout));
          break;
        case 'PATCH':
          response = await client
              .patch(url, headers: headers, body: json.encode(body))
              .timeout(Duration(milliseconds: timeout));
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      return response;
    } finally {
      client.close();
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) {
    return fetchData(
      endpoint,
      options: RequestOptions(method: 'GET', headers: headers),
    );
  }

  Future<dynamic> post(String endpoint,
      {dynamic body, Map<String, String>? headers}) {
    return fetchData(
      endpoint,
      options: RequestOptions(method: 'POST', body: body, headers: headers),
    );
  }

  Future<dynamic> put(String endpoint,
      {dynamic body, Map<String, String>? headers}) {
    return fetchData(
      endpoint,
      options: RequestOptions(method: 'PUT', body: body, headers: headers),
    );
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) {
    return fetchData(
      endpoint,
      options: RequestOptions(method: 'DELETE', headers: headers),
    );
  }

  Future<dynamic> patch(String endpoint,
      {dynamic body, Map<String, String>? headers}) {
    return fetchData(
      endpoint,
      options: RequestOptions(method: 'PATCH', body: body, headers: headers),
    );
  }
}

final apiFetcher = ApiFetcher(
  'https://barber.prodanov.me/api/v1',
  {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'x-api-key': 'af2a3faf-96c9-4db4-b998-5cbf61f46944',
    'Accept-Language': 'mk',
  },
);
