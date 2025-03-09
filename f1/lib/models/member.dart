class Member {
  final String roleIn;
  final String userId;

  const Member({required this.roleIn, required this.userId});

  @override
  String toString() => '${userId}_$roleIn';
}
