import 'package:f1/models/chat_item_data.dart';
import 'package:f1/widgets/chat_item.dart';
import 'package:flutter/material.dart';

class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo cho group
    final List<ChatItemData> groups = [
      ChatItemData(
        name: 'Flutter Dev Group',
        lastMessage: 'We are discussing state management',
        time: '09:00 AM',
        avatarUrl: 'https://i.pravatar.cc/150?img=7',
      ),
      ChatItemData(
        name: 'Family Chat',
        lastMessage: 'Happy birthday to you!',
        time: 'Yesterday',
        avatarUrl: 'https://i.pravatar.cc/150?img=8',
      ),
    ];

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return ChatItem(chatData: groups[index]);
      },
    );
  }
}
