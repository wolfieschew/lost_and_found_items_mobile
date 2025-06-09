import 'package:flutter/foundation.dart';
import '../services/api/api_client.dart';
import '../models/user.dart';

class UserViewModel extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getCurrentUser() async {
    if (_currentUser != null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('v1/user');

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data);
      } else {
        _error = 'Failed to load user data: ${response.statusMessage}';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
