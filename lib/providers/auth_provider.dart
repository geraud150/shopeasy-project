import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy_flutter/models/user.dart';
import 'package:shopeasy_flutter/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();
  SharedPreferences? _prefs;

  AuthProvider(SharedPreferences? prefs) : _prefs = prefs {
    _loadToken();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> _loadToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs!.getString('auth_token');
    if (token != null) {
      _apiService.setAuthToken(token);
      await _loadUserFromToken();
    }
  }

  Future<void> _loadUserFromToken() async {
    try {
      final responseData = await _apiService.get('auth/me');
      _user = User.fromJson(responseData);
      notifyListeners();
    } catch (e) {
      await _prefs!.remove('auth_token');
      _apiService.setAuthToken(null);
      _user = null;
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final responseData = await _apiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      _user = User.fromJson(responseData);
      _apiService.setAuthToken(_user!.token);
      await _prefs!.setString('auth_token', _user!.token);
      notifyListeners();
      _setLoading(false);
      return _user!.token;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    _apiService.setAuthToken(null);
    await _prefs!.remove('auth_token');
    notifyListeners();
  }

  Future<void> updateUserProfile(String lastName, String email) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }

    _setLoading(true);
    try {
      final responseData = await _apiService.updateProfile(
        _user!.id,
        {
          'lastName': lastName,
          'email': email,
        },
      );

      _user = User.fromJson(responseData);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String firstName, String lastName, String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final responseData = await _apiService.post('users/register', {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      });

      _user = User.fromJson(responseData);
      _apiService.setAuthToken(_user!.token);
      await _prefs!.setString('auth_token', _user!.token);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
