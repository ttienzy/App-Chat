import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1/models/user.dart';
import 'package:f1/shared/get_timestamp.dart';

class Message {
  final String id;
  final String content;
  final String createdAt;
  final String roomId;
  // Nếu muốn lưu luôn tham chiếu (reference) tới user:
  final DocumentReference userRef;
  final User? user;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.roomId,
    required this.userRef,
    this.user,
  });
  Message copyWith(User? getInfo) {
    return Message(
      id: id,
      content: content,
      createdAt: createdAt,
      roomId: roomId,
      userRef: userRef,
      user: getInfo,
    );
  }

  // Factory constructor để map dữ liệu từ Firestore
  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      id: data['id'] ?? '',
      content: data['content'] ?? '',
      // Giả sử created_at là Timestamp của Firestore
      createdAt: getSmartTimestamp(data['created_at'] as Timestamp),
      roomId: data['room_id'] ?? '',
      // user_id là một DocumentReference
      userRef: data['user_id'] as DocumentReference,
    );
  }
}

class ChatRoom {
  final String id;
  final String name;
  final String desc;
  ChatRoom({required this.id, required this.name, required this.desc});
  factory ChatRoom.fromMap(String docId, Map<String, dynamic> data) {
    return ChatRoom(
      id: docId,
      name: data['name_r'] ?? '',
      desc: data['desc_r'] ?? '',
    );
  }
}
