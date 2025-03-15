import 'package:f1/auth/tasks_notifier.dart';
import 'package:f1/models/tasks.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskAssignmentScreen extends StatefulWidget {
  final String idProject;
  const TaskAssignmentScreen({super.key, required this.idProject});

  @override
  State<TaskAssignmentScreen> createState() => _TaskAssignmentScreen();
}

class _TaskAssignmentScreen extends State<TaskAssignmentScreen> {
  // Demo 5 task
  //final List<TaskItem> tasks = ListTask().getTasks();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider = Provider.of<TasksProvider>(
        context,
        listen: false,
      );
      projectProvider.getTask(widget.idProject);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TasksProvider>(context).tasks;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân công nhiệm vụ'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Tìm kiếm task
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Lọc task theo trạng thái, tiến độ...
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          // TODO: Tạo task mới
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskCard(task, context);
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskDTO task, BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDateStr = dateFormat.format(task.startDate);
    final endDateStr = dateFormat.format(task.dueDate);

    // Tính số ngày còn lại (hoặc quá hạn)
    final daysRemaining = task.dueDate.difference(DateTime.now()).inDays;

    // Xác định màu & text cho trạng thái
    Color statusColor;
    String statusText;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tên task
                Expanded(
                  child: Text(
                    task.taskName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                //Badge trạng thái
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 10,
                //     vertical: 6,
                //   ),
                //   decoration: BoxDecoration(
                //     color: statusColor,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     statusText,
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Người được giao
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Giao cho: ${task.displayName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Thời gian
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$startDateStr - $endDateStr',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const Spacer(),
                    // Nếu task chưa hoàn thành, hiển thị số ngày còn lại
                    if (task.status != 'completed')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              daysRemaining < 0
                                  ? Colors.red.shade50
                                  : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color:
                                daysRemaining < 0
                                    ? Colors.red.shade200
                                    : Colors.blue.shade200,
                          ),
                        ),
                        child: Text(
                          daysRemaining >= 0
                              ? 'Còn $daysRemaining ngày'
                              : 'Quá hạn ${-daysRemaining} ngày',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                daysRemaining < 0
                                    ? Colors.red.shade700
                                    : Colors.blue.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nút hành động
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Thêm logic xem chi tiết
                      },
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Chi tiết'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.deepPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Thêm logic đánh dấu hoàn thành
                      },
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: const Text('Hoàn thành'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
