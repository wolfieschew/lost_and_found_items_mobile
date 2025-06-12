import 'api/api_client.dart';
import 'package:dio/dio.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  // Method untuk update profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> userData,
  ) async {
    try {
      print("UserService: Mengirim request update profile...");
      print("UserService: Data yang akan diupdate: $userData");

      // ApiClient.post mengembalikan Response dari Dio
      final Response response = await _apiClient.put(
        'user/profile',
        data: userData,
      );

      print("UserService: Response status: ${response.statusCode}");
      print("UserService: Response data: ${response.data}");

      // Pastikan response.data adalah Map<String, dynamic>
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        print(
          "UserService: Unexpected response format: ${response.data.runtimeType}",
        );
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("UserService: Error saat update profile: $e");
      if (e is DioException) {
        print("UserService: DioError status: ${e.response?.statusCode}");
        print("UserService: DioError data: ${e.response?.data}");
      }
      throw Exception('Failed to update profile: $e');
    }
  }

  // Method untuk mendapatkan profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      print("UserService: Getting profile...");
      final Response response = await _apiClient.get('user/profile');

      print("UserService: Profile response status: ${response.statusCode}");
      print("UserService: Profile data: ${response.data}");

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Unexpected profile response format');
      }
    } catch (e) {
      print("UserService: Error getting profile: $e");
      throw Exception('Failed to get profile: $e');
    }
  }
}
