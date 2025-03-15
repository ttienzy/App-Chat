import 'package:cloud_firestore/cloud_firestore.dart';
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
