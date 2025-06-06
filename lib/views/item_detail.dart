import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/item.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Barang', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    if (item.photoPath != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FullScreenImage(
                                imageUrl: item.displayImageUrl,
                                title: item.itemName,
                              ),
                        ),
                      );
                    }
                  },
                  child:
                      item.photoPath != null
                          ? CachedNetworkImage(
                            imageUrl: item.displayImageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  height: 250,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 250,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                ),
                          )
                          : Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                ),
              ),

              const SizedBox(height: 10),

              // Bungkus dengan Card untuk background putih
              SizedBox(
                width: double.infinity, // Takes full width available
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white, // Added white background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama barang
                        Text(
                          item.itemName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Kategori
                        Text(
                          item.category,
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 12),

                        // Badge status (hilang/ditemukan)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                item.type == 'hilang'
                                    ? Colors.red[100]
                                    : Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.type == 'hilang' ? "Kehilangan" : "Ditemukan",
                            style: TextStyle(
                              color:
                                  item.type == 'hilang'
                                      ? Colors.red
                                      : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white, // Added white background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section judul informasi
                      const Text(
                        "Informasi Detail",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Informasi detail yang dipindahkan ke dalam card
                      _buildInfoRow(
                        Icons.calendar_today,
                        "Tanggal",
                        item.formattedDate,
                      ),
                      _buildInfoRow(Icons.email, "Email", item.email),
                      _buildInfoRow(Icons.phone, "Phone", item.phoneNumber),
                      _buildInfoRow(Icons.location_on, "Lokasi", item.location),
                      _buildInfoRow(Icons.person, "Pelapor", item.reportBy),

                      // Status row
                      Row(
                        children: [
                          const Icon(
                            Icons.flag,
                            size: 20,
                            color: Color(0xFF004274),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Status: ${item.statusDisplay}",
                              style: TextStyle(
                                color: _getStatusTextColor(item.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card untuk deskripsi
              SizedBox(
                width: double.infinity, // Takes full width available
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Deskripsi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          style: const TextStyle(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.message, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004274),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Implementasi kirim pesan ke pelapor
                      },
                      label: const Text(
                        "Message",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.verified_user,
                        color:
                            item.status == 'claimed'
                                ? Colors.grey
                                : Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed:
                          item.status != 'claimed'
                              ? () {
                                // Implementasi klaim barang
                                _showClaimDialog(context, item);
                              }
                              : null,
                      label: Text(
                        item.status == 'claimed'
                            ? "Sudah Diklaim"
                            : "Claim Barang",
                        style: TextStyle(
                          color:
                              item.status == 'claimed'
                                  ? Colors.grey
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF004274)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog konfirmasi klaim barang
  void _showClaimDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Klaim Barang'),
            content: const Text(
              'Apakah Anda yakin ingin mengklaim barang ini? '
              'Anda akan diminta untuk memverifikasi kepemilikan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Proses klaim barang
                  _processClaimRequest(context);
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

  // Proses permintaan klaim barang
  void _processClaimRequest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permintaan klaim telah dikirim ke pemilik barang.'),
      ),
    );
  }

  // Helper untuk warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber[100]!;
      case 'approved':
        return Colors.green[100]!;
      case 'rejected':
        return Colors.red[100]!;
      case 'claimed':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // Helper untuk warna teks status
  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber[800]!;
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
}

// Gunakan kembali FullScreenImage yang sudah ada
class FullScreenImage extends StatefulWidget {
  final String imageUrl;
  final String title;

  const FullScreenImage({Key? key, required this.imageUrl, required this.title})
    : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _controller.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map, color: Colors.white),
            onPressed: _resetZoom,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _controller,
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
            placeholder:
                (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            errorWidget:
                (context, url, error) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gagal memuat gambar',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(color: Colors.red[300], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
