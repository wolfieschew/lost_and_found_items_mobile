import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailMessage extends StatefulWidget {
  final String userName;
  final String userAvatar;

  const DetailMessage({
    Key? key,
    required this.userName,
    required this.userAvatar,
  }) : super(key: key);

  @override
  State<DetailMessage> createState() => _DetailMessageState();
}

class _DetailMessageState extends State<DetailMessage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'Haii, tadi aku nemu barang kamu depan FIT',
      isMe: false,
      time: '12:30',
      avatar: 'assets/images/guest.jpg',
    ),
    ChatMessage(
      text:
          'Oh iya? Terimakasih karna sudah menemukannya. aku ingin mengambil nya kembali !!',
      isMe: true,
      time: '12:35',
      status: 'Delivered',
      avatar: 'assets/images/profile.jpg',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 75,
        centerTitle: true,
        title: Text(
          widget.userName,
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[300]),
        ),
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment:
                        message.isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!message.isMe)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(message.avatar),
                          ),
                        ),

                      Column(
                        crossAxisAlignment:
                            message.isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  message.isMe
                                      ? const Color(0xFFD3DDF0)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              message.text,
                              style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          if (message.isMe && message.status != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, right: 8),
                              child: Text(
                                message.status!,
                                style: GoogleFonts.lato(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),

                      if (message.isMe)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(message.avatar),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Message input area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.06),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: GoogleFonts.lato(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C8CB1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Implementasi kirim pesan
                      // if (_messageController.text.trim().isNotEmpty) {
                      //   setState(() {
                      //     messages.add(
                      //       ChatMessage(
                      //         text: _messageController.text,
                      //         isMe: true,
                      //         time: DateTime.now().toString(),
                      //         status: 'Sending...',
                      //         avatar: 'assets/images/profile.jpg',
                      //       ),
                      //     );
                      //     _messageController.clear();
                      //   });
                      // }
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String? status;
  final String avatar;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.status,
    required this.avatar,
  });
}
