import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;
  User? _user;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;
  User? get user => _user;

  AuthViewModel() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await _authRepository.isLoggedIn();
    if (_isLoggedIn) {
      _user = await _authRepository.getCurrentUser();
    }
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await _authRepository.getToken();
  }

  Future<bool> register(
    String name,
    String email,
    String phone, // Tambahkan parameter phone
    String password,
    String passwordConfirmation,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authRepository.register(
        name,
        email,
        phone, // Teruskan parameter phone ke repository
        password,
        passwordConfirmation,
      );

      // Di sini kita TIDAK set isLoggedIn = true
      // Karena kita ingin user login manual setelah register

      return user != null; // Return true jika berhasil
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      print("Register error: $_error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print("AuthViewModel: Attempting login");
      _user = await _authRepository.login(email, password);
      _isLoggedIn = _user != null;
      print("AuthViewModel: Login success: $_isLoggedIn");
      return _isLoggedIn;
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      print("AuthViewModel: Login error: $_error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isLoggedOut = false;
  bool get isLoggedOut => _isLoggedOut;

  Future<void> logout() async {
    _isLoading = true;
    // Set flag logout untuk mencegah API calls
    _isLoggedOut = true;
    notifyListeners();

    try {
      await _authRepository.logout();
    } finally {
      // Reset state user
      _isLoggedIn = false;
      _user = null;

      // Selesai loading
      _isLoading = false;
      notifyListeners();

      print("User logged out successfully, preventing further API calls");
    }
  }

  // Tambahkan method ini untuk memeriksa apakah API calls diperbolehkan
  bool shouldAllowApiCall() {
    return _isLoggedIn && !_isLoggedOut;
  }

  // Method untuk reset state setelah navigasi ke login page selesai
  void resetLogoutState() {
    _isLoggedOut = false;
    notifyListeners();
  }

  void resetState() {
    _user = null;
    _isLoggedIn = false;
    _isLoggedOut = false;
    _error = null;
    notifyListeners();
  }
}
