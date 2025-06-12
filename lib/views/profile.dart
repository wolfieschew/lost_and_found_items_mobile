import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile.dart';
import 'settings.dart';
import 'feedback.dart';
import 'nontification.dart';
import '../services/repository/auth_repository.dart';
import '../models/user.dart';
import 'auth/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api/api_client.dart';
import 'intro/intro_pages.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import '../viewmodels/auth_viewmodel.dart'; // Tambahkan ini
import '../viewmodels/item_viewmodel.dart'; // Tambahkan ini jika dibutuhkan
import 'auth/auth_checker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Inisialisasi AuthRepository
  final AuthRepository _authRepository = AuthRepository();

  // State untuk menyimpan data user
  User? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data user
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await _authRepository.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load user data: $e';
        _isLoading = false;
      });
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
          'My Profile',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: _buildContent(constraints),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF004274),
    Color textColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User not logged in'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        buildProfileCard(_user!),
        const SizedBox(height: 20),

        // Menu list items
        Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // My Profile menu item
              buildMenuItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                onTap: () async {
                  // Tambahkan async di sini
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProfilePage(
                            firstName: _user!.firstName ?? '',
                            lastName: _user!.lastName ?? '',
                            nim: _user!.nim ?? '',
                            email: _user!.email,
                            phoneNumber: _user!.phone ?? '',
                            address: _user!.address ?? '',
                          ),
                    ),
                  );

                  // Cek hasil dari EditProfilePage
                  if (result == true) {
                    // Refresh data profile
                    setState(() {
                      _isLoading = true;
                    });
                    _loadUserData(); // Panggil method untuk reload data profile
                  }
                },
              ),

              // Existing menu items remain the same...
              const Divider(height: 1, indent: 56),
              buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),

              const Divider(height: 1, indent: 56),
              buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),

              const Divider(height: 1, indent: 56),
              buildMenuItem(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ),
                  );
                },
              ),

              const Divider(height: 1, indent: 56),
              buildMenuItem(
                icon: Icons.logout,
                title: 'Log out',
                onTap: _logoutDirect, // Gunakan fungsi baru tanpa konfirmasi
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ],
          ),
        ),

        // Spacer untuk memastikan konten terlihat penuh
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> _logoutDirect() async {
    // Dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Set flag untuk mencegah API calls selama logout
      ApiClient.isLoggingOut = true;

      // Proses logout
      await _authRepository.logout();

      // Hapus token
      final storage = const FlutterSecureStorage();
      await storage.delete(key: 'auth_token');

      // Reset state
      if (mounted) {
        try {
          Provider.of<AuthViewModel>(context, listen: false).resetState();
        } catch (e) {
          print('Error resetting state: $e');
        }
      }

      // Tutup dialog loading
      if (mounted) Navigator.pop(context);

      // Navigasi ke login
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthChecker()),
          (_) => false,
        );
      }
    } catch (e) {
      // Error handling
      if (mounted) Navigator.pop(context);
      print('Logout error: $e');

      // Tetap navigasi
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthChecker()),
          (_) => false,
        );
      }
    } finally {
      // PENTING: Reset flag isLoggingOut di mana pun hasilnya
      ApiClient.isLoggingOut = false;
    }
  }

  // Tambahkan method ini di dalam class _MyProfilePageState
  String _getFullImageUrl(String relativePath) {
    // Tambahkan base URL ke relative path
    final baseUrl =
        'http://127.0.0.1:8000/storage/'; // Sesuaikan dengan base URL API Anda

    // Jika URL sudah lengkap (dimulai dengan http), gunakan langsung
    if (relativePath.startsWith('http')) {
      return relativePath;
    }

    // Jika tidak, gabungkan dengan base URL
    return baseUrl + relativePath;
  }

  // Widget buildMenuItem tetap sama

  // Widget untuk Profile Card yang dimodifikasi untuk menggunakan data user
  Widget buildProfileCard(User user) {
    print('Building profile card with data:');
    print('Name: ${user.name}');
    print('First Name: ${user.firstName}, Last Name: ${user.lastName}');
    print('Email: ${user.email}');
    print('NIM: ${user.nim}');
    print('Role: ${user.role}');
    print('Profile Picture URL: ${user.profilePicture}');

    return Card(
      elevation: 2,
      color: const Color(0xFFAEC2D1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  // URL sudah lengkap, tidak perlu digabung dengan base URL
                  backgroundImage:
                      user.profilePicture != null &&
                              user.profilePicture!.isNotEmpty
                          ? NetworkImage(user.profilePicture!)
                          : const AssetImage('assets/images/profile.png')
                              as ImageProvider,
                  onBackgroundImageError: (_, __) {
                    print('Error loading profile image');
                  },
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tampilkan nama lengkap dari field name atau gabungan first_name dan last_name
                      Text(
                        user.name ??
                            '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                .trim(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      if (user.nim != null && user.nim!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.nim!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        user.role?.toLowerCase() == 'user'
                            ? 'Mahasiswa'
                            : (user.role ?? 'USER'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Edit button (unchanged)
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.9),
          //       shape: BoxShape.circle,
          //     ),
          //     child: IconButton(
          //       icon: const Icon(Icons.edit, size: 20),
          //       color: const Color(0xFF004274),
          //       onPressed: () async {
          //         // existing code
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Helper method untuk mendapatkan profile image
  ImageProvider _getProfileImage(User user) {
    if (user.profilePicture == null || user.profilePicture!.isEmpty) {
      return const AssetImage('assets/images/profile.png');
    }

    try {
      return NetworkImage(_getFullImageUrl(user.profilePicture!));
    } catch (e) {
      print('Error loading profile image: $e');
      return const AssetImage('assets/images/profile.png');
    }
  }
}
