import 'package:f1/models/groups.dart';
import 'package:f1/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MessagesProvider extends ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _messagesSubscription;

  // Getters
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Khởi tạo stream và đăng ký lắng nghe
  void getMessages(String roomId) {
    _isLoading = true;
    notifyListeners();

    // Hủy subscription cũ nếu đã tồn tại
    _messagesSubscription?.cancel();

    // Đăng ký stream mới
    _messagesSubscription = streamMessagesByRoomId(roomId).listen(
      (messagesList) {
        _messages = messagesList;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Tìm kiếm message theo tên
  void searchMessage(String keyword) {
    // Thực hiện tìm kiếm trong danh sách đã có
    // Hoặc thực hiện truy vấn mới đến Firestore
  }

  // Hủy subscription khi không cần thiết nữa
  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
