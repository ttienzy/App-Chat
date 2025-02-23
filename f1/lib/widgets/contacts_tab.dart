import 'package:f1/models/chat_item_data.dart';
import 'package:f1/widgets/chat_item.dart';
import 'package:flutter/material.dart';

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo cho contacts
    final List<ChatItemData> contacts = [
      ChatItemData(
        name: 'Alice',
        lastMessage: '',
        time: '',
        avatarUrl: 'https://i.pravatar.cc/150?img=9',
      ),
      ChatItemData(
        name: 'Bob',
        lastMessage: '',
        time: '',
        avatarUrl: 'https://i.pravatar.cc/150?img=10',
      ),
      ChatItemData(
        name: 'Charlie',
        lastMessage: '',
        time: '',
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
      ),
    ];

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ChatItem(chatData: contacts[index]);
      },
    );
  }
}
