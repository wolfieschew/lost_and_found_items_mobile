// lib/services/repository/item_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../models/item.dart';
import '../api/api_client.dart';

class ItemRepository {
  final ApiClient _apiClient = ApiClient();

  // Mendapatkan daftar barang dengan filter opsional
  Future<List<Item>> getItems({
    String? status,
    String? category,
    String? type,
    String? search,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};

      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;
      if (type != null) queryParams['type'] = type;
      if (search != null) queryParams['search'] = search;

      final response = await _apiClient.get(
        '/items',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<Item> items = [];

        // Handle pagination or direct data
        if (data['data'] != null) {
          items =
              (data['data'] as List)
                  .map((item) => Item.fromJson(item))
                  .toList();
        } else {
          items = (data as List).map((item) => Item.fromJson(item)).toList();
        }

        return items;
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting items: $e');
      throw Exception('Terjadi kesalahan saat mengambil data barang');
    }
  }

  // Mendapatkan detail barang berdasarkan ID
  Future<Item> getItemDetail(int id) async {
    try {
      final response = await _apiClient.get('/items/$id');

      if (response.statusCode == 200) {
        return Item.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal memuat detail barang');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail barang');
    }
  }

  // Mencari barang
  Future<List<Item>> searchItems(String query) async {
    return getItems(search: query);
  }

  // Menambahkan barang baru
  Future<Item> addItem({
    required String type,
    required String itemName,
    required String category,
    required String dateOfEvent,
    required String description,
    required String email,
    required String phoneNumber,
    required String location,
    File? photoFile,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'type': type,
        'item_name': itemName,
        'category': category,
        'date_of_event': dateOfEvent,
        'description': description,
        'email': email,
        'phone_number': phoneNumber,
        'location': location,
      });

      if (photoFile != null) {
        String fileName = photoFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(photoFile.path, filename: fileName),
          ),
        );
      }

      final response = await _apiClient.post('/items', data: formData);

      if (response.statusCode == 201) {
        return Item.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal menambahkan barang');
      }
    } catch (e) {
      print('Error adding item: $e');
      throw Exception('Terjadi kesalahan saat menambahkan barang');
    }
  }

  // Memperbarui data barang
  Future<Item> updateItem(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/items/$id', data: data);

      if (response.statusCode == 200) {
        return Item.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal memperbarui barang');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memperbarui barang');
    }
  }

  // Menghapus barang
  Future<bool> deleteItem(int id) async {
    try {
      final response = await _apiClient.delete('/items/$id');

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus barang');
    }
  }
}
