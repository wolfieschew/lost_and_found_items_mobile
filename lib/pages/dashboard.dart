import 'package:flutter/material.dart';
import 'message.dart';
import 'report.dart';
// import 'search_page.dart';
import 'nontification.dart';
import 'activity.dart';
import 'feedback.dart';
import 'search.dart';
import 'profile.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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

class ReportItem {
  final String imagePath;
  final String title;
  final String date;

  const ReportItem({
    required this.imagePath,
    required this.title,
    required this.date,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const List<ReportItem> reports = [
    ReportItem(
      imagePath: 'assets/images/Gelang_emas.png',
      title: 'Gelang Emas',
      date: '03-05-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/Diary.png',
      title: 'Diary',
      date: '02-05-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/Tas Hitam.jpeg',
      title: 'Tas Hitam',
      date: '01-05-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/buku kuliah.jpg',
      title: 'Buku Kuliah',
      date: '30-04-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/kunci.jpeg',
      title: 'Kunci',
      date: '29-04-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/Hp.jpeg',
      title: 'HP',
      date: '28-04-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/Jam Tangan.jpeg',
      title: 'Jam Tangan',
      date: '27-04-2025',
    ),
    ReportItem(
      imagePath: 'assets/images/Kacamata Boboho.jpeg',
      title: 'Kacamata',
      date: '26-04-2025',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
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

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Timeline Laporan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.tune),
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: reports.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFFF9F9F9),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                32,
                              ),
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
                                      report.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Aksesoris Pribadi",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Kehilangan",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1.0,
                                        vertical: 8.0,
                                      ),
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(
                                          1.0,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        report.imagePath,
                                        height: 120,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text("Date : ${report.date}"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Row(
                                      children: [
                                        Icon(Icons.email, size: 16),
                                        SizedBox(width: 8),
                                        Text("Email : user@gmail.com"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Row(
                                      children: [
                                        Icon(Icons.location_on, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          "Location : Fakultas Ilmu Terapan",
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Deskripsi",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF004274,
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              "Message",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              "Claim Barang",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.asset(
                                report.imagePath,
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(report.title),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    report.date,
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
            ),
          ],
        ),
      ),
    );
  }
}
