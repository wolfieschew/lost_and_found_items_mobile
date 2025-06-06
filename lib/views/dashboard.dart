// lib/views/dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Tambahkan package ini
import '../viewmodels/item_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'message.dart';
import 'report.dart';
import 'nontification.dart';
import 'activity.dart';
import 'feedback.dart';
import 'search.dart';
import 'profile.dart';
import 'auth/login_page.dart';
import 'item_detail.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const MyActivityPage(),
    const Message(),
    const MyProfilePage(),
    const FeedbackPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Cek login status tanpa memanggil method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Tidak perlu memanggil method khusus karena AuthViewModel
      // sudah memanggil _checkLoginStatus() di constructor
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cek status login
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Jika belum login, redirect ke login page
    if (!authViewModel.isLoggedIn && !authViewModel.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
      });
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                backgroundColor: const Color(0xFF004274),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateReportScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF004274),
          unselectedItemColor: Colors.black87,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filterType = 'all'; // 'all', 'hilang', 'ditemukan'

  @override
  void initState() {
    super.initState();
    // Load items when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemViewModel>(context, listen: false).getItems();
    });
  }

  // Tambahkan method ini di dalam class _HomePageState
  void _showFullImage(BuildContext context, String imageUrl, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl, title: title),
      ),
    );
  }

  // Method untuk refresh data
  Future<void> _refreshItems() async {
    switch (_filterType) {
      case 'hilang':
        await Provider.of<ItemViewModel>(context, listen: false).getLostItems();
        break;
      case 'ditemukan':
        await Provider.of<ItemViewModel>(
          context,
          listen: false,
        ).getFoundItems();
        break;
      default:
        await Provider.of<ItemViewModel>(context, listen: false).getItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header (search dan notifikasi)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF004274).withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Search Report',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => NotificationPage()),
                        );
                      },
                      child: Stack(
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: 30,
                            color: Colors.white,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Header timeline dengan filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Timeline Laporan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.tune),
                    color: Colors.white,
                    onSelected: (value) {
                      setState(() {
                        _filterType = value;
                      });
                      // Apply filter
                      if (value == 'hilang') {
                        Provider.of<ItemViewModel>(
                          context,
                          listen: false,
                        ).getLostItems();
                      } else if (value == 'ditemukan') {
                        Provider.of<ItemViewModel>(
                          context,
                          listen: false,
                        ).getFoundItems();
                      } else {
                        Provider.of<ItemViewModel>(
                          context,
                          listen: false,
                        ).getItems();
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'all',
                            child: Text('Semua'),
                          ),
                          const PopupMenuItem(
                            value: 'hilang',
                            child: Text('Barang Hilang'),
                          ),
                          const PopupMenuItem(
                            value: 'ditemukan',
                            child: Text('Barang Ditemukan'),
                          ),
                        ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              height: 1.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.0),
              ),
            ),

            const SizedBox(height: 10),

            // Grid laporan barang dari API
            Expanded(
              child: Consumer<ItemViewModel>(
                builder: (context, itemViewModel, _) {
                  if (itemViewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (itemViewModel.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${itemViewModel.error}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshItems,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (itemViewModel.items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshItems,
                      child: ListView(
                        children: const [
                          SizedBox(height: 100),
                          Center(
                            child: Text(
                              'Tidak ada laporan barang',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshItems,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        itemCount: itemViewModel.items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3 / 2.5,
                            ),
                        itemBuilder: (context, index) {
                          final item = itemViewModel.items[index];
                          return GestureDetector(
                            onTap: () {
                              // Ganti dari _showItemDetails ke navigasi ke halaman baru
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailScreen(item: item),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        item.photoPath != null
                                            ? CachedNetworkImage(
                                              imageUrl: item.displayImageUrl,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder:
                                                  (context, url) => Container(
                                                    height: 120,
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                        height: 120,
                                                        color: Colors.grey[200],
                                                        child: const Icon(
                                                          Icons.error,
                                                        ),
                                                      ),
                                            )
                                            : Container(
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.itemName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.formattedDate,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showItemDetails(BuildContext context, item) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: const Color(0xFFF9F9F9),
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (_) {
  //       return Padding(
  //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ),
  //               Text(
  //                 item.itemName,
  //                 style: const TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Text(item.category, style: const TextStyle(color: Colors.grey)),
  //               const SizedBox(height: 8),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 12,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color:
  //                       item.type == 'hilang'
  //                           ? Colors.red[100]
  //                           : Colors.green[100],
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Text(
  //                   item.type == 'hilang' ? "Kehilangan" : "Ditemukan",
  //                   style: TextStyle(
  //                     color: item.type == 'hilang' ? Colors.red : Colors.green,
  //                   ),
  //                 ),
  //               ),

  //               Container(
  //                 margin: const EdgeInsets.symmetric(
  //                   horizontal: 1.0,
  //                   vertical: 8.0,
  //                 ),
  //                 height: 1.0,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.withOpacity(0.3),
  //                   borderRadius: BorderRadius.circular(1.0),
  //                 ),
  //               ),

  //               const SizedBox(height: 16),
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(12),
  //                 child: GestureDetector(
  //                   // TAMBAHKAN GestureDetector di sini
  //                   onTap: () {
  //                     if (item.photoPath != null) {
  //                       _showFullImage(
  //                         context,
  //                         item.displayImageUrl,
  //                         item.itemName,
  //                       );
  //                     }
  //                   },
  //                   child:
  //                       item.photoPath != null
  //                           ? CachedNetworkImage(
  //                             imageUrl: item.displayImageUrl,
  //                             height: 120,
  //                             width: double.infinity,
  //                             fit: BoxFit.cover,
  //                             placeholder:
  //                                 (context, url) => Container(
  //                                   height: 120,
  //                                   color: Colors.grey[200],
  //                                   child: const Center(
  //                                     child: CircularProgressIndicator(),
  //                                   ),
  //                                 ),
  //                             errorWidget:
  //                                 (context, url, error) => Container(
  //                                   height: 120,
  //                                   color: Colors.grey[200],
  //                                   child: const Icon(Icons.error),
  //                                 ),
  //                           )
  //                           : Container(
  //                             height: 120,
  //                             color: Colors.grey[200],
  //                             child: const Icon(Icons.image_not_supported),
  //                           ),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.calendar_today, size: 16),
  //                   const SizedBox(width: 8),
  //                   Text("Tanggal: ${item.formattedDate}"),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.email, size: 16),
  //                   const SizedBox(width: 8),
  //                   Text("Email: ${item.email}"),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.phone, size: 16),
  //                   const SizedBox(width: 8),
  //                   Text("Phone: ${item.phoneNumber}"),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.location_on, size: 16),
  //                   const SizedBox(width: 8),
  //                   Expanded(child: Text("Lokasi: ${item.location}")),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.person, size: 16),
  //                   const SizedBox(width: 8),
  //                   Text("Pelapor: ${item.reportBy}"),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   const Icon(Icons.flag, size: 16),
  //                   const SizedBox(width: 8),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 8,
  //                       vertical: 2,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: _getStatusColor(item.status),
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                     child: Text(
  //                       "Status: ${item.statusDisplay}",
  //                       style: TextStyle(
  //                         color: _getStatusTextColor(item.status),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),
  //               const Text(
  //                 "Deskripsi",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 4),
  //               Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[100],
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Text(
  //                   item.description,
  //                   style: const TextStyle(fontSize: 13),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFF004274),
  //                       ),
  //                       onPressed: () {
  //                         // Implementasi kirim pesan ke pelapor
  //                       },
  //                       child: const Text(
  //                         "Message",
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.white,
  //                       ),
  //                       onPressed:
  //                           item.status != 'claimed'
  //                               ? () {
  //                                 // Implementasi klaim barang
  //                                 _showClaimDialog(context, item);
  //                               }
  //                               : null,
  //                       child: Text(
  //                         item.status == 'claimed'
  //                             ? "Sudah Diklaim"
  //                             : "Claim Barang",
  //                         style: TextStyle(
  //                           color:
  //                               item.status == 'claimed'
  //                                   ? Colors.grey
  //                                   : Colors.black,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Dialog konfirmasi klaim barang
  void _showClaimDialog(BuildContext context, item) {
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
                  _processClaimRequest(item);
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
  void _processClaimRequest(item) {
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

// Definisi widget FullScreenImage
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
        title: Text(widget.title),
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
