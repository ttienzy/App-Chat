import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDTO {
  final String id;
  final String taskName;
  final String displayName; // Lưu đường dẫn tham chiếu
  final DateTime dueDate;
  final DateTime startDate;
  final String projectId;
  final String status;

  TaskDTO({
    required this.id,
    required this.taskName,
    required this.displayName,
    required this.dueDate,
    required this.startDate,
    required this.projectId,
    required this.status,
  });

  // Chuyển đổi từ Firestore document sang DTO
  factory TaskDTO.fromFirestore(DocumentSnapshot doc, String? nameUser) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TaskDTO(
      id: doc.id,
      taskName: data['name_t'] ?? '',
      // Lấy đường dẫn tham chiếu dưới dạng chuỗi
      displayName: nameUser ?? '', // Xử lý trường hợp không phải chuỗi
      dueDate:
          (data['due_date'] is Timestamp)
              ? (data['due_date'] as Timestamp).toDate()
              : DateTime.now(),
      startDate:
          (data['start_date'] is Timestamp)
              ? (data['start_date'] as Timestamp).toDate()
              : DateTime.now(),
      projectId: data['id_p'] ?? '',
      status: data['status'] ?? 'ongoing',
    );
  }
}
