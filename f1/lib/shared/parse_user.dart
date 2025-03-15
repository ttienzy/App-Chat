Map<String?, String?> parseUserRole(String userRoleString) {
  final lastUnderscoreIndex = userRoleString.lastIndexOf('_');

  if (lastUnderscoreIndex != -1) {
    final userId = userRoleString.substring(0, lastUnderscoreIndex);
    final role = userRoleString.substring(lastUnderscoreIndex + 1);

    return {'user_id': userId, 'role_in': role};
  }
  return {'userId': null, 'role': null};
}
