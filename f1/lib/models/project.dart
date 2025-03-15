import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1/shared/parse_user.dart';

class Project {
  final String idProject;
  final String name;
  final String description;
  final double progress; // Giá trị từ 0.0 -> 1.0
  final int membersCount; // Số thành viên
  final DateTime startDate; // Thời gian bắt đầu
  final DateTime endDate; // Thời gian kết thúc
  final String status; // Trạng thái dự án: 'ongoing', 'completed', 'delayed'
  final String role;
  final List<String> members;

  Project({
    required this.idProject,
    required this.name,
    required this.description,
    required this.progress,
    required this.membersCount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.role,
    required this.members,
  });

  factory Project.fromFirestore(
    Map<String, dynamic> data,
    String id,
    String userId,
  ) {
    return Project(
      idProject: id,
      name: data['name_p'] ?? '',
      description: data['desc_p'] ?? '',
      progress: (data['progress_p'] ?? 0.0).toDouble(),
      membersCount: (data['members'] as List?)?.length ?? 0,
      members:
          (data['members'] as List<dynamic>).map((e) => e as String).toList(),
      startDate: (data['start_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['end_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'ongoing',
      role:
          getRoleByUserId((data['members'] as List).cast<String>(), userId) ??
          'member',
    );
  }
  static String? getRoleByUserId(List<String> members, String userId) {
    for (var member in members) {
      final item = parseUserRole(member);
      if (item['user_id'] == userId) {
        return item['role_in'];
      }
    }
    return null;
  }
}
