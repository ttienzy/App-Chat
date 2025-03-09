import 'package:f1/models/member.dart';

class ProjectCreateDto {
  String desc;
  DateTime endDate;
  List<Member> members;
  String name;
  double progress;
  DateTime startDate;
  String status;
  List<String> nameKeywords;

  ProjectCreateDto({
    required this.desc,
    required this.endDate,
    this.members = const [],
    required this.name,
    required this.progress,
    required this.startDate,
    required this.status,
    this.nameKeywords = const [],
  });
  Map<String, dynamic> toJson() {
    return {
      'desc_p': desc,
      'end_date': endDate,
      'members': members.map((member) => member.toString()).toList(),
      'name_p': name,
      'progress_p': progress,
      'start_date': startDate,
      'status': status,
      'name_p_keywords': nameKeywords,
    };
  }
}
