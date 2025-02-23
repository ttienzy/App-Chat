import 'package:f1/widgets/all_chats_tab.dart';
import 'package:f1/widgets/contacts_tab.dart';
import 'package:f1/widgets/groups_tab.dart';
import 'package:flutter/material.dart';

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // AppBar tuỳ chỉnh (hoặc bạn có thể dùng AppBar thông thường)
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần "Hello, Johan"
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Hello,\nJohan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // TabBar
                  const TabBar(
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.deepPurple,
                    tabs: [
                      Tab(text: 'All Chats'),
                      Tab(text: 'Groups'),
                      Tab(text: 'Contacts'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [AllChatsTab(), GroupsTab(), ContactsTab()],
        ),
        // Nút tròn tạo chat mới (tuỳ chỉnh hoặc bỏ)
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Xử lý khi nhấn nút
          },
          child: const Icon(Icons.chat),
        ),
      ),
    );
  }
}
