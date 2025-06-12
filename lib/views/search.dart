import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'item_detail.dart';
import '../models/item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controllers & state variables
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedType;

  // Search results state
  bool _isLoading = false;
  List<dynamic> _searchResults = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initial search when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _search();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Search function
  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (_searchController.text.isNotEmpty) {
        queryParams['search'] = _searchController.text;
      }
      if (_selectedCategory != null) {
        queryParams['category'] = _selectedCategory!;
      }
      if (_selectedType != null) {
        queryParams['type'] = _selectedType!;
      }

      // Get authentication token
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final token = await authViewModel.getToken();

      // Create URI with query parameters
      final baseUrl = 'http://127.0.0.1:8000/api/v1/search';

      // If running on web, use localhost. If on emulator, use 10.0.2.2
      final uri =
          kIsWeb
              ? Uri.parse(baseUrl).replace(queryParameters: queryParams)
              : Uri.parse(
                baseUrl.replaceAll('127.0.0.1', '10.0.2.2'),
              ).replace(queryParameters: queryParams);

      print('Searching with URL: $uri');

      // Make the API call
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults =
              data['data']; // Adjust based on your API response structure
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to search: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
      print('Search error: $e');
    }
  }

  String _getCorrectImageUrl(dynamic item) {
    // Debug untuk melihat apa yang ada di respon API
    print(
      'Photo data: ${item['photo_url'] ?? item['photo_path'] ?? 'Tidak ada gambar'}',
    );

    // Cek photo_url dari respons API
    if (item['photo_url'] != null) {
      return kIsWeb
          ? item['photo_url']
          : item['photo_url'].toString().replaceAll('127.0.0.1', '10.0.2.2');
    }

    // Fallback ke display_image_url jika ada
    if (item['display_image_url'] != null) {
      return kIsWeb
          ? item['display_image_url']
          : item['display_image_url'].toString().replaceAll(
            '127.0.0.1',
            '10.0.2.2',
          );
    }

    // Fallback ke photo_path
    if (item['photo_path'] != null) {
      if (item['photo_path'].toString().startsWith('http')) {
        return kIsWeb
            ? item['photo_path']
            : item['photo_path'].toString().replaceAll('127.0.0.1', '10.0.2.2');
      } else {
        final baseUrl =
            kIsWeb
                ? 'http://127.0.0.1:8000/storage/'
                : 'http://10.0.2.2:8000/storage/';
        return baseUrl + item['photo_path'];
      }
    }

    // Fallback ke gambar default jika tidak ada
    return 'https://via.placeholder.com/150?text=No+Image';
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Pilih Kategori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCategoryTile('Semua Kategori', null),
                      _buildCategoryTile('KTM', 'KTM'),
                      _buildCategoryTile('Dokumen Pribadi', 'Dokumen Pribadi'),
                      _buildCategoryTile(
                        'Aksesoris Pribadi',
                        'Aksesoris Pribadi',
                      ),
                      _buildCategoryTile('Elektronik', 'Elektronik'),
                      _buildCategoryTile('Alat Tulis', 'Alat Tulis'),
                      _buildCategoryTile('Kunci', 'Kunci'),
                      _buildCategoryTile('Buku', 'Buku'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method untuk membuat tile kategori
  Widget _buildCategoryTile(String title, String? category) {
    final bool isSelected =
        (category == null && _selectedCategory == null) ||
        _selectedCategory == category;

    return ListTile(
      title: Text(title),
      trailing:
          isSelected
              ? Container(
                width: 20, // Ukuran sedikit lebih besar
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF004274), // Warna ungu seperti gambar
                  // Tambahkan shadow untuk efek lebih baik
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              )
              : Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
              ), // Lingkaran kosong untuk yang tidak terseleksi
      tileColor:
          isSelected
              ? const Color.fromARGB(255, 237, 245, 252)
              : null, // Warna background yang lebih soft ungu
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
        Navigator.pop(context);
        _search();
      },
    );
  }

  // Helper method to select/deselect category
  void _selectCategory(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null; // Deselect if already selected
      } else {
        _selectedCategory = category;
      }
    });
    _search(); // Search immediately when category changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            const Text(
              'Search',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Search field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.search),
                  hintText: 'Search Report',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _search,
                  ),
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(height: 16),

            // Item type filter (Lost/Found)
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Kehilangan'),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF004274).withOpacity(0.2),
                  selected: _selectedType == 'hilang',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? 'hilang' : null;
                    });
                    _search();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Ditemukan'),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF004274).withOpacity(0.2),
                  selected: _selectedType == 'ditemukan',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? 'ditemukan' : null;
                    });
                    _search();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Kategori',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: Text(_selectedCategory ?? 'Semua Kategori'),
                  onPressed: _showCategoryBottomSheet,
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // Tambahkan ini untuk background putih
                    foregroundColor: const Color(
                      0xFF004274,
                    ), // Warna teks dan ikon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search results
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF004274),
          unselectedItemColor: Colors.black87,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 0,
          onTap: (index) {
            if (index != 0) {
              Navigator.pop(context);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Feedback'),
          ],
        ),
      ),
    );
  }

  // Widget to show search results with various states (loading, error, empty, results)
  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada hasil pencarian',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  item['photo_url'] != null || item['photo_path'] != null
                      ? CachedNetworkImage(
                        imageUrl: _getCorrectImageUrl(item),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                            ),
                        errorWidget: (context, url, error) {
                          print('Error loading image: $url - $error');
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          );
                        },
                      )
                      : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
            ),
            title: Text(
              item['item_name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${item['category']} • ${_formatDate(item['date_of_event'])}',
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    item['type'] == 'hilang'
                        ? Colors.red[100]
                        : Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item['type'] == 'hilang' ? 'Kehilangan' : 'Ditemukan',
                style: TextStyle(
                  color: item['type'] == 'hilang' ? Colors.red : Colors.green,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ItemDetailScreen(item: Item.fromJson(item)),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Helper to format date from API
  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "${date.day}/${date.month}/${date.year}";
  }

  // Show item details in bottom sheet
  void _showItemDetails(BuildContext context, dynamic item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF9F9F9),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Text(
                  item['item_name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item['category'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        item['type'] == 'hilang'
                            ? Colors.red[100]
                            : Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['type'] == 'hilang' ? "Kehilangan" : "Ditemukan",
                    style: TextStyle(
                      color:
                          item['type'] == 'hilang' ? Colors.red : Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (item['photo_path'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: _getCorrectImageUrl(item),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) {
                        print('Error loading detail image: $url - $error');
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, size: 40),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),

                const Divider(),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text("Tanggal: ${_formatDate(item['date_of_event'])}"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16),
                    const SizedBox(width: 8),
                    Text("Email: ${item['email']}"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16),
                    const SizedBox(width: 8),
                    Text("Phone: ${item['phone_number']}"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Lokasi: ${item['location'] ?? 'Tidak tersedia'}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Pelapor: ${item['reporter_name'] ?? 'Anonim'}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(item['description']),
                const SizedBox(height: 20),

                if (item['type'] == 'ditemukan')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show claim dialog
                        Navigator.pop(context);
                        _showClaimDialog(context, item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004274),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Klaim Barang',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Show contact dialog
                      Navigator.pop(context);
                      _showContactDialog(context, item);
                    },
                    child: const Text('Kontak Pelapor'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClaimDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Klaim Barang'),
            content: const Text(
              'Apakah Anda yakin ingin mengklaim barang ini? Anda akan diminta untuk memverifikasi kepemilikan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Permintaan klaim telah dikirim ke pemilik barang.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004274),
                ),
                child: const Text('Ya, Klaim'),
              ),
            ],
          ),
    );
  }

  void _showContactDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Kontak Pelapor'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${item['email']}'),
                const SizedBox(height: 8),
                Text('Phone: ${item['phone_number']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }
}

// Widget for selectable category chips
class SelectableCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
        backgroundColor: isSelected ? const Color(0xFF004274) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? const Color(0xFF004274) : Colors.grey,
          ),
        ),
      ),
    );
  }
}
