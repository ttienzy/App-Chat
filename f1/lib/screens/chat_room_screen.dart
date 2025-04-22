import 'package:f1/auth/rooms_notifier.dart';
import 'package:f1/auth/theme_notifier.dart';
import 'package:f1/dialog/create_group_dialog.dart';
import 'package:f1/screens/chat_room_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({super.key});

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roomProvider = Provider.of<RoomsProvider>(context, listen: false);
      roomProvider.getRooms(_user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomsProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      // Màu nền nhạt cho toàn bộ trang
      //backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: !isDarkMode ? Colors.white : const Color(0xFF1C2841),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leadingWidth: 0,
        titleSpacing: 16,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.blueGrey[700],
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  // Gọi provider để reset danh sách nếu cần
                }
              });
            },
            splashRadius: 20,
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: !isDarkMode ? Colors.blue[50] : const Color(0xFF1C2841),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.group_add_outlined, color: Colors.blue[700]),
              onPressed: () {
                // Ví dụ: gọi hàm tạo nhóm chat
                showCreateGroupDialog(context);
              },
              tooltip: 'Tạo nhóm mới',
              splashRadius: 20,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),

      // Thêm các phương thức hỗ trợ
      body: _buildBody(roomProvider, isDarkMode),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!, width: 2),
          ),
          child: Icon(Icons.chat_rounded, color: Colors.blue[700], size: 22),
        ),
        SizedBox(width: 12),
        Text(
          'Tin nhắn',
          style: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm...',
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8),
      ),
      style: TextStyle(color: Colors.blueGrey[800], fontSize: 16),
      onChanged: (value) {
        // Xử lý tìm kiếm theo value
      },
    );
  }

  Widget _buildBody(RoomsProvider roomProviders, bool isDarkMode) {
    if (roomProviders.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 35, 146, 219),
          strokeWidth: 3,
        ),
      );
    }

    if (roomProviders.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              "Error: ${roomProviders.error}",
              style: TextStyle(fontSize: 16, color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (roomProviders.rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Chưa có phòng nào, hãy tạo 1 phòng chat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final rooms = roomProviders.rooms;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChatRoomDetailScreen(
                          roomId: room.id,
                          roomName: room.name,
                          memberCount: room.memberCount,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      !isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(255, 44, 59, 93),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'room_avatar_${room.id}',
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 60, 100, 202)!,
                                const Color.fromARGB(255, 47, 4, 241)!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              room.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              room.desc.isNotEmpty
                                  ? room.desc
                                  : 'Không có mô tả',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.deepPurple,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
