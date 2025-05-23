import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1/models/project.dart';
import 'package:f1/models/project_create_dto.dart';

Stream<List<Project>> getAllProjects(String userId) {
  return FirebaseFirestore.instance
      .collection('projects')
      .where(
        'members',
        arrayContainsAny: ['${userId}_leader', '${userId}_member'],
      )
      .orderBy('start_date', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Project.fromFirestore(doc.data(), doc.id, userId);
        }).toList();
      });
}

Stream<List<Project>> searchProjectByName(String userId, String nameProject) {
  return FirebaseFirestore.instance
      .collection('projects')
      .where(
        'members',
        arrayContainsAny: ['${userId}_leader', '${userId}_member'],
      )
      // .where('name_p_keywords', arrayContains: nameProject.toLowerCase())
      //.where('name_p', isEqualTo: nameProject)
      .where('name_p', isGreaterThanOrEqualTo: nameProject)
      .where('name_p', isLessThan: '${nameProject}z')
      .orderBy('start_date')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Project.fromFirestore(doc.data(), doc.id, userId);
        }).toList();
      });
}

Stream<List<Project>> filterProjectByProgress(String userId) {
  return FirebaseFirestore.instance
      .collection('projects')
      .where(
        'members',
        arrayContainsAny: ['${userId}_leader', '${userId}_member'],
      )
      .orderBy('progress_p')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Project.fromFirestore(doc.data(), doc.id, userId);
        }).toList();
      });
}

Stream<List<Project>> filterProjectByStartDate(String userId) {
  return FirebaseFirestore.instance
      .collection('projects')
      .where(
        'members',
        arrayContainsAny: ['${userId}_leader', '${userId}_member'],
      )
      .orderBy('start_date', descending: false)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Project.fromFirestore(doc.data(), doc.id, userId);
        }).toList();
      });
}

// Add a new project
Future<void> addProject(ProjectCreateDto projectdto) async {
  await FirebaseFirestore.instance
      .collection('projects')
      .add(projectdto.toJson());
}

// Join project
Future<DocumentSnapshot<Map<String, dynamic>>> getProjectById(
  String projectId,
) async {
  final docSnapshot =
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .get();
  print(docSnapshot.data());
  return docSnapshot;
}

Future<void> addToMember(String projectId, List<String> newMembers) async {
  await FirebaseFirestore.instance.collection('projects').doc(projectId).update(
    {'members': newMembers},
  );
}

Future<void> updateProjectAttributes({
  required String projectId,
  String? name,
  String? description,
  DateTime? startDate,
  DateTime? endDate,
  double? progress,
  String? status,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .update({
          if (name != null) 'name_p': name,
          if (description != null) 'desc_p': description,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
          if (progress != null) 'progress_p': progress,
          if (status != null) 'status': status,
        });
    print('Cập nhật thành công');
  } catch (e) {
    print('Lỗi khi cập nhật: $e');
  }
}

Future<void> deleteProject({required String projectId}) async {
  try {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .delete();
    print('Đã xóa dự án thành công');
  } catch (e) {
    print('Lỗi khi xóa dự án: $e');
    throw e; // Ném lỗi để có thể xử lý ở nơi gọi hàm nếu cần
  }
}
