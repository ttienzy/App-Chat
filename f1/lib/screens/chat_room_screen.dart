import 'package:f1/auth/rooms_notifier.dart';
import 'package:f1/dialog/create_group_dialog.dart';
import 'package:f1/screens/chat_room_detail_screen.dart';
import 'package:f1/screens/chatbot_screen.dart';
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
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

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

    return Scaffold(
      // Màu nền nhạt cho toàn bộ trang
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        // Đặt nền trong suốt để hiển thị gradient từ flexibleSpace
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: _buildAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  // Gọi provider để reset danh sách nếu cần
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () {
              // Ví dụ: gọi hàm tạo nhóm chat
              showCreateGroupDialog(context);
            },
          ),
        ],
      ),

      body: _buildBody(roomProvider),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap:
                (_selectedIndex) => {
                  if (_selectedIndex == 1)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatbotScreen(),
                        ),
                      ),
                    },
                },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                activeIcon: Icon(Icons.group),
                label: 'Contacts',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assistant_outlined),
                activeIcon: Icon(Icons.assistant),
                label: 'Chats',
                backgroundColor: Colors.white,
              ),
            ],
            elevation: 0,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey.shade600,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.shifting,
            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    if (_isSearching) {
      // Nếu đang ở chế độ search, hiển thị TextField
      return TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Tên phòng...',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          // Mỗi khi text thay đổi, bạn có thể gọi Provider để lọc danh sách
          // final roomProvider = Provider.of<RoomsProvider>(context, listen: false);
          // roomProvider.searchRooms(value);
        },
      );
    } else {
      // Nếu không search, hiển thị title bình thường
      return const Text(
        'Danh sách phòng',
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _buildBody(RoomsProvider roomProviders) {
    if (roomProviders.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
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
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                                Colors.deepPurple[300]!,
                                Colors.deepPurple[700]!,
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
