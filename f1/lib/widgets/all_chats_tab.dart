import 'package:f1/models/chat_item_data.dart';
import 'package:f1/widgets/chat_item.dart';
import 'package:flutter/material.dart';

class AllChatsTab extends StatelessWidget {
  const AllChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách dữ liệu demo
    final List<ChatItemData> chats = [
      ChatItemData(
        name: 'Larry Machigo',
        lastMessage: 'Ok, Let me check',
        time: '09:38 AM',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        pinned: true,
      ),
      ChatItemData(
        name: 'Natalie Nora',
        lastMessage: 'Voice message',
        time: '02:03 AM',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
      ),
      ChatItemData(
        name: 'Jennifer Jones',
        lastMessage: 'See you tomorrow, take care!',
        time: 'Yesterday',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
      ),
      ChatItemData(
        name: 'Sofia',
        lastMessage: 'Oh... thank you so much!',
        time: '12 May',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
      ),
      ChatItemData(
        name: 'Haider Lve',
        lastMessage: 'Sticker',
        time: '2 Jan',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
      ),
      ChatItemData(
        name: 'Mr. elon',
        lastMessage: 'Cool :-)))',
        time: 'Just now',
        avatarUrl: 'https://i.pravatar.cc/150?img=6',
      ),
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatItem(chatData: chats[index]);
      },
    );
  }
}
