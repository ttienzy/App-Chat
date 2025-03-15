import 'package:f1/repositories/chat_repository.dart';

Future<void> addMessageServices(
  String content,
  String roomId,
  String userId,
) async {
  try {
    addMessage(content, roomId, userId);
  } catch (e, stackTrace) {
    print('Error adding message: $e');
    print(stackTrace);
    // Nếu muốn bắn lỗi ngược ra ngoài:
  }
}
