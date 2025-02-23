import 'package:f1/models/chat_item_data.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final ChatItemData chatData;

  const ChatItem({super.key, required this.chatData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(chatData.avatarUrl),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chatData.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (chatData.pinned) ...[
            const SizedBox(width: 8),
            const Icon(Icons.push_pin, size: 16, color: Colors.grey),
          ],
        ],
      ),
      subtitle: Text(
        chatData.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        chatData.time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () {
        // Xử lý khi nhấn vào chat (chuyển sang màn hình chat chi tiết)
      },
    );
  }
}
