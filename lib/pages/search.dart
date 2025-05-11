import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search Report',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Rekomendasi Penelusuran Kategori',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                CategoryChip(label: 'KTM'),
                CategoryChip(label: 'Dokumen Pribadi'),
                CategoryChip(label: 'Aksesoris Pribadi'),
                CategoryChip(label: 'Elektronik'),
                CategoryChip(label: 'Alat Tulis'),
                CategoryChip(label: 'Kunci'),
                CategoryChip(label: 'Buku'),
              ],
            ),
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
}

class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
