import 'package:f1/models/member.dart';
import 'package:f1/models/project_create_dto.dart';
import 'package:f1/repositories/project_repository.dart';
import 'package:f1/shared/prefix_search.dart';

Future<bool> addProjectServices(dynamic result, String userId) async {
  try {
    ProjectCreateDto projectCreateDto = ProjectCreateDto(
      name: result['name'], // Sử dụng key 'name'
      desc: result['description'], // Sử dụng key 'description'
      startDate: result['startDate'], // Sử dụng key 'startDate'
      endDate: result['endDate'], // Sử dụng key 'endDate'
      status: 'ongoing',
      progress: 0.0,
      members: [Member(roleIn: 'leader', userId: userId)],
      nameKeywords: generateKeywords(result['name']),
    );

    await addProject(projectCreateDto);

    return true;
  } catch (e) {
    print('err : ${e}');
    return false;
  }
}

Future<Map<String, dynamic>> getProjectByIdServices(String projectId) async {
  try {
    final docSnapshot = await getProjectById(projectId);

    if (docSnapshot.exists) {
      var results = docSnapshot.data();
      return {'status': true, 'members': results?['members'] ?? []};
    } else {
      return {'status': false, 'members': []};
    }
  } catch (e) {
    return {'status': false, 'members': []};
  }
}

Future<bool> addToMemberServices(
  String projectId,
  List<String> newMembers,
) async {
  try {
    await addToMember(projectId, newMembers);
    return true;
  } catch (err) {
    print(err);
    return false;
  }
}
