import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1/models/task_parameters.dart';
import 'package:f1/models/tasks.dart';

Stream<List<TaskDTO>> getTasksByProjectId(String projectId) {
  return FirebaseFirestore.instance
      .collection('tasks')
      .where('id_p', isEqualTo: projectId)
      .snapshots()
      .asyncMap((snapshot) async {
        List<TaskDTO> tasks = [];

        for (var doc in snapshot.docs) {
          var taskData = doc.data();
          // Lấy DocumentReference từ trường `assign_at`
          DocumentReference? userRef =
              taskData['assign_at'] as DocumentReference?;
          String? displayName;

          // Nếu có Reference, lấy displayName từ user document
          if (userRef != null) {
            var userDoc = await userRef.get();
            displayName =
                userDoc.exists ? userDoc['displayName'] as String : 'QQQQQQQ';
          }

          // Tạo TaskDTO với displayName thay thế cho assign_at
          tasks.add(TaskDTO.fromFirestore(doc, displayName));
        }

        return tasks;
      });
}

Stream<List<String>> getEmailListStream() {
  return FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => doc['email'] as String).toList(),
      );
}

Future<String> getUserIdByEmail(String email) async {
  final query =
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1) // email phải là duy nhất
          .get(); // chỉ truy vấn một lần

  if (query.docs.isNotEmpty) {
    // Nếu bạn muốn lấy đúng doc ID (là uid)
    return query.docs.first.id;

    // Nếu bạn lưu uid trong field 'uid', dùng:
    // return query.docs.first['uid'] as String;
  }

  // Không tìm thấy user nào
  throw Exception('Không tìm thấy user với email $email');
}

Future<DocumentReference> createTask(TaskParameters params) async {
  // 1. Tạo DocumentReference tới user đã được phân công
  final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(params.assignee);

  // 2. Chuẩn bị map data để ghi vào Firestore
  final taskData = <String, dynamic>{
    'name_t': params.name,
    'assign_at': userRef, // lưu đủ DocumentReference
    'start_date': Timestamp.fromDate(params.startDate),
    'due_date': Timestamp.fromDate(params.endDate),
    'id_p': params.idProject,
    'status': params.status,
  };

  // 3. Ghi vào collection "tasks"
  final docRef = await FirebaseFirestore.instance
      .collection('tasks')
      .add(taskData);

  return docRef; // trả về reference của document mới
}

void deleteTaskByName(String name) {
  // Truy vấn stream từ collection 'task2' với điều kiện name_t = 'bd'
  FirebaseFirestore.instance
      .collection('tasks')
      .where('name_t', isEqualTo: name)
      .snapshots()
      .listen((querySnapshot) {
        // Xử lý từng document trong kết quả truy vấn
        for (final doc in querySnapshot.docs) {
          doc.reference
              .delete()
              .then((_) => print('Document ${doc.id} deleted'))
              .catchError((error) => print('Delete failed: $error'));
        }
      });
}

Future<void> updateTaskStatus(String taskId, String newStatus) async {
  await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
    'status': newStatus,
  });
}
