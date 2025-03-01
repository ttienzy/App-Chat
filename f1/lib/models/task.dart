class TaskItem {
  final String taskName;
  final String assignedTo;
  final double progress; // 0.0 -> 1.0
  final String status; // 'ongoing', 'completed', 'delayed', ...
  final DateTime startDate;
  final DateTime endDate;

  TaskItem({
    required this.taskName,
    required this.assignedTo,
    required this.progress,
    required this.status,
    required this.startDate,
    required this.endDate,
  });
}
