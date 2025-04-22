import 'package:f1/auth/messages_notifier.dart';
import 'package:f1/auth/theme_notifier.dart';
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
    required this.memberCount,
  });
  final String roomId;
  final String roomName;
  final int memberCount;
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.roomName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.memberCount ?? 0} thành viên', // Hiển thị số lượng thành viên
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo[600], // Màu nền sang trọng hơn
        elevation: 2,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          splashRadius: 24,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Menu tùy chọn
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white, size: 24),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            offset: Offset(0, 40),
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
                case 'change_theme':
                  // Thêm chức năng đổi theme
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
                          Icons.person_add_alt_1,
                          color: Colors.indigo,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Thêm thành viên',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove_member',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_remove,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Xóa thành viên',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'change_theme',
                    child: Row(
                      children: [
                        Icon(
                          Icons.color_lens_outlined,
                          color: Colors.amber[700],
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Đổi chủ đề',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'leave_group',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.grey[700], size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Rời nhóm',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
          SizedBox(width: 4),
        ],
      ),

      body: _buildBody(messagesProvider, isDarkMode),
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

  Widget _buildBody(MessagesProvider messagesProviders, bool isDarkMode) {
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
                (context, index) => buildMessageBubble(
                  messagesList[index],
                  _user!.uid,
                  isDarkMode,
                ),
          ),
        ),
        _buildMessageInput(isDarkMode),
      ],
    );
  }

  Widget _buildMessageInput(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: !isDarkMode ? Colors.white : const Color(0xFF1C2841),
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
                fillColor:
                    !isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 47, 62, 95),
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
              color:
                  !isDarkMode
                      ? const Color.fromARGB(255, 247, 245, 245)
                      : const Color.fromARGB(255, 47, 62, 95),
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
