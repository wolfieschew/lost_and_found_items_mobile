// lib/viewmodels/item_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../services/repository/item_repository.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemRepository _itemRepository = ItemRepository();

  List<Item> _items = [];
  Item? _selectedItem;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Item> get items => _items;
  Item? get selectedItem => _selectedItem;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Mendapatkan semua barang atau dengan filter
  Future<void> getItems({
    String? status,
    String? category,
    String? type,
    String? search,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _itemRepository.getItems(
        status: status,
        category: category,
        type: type,
        search: search,
      );
    } catch (e) {
      _error = e.toString();
      print('Error in getItems: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mendapatkan detail barang
  Future<void> getItemDetail(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedItem = await _itemRepository.getItemDetail(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mencari barang
  Future<void> searchItems(String query) async {
    if (query.trim().isEmpty) {
      getItems();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _itemRepository.searchItems(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan barang baru
  Future<bool> addItem({
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItem = await _itemRepository.addItem(
        type: type,
        itemName: itemName,
        category: category,
        dateOfEvent: dateOfEvent,
        description: description,
        email: email,
        phoneNumber: phoneNumber,
        location: location,
        photoFile: photoFile,
      );

      // Refresh list after adding
      _items = [newItem, ..._items];

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Memperbarui data barang
  Future<bool> updateItem(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedItem = await _itemRepository.updateItem(id, data);

      // Update list
      final index = _items.indexWhere((item) => item.id == id);
      if (index >= 0) {
        _items[index] = updatedItem;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Menghapus barang
  Future<bool> deleteItem(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _itemRepository.deleteItem(id);

      if (result) {
        // Remove from list
        _items.removeWhere((item) => item.id == id);
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Filter untuk tampilan barang hilang saja
  Future<void> getLostItems() async {
    await getItems(type: 'hilang');
  }

  // Filter untuk tampilan barang ditemukan saja
  Future<void> getFoundItems() async {
    await getItems(type: 'ditemukan');
  }

  void clearItems() {
    _items = [];
    _isLoading = false;
    notifyListeners();
  }
}
