import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api/api_client.dart';

class ActivityViewModel extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Item> _myItems = [];
  String? _error;
  bool _loading = false;
  int _currentPage = 1;
  bool _hasMorePages = true;
  String? _filterCategory;
  String? _filterType;

  List<Item> get myItems => _myItems;
  String? get error => _error;
  bool get loading => _loading;
  bool get hasMorePages => _hasMorePages;

  Future<void> getMyItems({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _myItems = [];
      _hasMorePages = true;
    }

    if (_loading || !_hasMorePages) return;

    try {
      _loading = true;
      _error = null;
      notifyListeners();

      // Tentukan endpoint yang sesuai berdasarkan filter
      String endpoint;
      final queryParams = <String, dynamic>{};

      // Jika ada filter aktif, gunakan endpoint search
      if ((_filterCategory != null && _filterCategory != "Category") ||
          (_filterType != null && _filterType != "Report")) {
        endpoint = 'search';

        // Tambahkan filter ke query params
        if (_filterCategory != null && _filterCategory != "Category") {
          queryParams['category'] = _filterCategory;
        }

        if (_filterType != null && _filterType != "Report") {
          queryParams['type'] = _filterType?.toLowerCase();
        }
      } else {
        // Jika tidak ada filter aktif, gunakan endpoint items/my
        endpoint = 'items/my';
      }

      // Tambahkan parameter pagination
      queryParams['page'] = _currentPage;

      // Debug untuk membantu diagnosa
      print("Endpoint: $endpoint");
      print("Query params: $queryParams");

      final response = await _apiClient.get(
        endpoint,
        queryParameters: queryParams,
      );

      // Debug response
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data;
        print("Data diterima: $data");

        if (data['data'] != null) {
          final List<Item> newItems =
              (data['data'] as List)
                  .map((item) => Item.fromJson(item))
                  .toList();

          print("Items ditemukan: ${newItems.length}");

          // Jika jumlah item kurang dari yang diharapkan, berarti tidak ada halaman lagi
          if (newItems.isEmpty || newItems.length < 10) {
            // Anggap 10 item per page
            _hasMorePages = false;
          }

          // Jika refresh, ganti semua item
          if (refresh) {
            _myItems = newItems;
          } else {
            _myItems.addAll(newItems);
          }

          if (newItems.isNotEmpty) {
            _currentPage++;
          }
        } else {
          // Tidak ada data yang diterima
          _hasMorePages = false;
        }
      } else {
        _error = 'Gagal memuat data: ${response.statusMessage}';
        print("Error: $_error");
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      print("Exception: $_error");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setFilterCategory(String? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterType(String? type) {
    _filterType = type;
    notifyListeners();
  }

  // Reset filter
  void resetFilters() {
    _filterCategory = null;
    _filterType = null;
    notifyListeners(); // Tambahkan ini agar UI diperbarui
  }

  Future<Map<String, dynamic>> updateItem(
    int itemId,
    Map<String, dynamic> itemData,
  ) async {
    try {
      _error = null;
      notifyListeners();

      print("Updating item $itemId with data: $itemData"); // Debug log

      final response = await _apiClient.put('items/$itemId', data: itemData);

      if (response.statusCode == 200) {
        // Update item in local list
        final updatedItem = Item.fromJson(response.data['data']);
        final index = _myItems.indexWhere((item) => item.id == itemId);
        if (index != -1) {
          _myItems[index] = updatedItem;
          notifyListeners();
        }

        return {
          'success': true,
          'message': 'Laporan berhasil diperbarui',
          'item': updatedItem,
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal memperbarui laporan: ${response.statusMessage}',
        };
      }
    } catch (e) {
      print("Error updating item: $e");
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteItem(int itemId) async {
    try {
      print("Deleting item with id: $itemId");

      final response = await _apiClient.delete('items/$itemId');

      if (response.statusCode == 200) {
        // Hapus item dari list lokal
        _myItems.removeWhere((item) => item.id == itemId);
        notifyListeners();

        return {
          'success': true,
          'message': 'Item berhasil dihapus',
          'itemId': itemId,
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus item: ${response.statusMessage}',
          'itemId': itemId,
        };
      }
    } catch (e) {
      print("Error deleting item: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'itemId': itemId,
      };
    }
  }
}
