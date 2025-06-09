import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';
import '../api/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Metode login sesuai dengan AuthController Laravel
  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/login',
        data: {
          'email': email,
          'password': password,
          'device_name': 'flutter_app',
        },
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final token = response.data['token']; // token langsung dari respons

        // Simpan token
        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
        }

        // Buat objek User dari response
        final user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          token: token,
        );

        return user;
      } else {
        throw Exception('Login gagal: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 422) {
          // Validasi error dari Laravel
          final errors = e.response?.data['errors'];
          if (errors != null && errors['email'] != null) {
            throw Exception(errors['email'][0]);
          }
        }
        throw Exception(
          e.response?.data['message'] ?? 'Email atau password salah',
        );
      }
      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Metode register sesuai dengan AuthController Laravel
  Future<User?> register(
    String name,
    String email,
    String phone, // Tambahkan parameter phone
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _apiClient.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone, // Sertakan phone dalam data request
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        final userData = response.data['user'];
        final token =
            response.data['access_token']; // access_token dari response

        // Simpan token
        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
        }

        // Buat objek User dari response
        final user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'] ?? '',
          phone: userData['phone'] ?? '', // Tambahkan phone ke objek User
          token: token,
        );

        return user;
      } else {
        throw Exception('Registrasi gagal');
      }
    } on DioException catch (e) {
      // Exception handling tetap sama...
    }
  }

  // Metode logout
  Future<bool> logout() async {
    try {
      // Set flag untuk mencegah API calls selama logout
      ApiClient.isLoggingOut = true;

      // Ambil token terlebih dahulu
      final token = await _storage.read(key: 'auth_token');

      if (token != null) {
        final response = await _apiClient.post('/logout', data: {});
        print('Logout response: ${response.statusCode}');
      }

      // Hapus token lokal
      await _storage.delete(key: 'auth_token');
      return true;
    } catch (e) {
      print('Logout error: $e');
      await _storage.delete(key: 'auth_token');
      return true;
    } finally {
      // Flag tetap true - akan direset setelah navigasi selesai
    }
  }

  // Cek status login
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        print('Token tidak ditemukan, user tidak login');
        return false;
      }

      print('Token ditemukan, validasi dengan server...');

      try {
        // Validasi token dengan API
        final response = await _apiClient.get('/user');
        return response.statusCode == 200;
      } catch (e) {
        print('Error validasi token: $e');
        // PENTING: Hapus token jika tidak valid
        await _storage.delete(key: 'auth_token');
        return false;
      }
    } catch (e) {
      print('Error umum cek login: $e');
      return false;
    }
  }

  // Ambil user yang sedang login
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/user');

      if (response.statusCode == 200) {
        // API mengembalikan data dalam struktur { data: { ... } }
        final userData = response.data['data'] ?? response.data;
        print('API Response: $userData');

        return User(
          id: userData['id'],
          name: userData['name'], // "Emul Bunny"
          email: userData['email'],
          firstName: userData['first_name'], // "Emul"
          lastName: userData['last_name'], // "Bunny"
          phone: userData['phone'],
          nim: userData['nim'],
          address: userData['address'],
          role: userData['role'],
          // Gunakan profile_photo_url bukan profile_picture
          profilePicture: userData['profile_photo_url'],
        );
      }
      return null;
    } catch (e) {
      print('Error in getCurrentUser: $e');
      return null;
    }
  }
}
