import 'package:f1/models/chat_item_data.dart';
import 'package:f1/models/messages.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final ChatItemData chatData;

  const ChatDetailPage({super.key, required this.chatData});

  @override
  Widget build(BuildContext context) {
    // Danh sách tin nhắn demo
    final List<Message> messages = [
      Message(text: 'Hey 😄', isMe: false),
      Message(text: 'Are you available for a New UI Project?', isMe: false),
      Message(
        text: 'Hello!\nYes, have some space for the new task',
        isMe: true,
      ),
      Message(text: 'Cool, should I share the details now?', isMe: false),
      Message(text: 'Yes, please!', isMe: true),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(chatData.avatarUrl)),
            const SizedBox(width: 8),
            Text(chatData.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Mở menu hay thực hiện hành động khác
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                // canh lề phải (tin nhắn của "mình") và lề trái (tin nhắn của "người kia")
                return Align(
                  alignment:
                      message.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          message.isMe
                              ? Colors.deepPurple.shade100
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          // Phần nhập tin nhắn
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Xử lý khi gửi tin
                    },
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
