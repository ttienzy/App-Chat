class Project {
  final String name;
  final String description;
  final double progress; // Giá trị từ 0.0 -> 1.0
  final int membersCount; // Số thành viên
  final DateTime startDate; // Thời gian bắt đầu
  final DateTime endDate; // Thời gian kết thúc
  final String status; // Trạng thái dự án: 'ongoing', 'completed', 'delayed'

  Project({
    required this.name,
    required this.description,
    required this.progress,
    required this.membersCount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
