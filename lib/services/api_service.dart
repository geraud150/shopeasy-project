import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:shopeasy_flutter/models/category.dart';

class ApiService {
  static const String baseUrl = 'https://shopeasy-backend-levs.onrender.com/api';
  String? _token;
  final Logger _logger = Logger();

  void setAuthToken(String? token) {
    _token = token;
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }

    _logger.i('POST Request URL: ${Uri.parse('$baseUrl/$endpoint')}');
    _logger.i('POST Request Headers: ${{
      'Content-Type': 'application/json; charset=UTF-8',
      if (_token != null) 'Authorization': 'Bearer $_token',
    }}');
    _logger.d('POST Request Body: ${jsonEncode(data)}');

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              if (_token != null) 'Authorization': 'Bearer $_token',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      _logger.i('POST Response Status: ${response.statusCode}');
      _logger.d('POST Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to post data: ${errorData['message'] ?? response.body}');
      }
    } on http.ClientException catch (e) {
      _logger.e('Failed to connect to the server: $e');
      throw Exception('Failed to connect to the server: $e');
    } on FormatException catch (e) {
      _logger.e('Failed to decode the response: $e');
      throw Exception('Failed to decode the response: $e');
    } on TimeoutException catch (e) {
      _logger.e('Request timed out: $e');
      throw Exception('Request timed out: $e');
    } catch (e) {
      _logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }

    _logger.i('GET Request URL: ${Uri.parse('$baseUrl/$endpoint')}');
    _logger.i('GET Request Headers: ${{
      'Content-Type': 'application/json; charset=UTF-8',
      if (_token != null) 'Authorization': 'Bearer $_token',
    }}');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      ).timeout(const Duration(seconds: 10));

      _logger.i('GET Response Status: ${response.statusCode}');
      _logger.d('GET Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to load data: ${errorData['message'] ?? response.body}');
      }
    } on http.ClientException catch (e) {
      _logger.e('Failed to connect to the server: $e');
      throw Exception('Failed to connect to the server: $e');
    } on FormatException catch (e) {
      _logger.e('Failed to decode the response: $e');
      throw Exception('Failed to decode the response: $e');
    } on TimeoutException catch (e) {
      _logger.e('Request timed out: $e');
      throw Exception('Request timed out: $e');
    } catch (e) {
      _logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      int userId, Map<String, dynamic> data) async {
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      throw Exception('No internet connection');
    }

    _logger.i('PUT Request URL: ${Uri.parse('$baseUrl/users/$userId')}');
    _logger.i('PUT Request Headers: ${{
      'Content-Type': 'application/json; charset=UTF-8',
      if (_token != null) 'Authorization': 'Bearer $_token',
    }}');
    _logger.d('PUT Request Body: ${jsonEncode(data)}');

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/users/$userId'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              if (_token != null) 'Authorization': 'Bearer $_token',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      _logger.i('PUT Response Status: ${response.statusCode}');
      _logger.d('PUT Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to update profile: ${errorData['message'] ?? response.body}');
      }
    } on http.ClientException catch (e) {
      _logger.e('Failed to connect to the server: $e');
      throw Exception('Failed to connect to the server: $e');
    } on FormatException catch (e) {
      _logger.e('Failed to decode the response: $e');
      throw Exception('Failed to decode the response: $e');
    } on TimeoutException catch (e) {
      _logger.e('Request timed out: $e');
      throw Exception('Request timed out: $e');
    } catch (e) {
      _logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
    }

    Future<List<Category>> fetchCategories() async {
  try {
    final response = await get('api/categories');
    return (response as List).map((categoryJson) => Category.fromJson(categoryJson)).toList();
  } catch (e) {
    throw Exception('Failed to load categories');
  }
}

  }

