import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile.dart';
import 'settings.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String firstName = 'Rahmadhini';
  String lastName = 'Dhini';
  String nim = '607012330127';
  String email = 'dhinirahma411@gmail.com';
  String phoneNumber = '085760176587';
  String address = 'Sukapura';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),

      body: Container(
        color: const Color(0xFFF9F9F9),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildProfileCard(),

              const SizedBox(height: 24),

              simpleSectionCard(
                title: 'Personal Information',
                child: Column(
                  children: [
                    buildSingleForm('First Name', firstName),
                    buildSingleForm('Last Name', lastName),
                    buildSingleForm('NIM', nim),
                    buildSingleForm('Phone Number', phoneNumber),
                    buildSingleForm('Email', email),
                    buildSingleForm('Current Location', address),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout),
                  label: const Text('Log out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileCard() {
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
                  backgroundImage: const AssetImage(
                    'assets/images/profile.png',
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nim,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mahasiswa',
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

          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: const Color(0xFF004274),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProfilePage(
                            firstName: firstName,
                            lastName: lastName,
                            nim: nim,
                            email: email,
                            phoneNumber: phoneNumber,
                            address: address,
                          ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      firstName = result['firstName'];
                      lastName = result['lastName'];
                      nim = result['nim'];
                      email = result['email'];
                      phoneNumber = result['phoneNumber'];
                      address = result['address'];
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget simpleSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  Widget buildSingleForm(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: buildTextField(label, value),
    );
  }

  Widget buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
