import 'package:flutter/material.dart';
import 'dashboard.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Pindahkan data notifications ke sini agar bisa dimodifikasi
  List<Map<String, String>> notifications = [
    {
      "time": "12:30, Hari ini",
      "text": "Bagas baru saja melaporkan kehilangan barang!",
    },
    {
      "time": "12:30, Kemarin",
      "text": "Raja baru saja melaporkan penemuan barang!",
    },
    {
      "time": "12:30, 2 Hari yang lalu",
      "text": "Rahmadhini baru saja melaporkan kehilangan barang!",
    },
    {
      "time": "12:30, 7 Hari yang lalu",
      "text": "Akania baru saja melaporkan penemuan barang!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
          ),
        ),

        title: Text('Notification', style: TextStyle(color: Colors.black)),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 16.0),
        //     child: IconButton(
        //       icon: Icon(Icons.delete_outline, color: Colors.black),
        //       onPressed: () {},
        //       padding: EdgeInsets.zero,
        //     ),
        //   ),
        // ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          notifications.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada notifikasi',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    // Key harus unik untuk setiap item
                    key: Key(notifications[index]["time"]! + index.toString()),

                    // Arah slide yang diperbolehkan (kanan ke kiri)
                    direction: DismissDirection.endToStart,

                    // HAPUS baris clipBehavior ini karena tidak tersedia di Dismissible
                    // clipBehavior: Clip.antiAlias,

                    // Background yang muncul saat slide dengan radius yang sama
                    background: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ), // Samakan dengan margin card
                      padding: const EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    // Hapus item ketika di-dismiss
                    onDismissed: (direction) {
                      setState(() {
                        notifications.removeAt(index);
                      });

                      // Tambahkan snackbar untuk menunjukkan item telah dihapus
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notifikasi dihapus'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },

                    child: NotificationCard(
                      time: notifications[index]["time"]!,
                      text: notifications[index]["text"]!,
                    ),
                  );
                },
              ),
      // bottomNavigationBar: Container(
      //   height: 80,
      //   child: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     backgroundColor: Colors.white,
      //     selectedItemColor: const Color(0xFF004274),
      //     unselectedItemColor: Colors.black87,
      //     selectedFontSize: 12,
      //     unselectedFontSize: 12,
      //     currentIndex: 0, // Home tab akan dipilih secara default
      //     onTap: (index) {
      //       // Optional: Tambahkan navigasi jika diperlukan
      //       if (index == 0) {
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (_) => Dashboard()),
      //         );
      //       }
      //     },
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.assignment),
      //         label: 'Activity',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.message),
      //         label: 'Messages',
      //       ),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //       BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Feedback'),
      //     ],
      //   ),
      // ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String time;
  final String text;

  NotificationCard({required this.time, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.notifications, color: Colors.blue),
        ),
        title: Text(
          time,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(text),
        ),
      ),
    );
  }
}
