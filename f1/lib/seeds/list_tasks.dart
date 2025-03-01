import 'package:f1/models/task.dart';

class ListTask {
  List<TaskItem> getTasks() {
    return [
      TaskItem(
        taskName: 'Thiết kế giao diện',
        assignedTo: 'Nguyễn Văn A',
        progress: 0.3,
        status: 'ongoing',
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 10),
      ),
      TaskItem(
        taskName: 'Phân tích yêu cầu',
        assignedTo: 'Trần Thị B',
        progress: 0.6,
        status: 'ongoing',
        startDate: DateTime(2025, 3, 2),
        endDate: DateTime(2025, 3, 8),
      ),
      TaskItem(
        taskName: 'Lập trình backend',
        assignedTo: 'Lê Văn C',
        progress: 0.9,
        status: 'delayed',
        startDate: DateTime(2025, 3, 5),
        endDate: DateTime(2025, 3, 12),
      ),
      TaskItem(
        taskName: 'Kiểm thử tính năng',
        assignedTo: 'Phạm Thị D',
        progress: 1.0,
        status: 'completed',
        startDate: DateTime(2025, 2, 28),
        endDate: DateTime(2025, 3, 5),
      ),
      TaskItem(
        taskName: 'Triển khai hệ thống',
        assignedTo: 'Hoàng Văn E',
        progress: 0.1,
        status: 'ongoing',
        startDate: DateTime(2025, 3, 10),
        endDate: DateTime(2025, 3, 20),
      ),
    ];
  }
}
