import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1/models/groups.dart';
import 'package:f1/models/user.dart';

Stream<List<ChatRoom>> streamRoomsDataByUserId(String userId) {
  try {
    final query = FirebaseFirestore.instance
        .collection('rooms')
        .where(
          'members',
          arrayContainsAny: ['${userId}_leader', '${userId}_member'],
        )
        .orderBy('created_at', descending: true);
    // Có thể print hoặc debug ở đây
    print('Firestore Query: $query');

    // Tạo stream dựa trên query
    final roomsStream = query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final docData = doc.data();
        print('docData for doc ${doc.id} => $docData');
        return ChatRoom.fromMap(doc.id, docData);
      }).toList();
    });
    return roomsStream;
  } catch (err) {
    print('streamRoomsDataByUserId ERROR : ${err.toString()}');
    return Stream.value([]);
  }
}

Stream<List<Message>> streamMessagesByRoomId(String roomId) {
  // Tạo query để dễ test / debug
  final query = FirebaseFirestore.instance
      .collection('messages')
      .where('room_id', isEqualTo: roomId)
      .orderBy('created_at', descending: false);

  // In ra console để kiểm tra nếu cần
  print('Firestore Query: $query');

  // Tạo stream
  return query.snapshots().asyncMap((snapshot) async {
    final messageDocs = snapshot.docs;
    final futureMessages =
        messageDocs.map((doc) async {
          final data = doc.data();
          data['id'] = doc.id;
          // Tạo message "thô"
          final msg = Message.fromMap(data);

          // Gọi userRef.get() để lấy user data
          final userSnap = await msg.userRef.get();
          if (!userSnap.exists) {
            return msg; // user doc không tồn tại
          }
          final userData = userSnap.data() as Map<String, dynamic>;

          // Lấy photoURL, displayName
          final photoUrl = userData['photoURL'] as String? ?? 'QQQQQ';
          final displayName = userData['displayName'] as String? ?? 'QQQQQ';
          final idUser = userData['uid'] as String? ?? 'QQQQQ';

          // Trả về message kèm info user
          return msg.copyWith(User(idUser, displayName, photoUrl));
        }).toList();

    // Đợi tất cả future xong
    return Future.wait(futureMessages);
  });
}

Future<void> addMessage(
  String content,
  String roomId,
  String userId, // userId là chuỗi ID của user
) async {
  // Tạo DocumentReference đến user
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  await FirebaseFirestore.instance.collection('messages').add({
    'content': content,
    'created_at': FieldValue.serverTimestamp(), // Thời gian server
    'room_id': roomId,
    'user_id': userRef, // Lưu dưới dạng DocumentReference
  });
}
