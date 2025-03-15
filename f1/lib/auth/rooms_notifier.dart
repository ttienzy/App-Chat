import 'package:f1/models/groups.dart';
import 'package:f1/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RoomsProvider extends ChangeNotifier {
  List<ChatRoom> _rooms = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _roomsSubscription;

  // Getters
  List<ChatRoom> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Khởi tạo stream và đăng ký lắng nghe
  void getRooms(String userId) {
    _isLoading = true;
    notifyListeners();

    // Hủy subscription cũ nếu đã tồn tại
    _roomsSubscription?.cancel();

    // Đăng ký stream mới
    _roomsSubscription = streamRoomsDataByUserId(userId).listen(
      (roomsList) {
        _rooms = roomsList;
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

  // Tìm kiếm phòng theo tên
  void searchRooms(String keyword) {
    // Thực hiện tìm kiếm trong danh sách đã có
    // Hoặc thực hiện truy vấn mới đến Firestore
  }

  // Hủy subscription khi không cần thiết nữa
  @override
  void dispose() {
    _roomsSubscription?.cancel();
    super.dispose();
  }
}
