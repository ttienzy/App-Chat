import 'package:f1/auth/messages_notifier.dart';
import 'package:f1/services/chat_services.dart';
import 'package:f1/widgets/build_message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomDetailScreen extends StatefulWidget {
  const ChatRoomDetailScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });
  final String roomId;
  final String roomName;

  @override
  State<ChatRoomDetailScreen> createState() => _ChatRoomDetailScreenState();
}

class _ChatRoomDetailScreenState extends State<ChatRoomDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagesProvider = Provider.of<MessagesProvider>(
        context,
        listen: false,
      );
      messagesProvider.getMessages(widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesProvider = Provider.of<MessagesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.roomName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Màu nền AppBar
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 28,
            ), // Icon có màu trắng
            color: Colors.white, // Màu nền của menu
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bo góc menu
            ),
            elevation: 8, // Hiệu ứng đổ bóng
            onSelected: (value) {
              switch (value) {
                case 'add_member':
                  _addMember();
                  break;
                case 'remove_member':
                  _removeMember();
                  break;
                case 'leave_group':
                  _leaveGroup();
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    value: 'add_member',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Colors.blueAccent,
                        ), // Icon
                        SizedBox(width: 10),
                        Text('Thêm thành viên', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove_member',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Xóa thành viên', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'leave_group',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.orangeAccent),
                        SizedBox(width: 10),
                        Text('Rời nhóm', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),

      body: _buildBody(messagesProvider),
    );
  }

  void _addMember() {
    // Hiển thị dialog thêm thành viên
    print("Thêm thành viên");
  }

  void _removeMember() {
    // Hiển thị dialog xóa thành viên
    print("Xóa thành viên");
  }

  void _leaveGroup() {
    // Hiển thị cảnh báo trước khi rời nhóm
    print("Rời nhóm");
  }

  Widget _buildBody(MessagesProvider messagesProviders) {
    if (messagesProviders.isLoading) {
      // Hiển thị vòng xoay khi đang tải
      return Center(child: CircularProgressIndicator());
    }
    if (messagesProviders.error != null) {
      // Hiển thị lỗi nếu có
      return Center(child: Text("Error: ${messagesProviders.error}"));
    }

    final messagesList = messagesProviders.messages;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messagesList.length,
            itemBuilder:
                (context, index) =>
                    buildMessageBubble(messagesList[index], _user!.uid),
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 215, 215),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Color.fromARGB(255, 19, 16, 226),
              ),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  addMessageServices(
                    _messageController.text,
                    widget.roomId,
                    _user!.uid,
                  );
                  setState(() {
                    _messageController.clear();
                  });
                  // Scroll to bottom
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
