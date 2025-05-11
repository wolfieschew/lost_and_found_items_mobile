import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_message.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  // Data dummy untuk pesan
  final List<MessageItem> messages = [
    MessageItem(
      name: 'Bagas Permana',
      avatar: 'assets/images/guest.jpg', // Ganti dengan path yang benar
      message: 'Haii, tadi aku nemu barang kam ...',
      time: '1h',
      isUnread: true,
    ),
    MessageItem(
      name: 'Raja Surya',
      avatar: 'assets/images/guest.jpg',
      message: 'Haii bro',
      time: '3h',
      isUnread: false,
    ),
    MessageItem(
      name: 'Rahmadhini',
      avatar: 'assets/images/guest.jpg',
      message: 'barang kamu lagi ada di satpam ya',
      time: '7h',
      isUnread: false,
    ),
    MessageItem(
      name: 'Akania',
      avatar: 'assets/images/guest.jpg',
      message: 'kamu ada lihat barang aku gak?',
      time: '12h',
      isUnread: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        titleSpacing: 16.0,
        title: Text(
          'Message',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search user',
                  hintStyle: GoogleFonts.lato(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.pink[50],
                        backgroundImage: AssetImage(message.avatar),
                      ),
                      if (message.isUnread)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        )
                      else
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    message.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    message.message,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    message.time,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailMessage(
                              userName: message.name,
                              userAvatar: message.avatar,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageItem {
  final String name;
  final String avatar;
  final String message;
  final String time;
  final bool isUnread;

  MessageItem({
    required this.name,
    required this.avatar,
    required this.message,
    required this.time,
    required this.isUnread,
  });
}
