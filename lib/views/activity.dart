import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/activity_viewmodel.dart';
import '../models/item.dart';
import './item_detail.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});
  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  String selectedCategory = "Category";
  String selectedReportType = "Report";
  final ScrollController _scrollController = ScrollController();

  bool _isSelectionMode = false; // Mode seleksi aktif atau tidak
  Set<int> _selectedItems = {}; // Set untuk menyimpan ID item yang dipilih

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ActivityViewModel>(context, listen: false);
      viewModel.getMyItems(refresh: true);
    });

    _scrollController.addListener(_scrollListener);
  }

  void _showCategoryBottomSheet(
    BuildContext context,
    String currentValue,
    Function(String?) onChanged,
    List<String> items,
  ) {
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final category = items[index];
                      final isSelected = currentValue == category;

                      return ListTile(
                        title: Text(
                          category,
                          style: TextStyle(
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isSelected
                                    ? const Color(0xFF004274)
                                    : Colors.black,
                          ),
                        ),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSelected
                                    ? const Color(0xFF004274)
                                    : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF004274)
                                      : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                    : null,
                          ),
                        ),
                        tileColor:
                            isSelected
                                ? const Color.fromARGB(255, 237, 245, 252)
                                : null,
                        onTap: () {
                          onChanged(category);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportBottomSheet(
    BuildContext context,
    String currentValue,
    Function(String?) onChanged,
    List<String> items,
  ) {
    final reportLabels = {
      "Report": "Report",
      "hilang": "Barang Hilang",
      "ditemukan": "Barang Ditemukan",
    };

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
                  'Pilih Tipe Laporan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final reportType = items[index];
                    final isSelected = currentValue == reportType;

                    // Untuk menentukan label yang ditampilkan
                    String displayLabel =
                        reportLabels[reportType] ?? reportType;

                    return ListTile(
                      title: Text(
                        displayLabel,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? const Color(0xFF004274)
                                  : Colors.black,
                        ),
                      ),
                      trailing: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? const Color(0xFF004274)
                                  : Colors.white,
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF004274)
                                    : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                  : null,
                        ),
                      ),
                      tileColor:
                          isSelected
                              ? const Color.fromARGB(255, 237, 245, 252)
                              : null,
                      onTap: () {
                        onChanged(reportType);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data when user reaches end of list
      Provider.of<ActivityViewModel>(context, listen: false).getMyItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16.0,
        title: Text(
          _isSelectionMode
              ? '${_selectedItems.length} item dipilih'
              : 'My Activity',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildDropdown(
                  "Category",
                  selectedCategory,
                  (value) {
                    setState(() => selectedCategory = value!);
                    _applyFilters();
                  },
                  const [
                    "Category",
                    "Perhiasan Khusus",
                    "Elektronik",
                    "Buku & Dokumen",
                    "Tas & Dompet",
                    "Perlengkapan Pribadi",
                    "Peralatan Praktikum",
                    "Aksesoris",
                    "Lainnya",
                  ],
                ),
                const SizedBox(width: 8),
                _buildDropdown("Report", selectedReportType, (value) {
                  setState(() => selectedReportType = value!);
                  _applyFilters();
                }, const ["Report", "hilang", "ditemukan"]),
                const SizedBox(width: 8),
                // Tambahkan kondisional button di sini
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color:
                        _isSelectionMode
                            ? Colors.red.withOpacity(0.1)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(28.0),
                    border: Border.all(
                      color:
                          _isSelectionMode ? Colors.red : Colors.grey.shade400,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isSelectionMode ? Icons.close : Icons.delete_outline,
                      color:
                          _isSelectionMode
                              ? Colors.red
                              : const Color(0xFF004274),
                      size: 20,
                    ),
                    onPressed: () {
                      if (_isSelectionMode) {
                        // Keluar dari mode seleksi
                        setState(() {
                          _isSelectionMode = false;
                          _selectedItems.clear();
                        });
                      } else {
                        // Aktifkan mode seleksi
                        setState(() {
                          _isSelectionMode = true;
                        });
                      }
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
                // if (_isSelectionMode && _selectedItems.isNotEmpty)
                //   Container(
                //     margin: const EdgeInsets.only(left: 8),
                //     height: 48,
                //     width: 48,
                //     // Perbaiki dekorasi
                //     decoration: BoxDecoration(
                //       color: Colors.red.withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(28.0),
                //       border: Border.all(color: Colors.red),
                //     ),
                //     // Gunakan SizedBox untuk mengatur ukuran icon
                //     child: SizedBox(
                //       width: 40, // Kurangi sedikit dari container
                //       height: 40,
                //       child: IconButton(
                //         icon: const Icon(
                //           Icons.delete_outline,
                //           color: Colors.red,
                //           size: 20, // Pastikan ukuran icon tidak terlalu besar
                //         ),
                //         onPressed: _confirmDelete,
                //         // Hapus padding zero agar icon tetap di tengah
                //         // padding: EdgeInsets.zero,
                //       ),
                //     ),
                //   ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Consumer<ActivityViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.loading && viewModel.myItems.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.error != null && viewModel.myItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(viewModel.error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed:
                                () => viewModel.getMyItems(refresh: true),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (viewModel.myItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/404lost.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada laporan barang',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Laporan yang Anda buat akan tampil di sini',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => viewModel.getMyItems(refresh: true),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          viewModel.myItems.length +
                          (viewModel.hasMorePages && !viewModel.loading
                              ? 1
                              : 0), // Perbaiki kondisi
                      itemBuilder: (context, index) {
                        if (index == viewModel.myItems.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = viewModel.myItems[index];
                        return buildActivityCard(context, item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Tambahkan floating action button
      floatingActionButton:
          _isSelectionMode && _selectedItems.isNotEmpty
              ? FloatingActionButton(
                onPressed: _confirmDelete,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete_outline, color: Colors.white),
                tooltip: 'Hapus item terpilih',
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _applyFilters() {
    final viewModel = Provider.of<ActivityViewModel>(context, listen: false);

    // Reset filter terlebih dahulu
    viewModel.resetFilters();

    // Set filter kategori - pastikan kategori tidak sama dengan default
    if (selectedCategory != "Category") {
      viewModel.setFilterCategory(selectedCategory);
      print("Filter kategori diterapkan: $selectedCategory"); // Debug
    }

    // Set filter tipe laporan - pastikan tipe tidak sama dengan default
    if (selectedReportType != "Report") {
      viewModel.setFilterType(
        selectedReportType.toLowerCase(),
      ); // Convert ke lowercase
      print("Filter tipe diterapkan: $selectedReportType"); // Debug
    }

    // Refresh data dengan filter baru
    viewModel.getMyItems(refresh: true);
  }

  Widget _buildDropdown(
    String label,
    String value,
    Function(String?) onChanged,
    List<String> items,
  ) {
    const double borderRadius = 28.0;

    // Cek apakah nilai saat ini adalah default atau sudah dipilih
    final bool isSelected = value != items[0];
    final String displayValue = value;

    // Jika sudah dipilih, tampilkan sebagai chip dengan tombol X
    if (isSelected) {
      return SizedBox(
        width: 130,
        child: GestureDetector(
          onTap: () {
            // Tentukan apakah ini Category atau Report berdasarkan label
            if (label == "Category") {
              _showCategoryBottomSheet(context, value, onChanged, items);
            } else {
              _showReportBottomSheet(context, value, onChanged, items);
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text yang dipotong jika terlalu panjang
                Expanded(
                  child: Text(
                    displayValue,
                    style: const TextStyle(
                      color: Color(0xFF004274),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Tombol X untuk reset
                GestureDetector(
                  onTap: () {
                    // Reset ke nilai default
                    onChanged(items[0]);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF004274),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 130,
      child: StatefulBuilder(
        builder: (context, setStateLocal) {
          return SizedBox(
            width: 130,
            child: GestureDetector(
              // Tambahkan gesture detector untuk intercept tap dan tampilkan bottom sheet
              onTap: () {
                // Tentukan apakah ini Category atau Report berdasarkan label
                if (label == "Category") {
                  _showCategoryBottomSheet(context, value, onChanged, items);
                } else {
                  _showReportBottomSheet(context, value, onChanged, items);
                }
              },
              // Tetap gunakan dropdown asli, tapi dengan disabled onChanged
              child: AbsorbPointer(
                child: StatefulBuilder(
                  builder: (context, setStateLocal) {
                    return Material(
                      color: Colors.transparent,
                      child: DropdownButtonFormField<String>(
                        // Kode dropdown tetap sama
                        value: value,
                        alignment: AlignmentDirectional.centerStart,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: value != items[0],
                          fillColor:
                              value != items[0]
                                  ? const Color(0xFF0D47A1).withOpacity(0.1)
                                  : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: const BorderSide(
                              color: Color(0xFF004274),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items:
                            items
                                .map(
                                  (val) => DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: val,
                                    child: Text(val),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (_) {}, // Kosongkan ini, karena kita handle sendiri
                        icon:
                            value != items[0]
                                ? _buildCloseButton(() {
                                  onChanged(items[0]);
                                })
                                : const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF004274),
                                ),
                        iconSize: 24,
                        iconEnabledColor: const Color(0xFF004274),
                        dropdownColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCloseButton(VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.close, color: Color(0xFF004274)),
        ),
      ),
    );
  }

  Widget buildActivityCard(BuildContext context, Item item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            item.type == 'hilang'
                ? const Color(0xFFFFAFAF).withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            _selectedItems.contains(item.id)
                ? Border.all(color: Colors.blue, width: 2)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Jika dalam mode seleksi, toggle item selection
          if (_isSelectionMode) {
            setState(() {
              if (_selectedItems.contains(item.id)) {
                _selectedItems.remove(item.id);
              } else {
                _selectedItems.add(item.id);
              }
            });
          } else {
            // Navigate to item detail jika tidak dalam mode seleksi
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailScreen(item: item),
              ),
            );
          }
        },
        child: Row(
          children: [
            // Checkbox saat mode seleksi aktif
            if (_isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Checkbox(
                  value: _selectedItems.contains(item.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedItems.add(item.id);
                      } else {
                        _selectedItems.remove(item.id);
                      }
                    });
                  },
                ),
              ),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  item.photoPath != null
                      ? Image.network(
                        item.displayImageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                      )
                      : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
            ),

            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(item.formattedDate),
                              Text(
                                item.description.length > 50
                                    ? "${item.description.substring(0, 50)}..."
                                    : item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Action buttons
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          // Ubah dari menggunakan type ke menggunakan status
                          color: _getStatusBgColor(item.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.statusDisplay,
                          style: TextStyle(
                            // Ubah warna text berdasarkan status juga
                            color: _getStatusTextColor(item.status),
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const Spacer(),

                      ElevatedButton(
                        onPressed: () {
                          // Navigate to edit page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditReportPage(item: item),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF004274,
                          ).withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tambahkan method ini dalam class _MyActivityPageState
  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber.withOpacity(0.3); // Kuning untuk Menunggu
      case 'approved':
        return Colors.green.withOpacity(0.3);
      case 'rejected':
        return Colors.red.withOpacity(0.3);
      case 'claimed':
        return Colors.blue.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber[800]!; // Teks kuning lebih gelap
      case 'approved':
        return Colors.green[800]!;
      case 'rejected':
        return Colors.red[800]!;
      case 'claimed':
        return Colors.blue[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: Text(
              'Hapus ${_selectedItems.length} item yang dipilih? Tindakan ini tidak dapat dibatalkan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteSelectedItems();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  // Method untuk menghapus item yang dipilih
  Future<void> _deleteSelectedItems() async {
    setState(() {
      _isSubmitting = true;
    });

    final viewModel = Provider.of<ActivityViewModel>(context, listen: false);

    try {
      // Gunakan Future.forEach untuk menghapus item secara berurutan
      List<int> deletedIds = [];
      List<String> errors = [];

      // Buat salinan _selectedItems karena kita akan memodifikasinya di dalam loop
      final itemsToDelete = List<int>.from(_selectedItems);

      for (final itemId in itemsToDelete) {
        try {
          final result = await viewModel.deleteItem(itemId);
          if (result['success']) {
            deletedIds.add(itemId);
            // Hapus dari daftar yang dipilih
            _selectedItems.remove(itemId);
          } else {
            errors.add('ID $itemId: ${result['message']}');
          }
        } catch (e) {
          errors.add('ID $itemId: $e');
        }
      }

      // Tampilkan pesan hasil
      if (deletedIds.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${deletedIds.length} item berhasil dihapus'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (errors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${errors.length} item gagal dihapus'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Detail',
              onPressed: () {
                // Tampilkan detail error jika perlu
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Detail Error'),
                        content: SingleChildScrollView(
                          child: Text(errors.join('\n')),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        );
      }

      // Refresh data
      viewModel.getMyItems(refresh: true);

      // Keluar dari mode seleksi
      setState(() {
        _isSelectionMode = false;
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

// EditReportPage yang diperbarui untuk menerima item dari API
class EditReportPage extends StatefulWidget {
  final Item item;

  const EditReportPage({super.key, required this.item});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  bool _isSubmitting = false;

  late TextEditingController itemNameController,
      descriptionController,
      whatsappController,
      emailController;
  String? selectedCondition, selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.item.itemName);
    descriptionController = TextEditingController(
      text: widget.item.description,
    );
    whatsappController = TextEditingController(text: widget.item.phoneNumber);
    emailController = TextEditingController(text: widget.item.email);

    // Perbaiki konversi tipe laporan
    selectedCondition = widget.item.type == 'hilang' ? 'Hilang' : 'Ditemukan';

    // Pastikan kategori cocok dengan opsi yang tersedia
    selectedCategory = _mapApiCategoryToDropdownCategory(widget.item.category);

    selectedDate =
        widget.item.dateOfEvent is DateTime
            ? widget.item.dateOfEvent
            : DateTime.tryParse(widget.item.dateOfEvent.toString()) ??
                DateTime.now();
  }

  // Tambahkan fungsi untuk memetakan kategori API ke kategori dropdown
  String _mapApiCategoryToDropdownCategory(String apiCategory) {
    // Daftar kategori yang tersedia di dropdown
    const availableCategories = [
      "Elektronik",
      "Aksesoris",
      "Dokumen Pribadi",
      "KTM",
      "Alat Tulis",
      "Kunci",
      "Buku",
      "Lainnya",
    ];

    // Cek apakah kategori dari API cocok dengan salah satu kategori dropdown
    if (availableCategories.contains(apiCategory)) {
      return apiCategory;
    } else if (apiCategory == "Documents") {
      return "Dokumen Pribadi"; // Map "Documents" ke "Dokumen Pribadi"
    } else {
      return "Lainnya"; // Default ke "Lainnya" jika tidak ada yang cocok
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    descriptionController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Edit Report", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildImageSection(),
            const SizedBox(height: 16),
            _buildDropdown(
              "Choose Report Condition",
              selectedCondition,
              (val) => setState(() => selectedCondition = val),
              const ["Hilang", "Ditemukan"],
            ),
            const SizedBox(height: 16),
            _buildTextField(itemNameController, "Item Name"),
            const SizedBox(height: 16),
            _buildDropdown(
              "Select Category",
              selectedCategory,
              (val) => setState(() => selectedCategory = val),
              const [
                "Perhiasan Khusus",
                "Elektronik",
                "Buku & Dokumen",
                "Tas & Dompet",
                "Perlengkapan Pribadi",
                "Pralatihan Praktikum",
                "Aksesori",
                "Lainnya",
              ],
            ),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildTextField(descriptionController, "Description", maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(whatsappController, "WhatsApp", icon: Icons.phone),
            const SizedBox(height: 12),
            _buildTextField(emailController, "Email", icon: Icons.email),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () => _updateReport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004274),
                  minimumSize: const Size.fromHeight(50),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child:
                    _isSubmitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    void Function(String?) onChanged,
    List<String> items,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF004274)),
        ),
      ),
      dropdownColor: Colors.white,
      hint: Text(hint),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF004274)),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText:
            selectedDate == null
                ? "dd/mm/yyyy"
                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF004274)),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: Colors.white,
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF004274),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => selectedDate = picked);
      },
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image:
                widget.item.photoPath != null
                    ? DecorationImage(
                      image: NetworkImage(widget.item.displayImageUrl),
                      fit: BoxFit.cover,
                    )
                    : null,
            color: Colors.grey[200],
          ),
          child:
              widget.item.photoPath == null
                  ? const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  )
                  : null,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                // Implementasi fitur ganti gambar
              },
            ),
          ),
        ),
      ],
    );
  }

  // Tambahkan method untuk update report
  Future<void> _updateReport() async {
    // Validasi form sederhana
    if (itemNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama barang tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Siapkan data untuk update
    final data = {
      'item_name': itemNameController.text,
      'category': selectedCategory,
      'type': selectedCondition?.toLowerCase(),
      'description': descriptionController.text,
      'date_of_event': selectedDate?.toIso8601String(),
      'location': widget.item.location, // Gunakan nilai lama jika tidak diubah
      'email': emailController.text,
      'phone_number': whatsappController.text,
    };

    try {
      // Panggil API update
      final viewModel = Provider.of<ActivityViewModel>(context, listen: false);
      final result = await viewModel.updateItem(widget.item.id, data);

      if (!mounted) return;

      if (result['success']) {
        // Tampilkan pesan sukses
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));

        // Kembali ke halaman sebelumnya
        Navigator.pop(
          context,
          true,
        ); // Pass true untuk menandakan update berhasil
      } else {
        // Tampilkan pesan error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
