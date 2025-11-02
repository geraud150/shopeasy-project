import 'package:flutter/material.dart';
import 'package:shopeasy_flutter/models/user.dart';
import 'package:shopeasy_flutter/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Setters internes
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // 🔐 Connexion
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
      notifyListeners();
      _setLoading(false);
      return _user!.token;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  // 🔓 Déconnexion
  Future<void> logout() async {
    _user = null;
    _apiService.setAuthToken(null);
    notifyListeners();
  }

  // 📝 Mise à jour du profil
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

  // 🆕 Inscription
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

      if (_user?.token == null || _user!.token.isEmpty) {
  throw Exception('Failed to sign up: No token received');
}

      _user = User.fromJson(responseData);
      _apiService.setAuthToken(_user!.token);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
