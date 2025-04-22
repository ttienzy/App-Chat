import 'package:f1/auth/tasks_notifier.dart';
import 'package:f1/models/tasks.dart';
import 'package:f1/screens/add_task_from_screen.dart';
import 'package:f1/widgets/export_excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskAssignmentScreen extends StatefulWidget {
  final String idProject;
  final String projectName;
  const TaskAssignmentScreen({
    super.key,
    required this.idProject,
    required this.projectName,
  });

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
    bool isCompleted = false;
    final newTasks =
        tasks.map((item) {
          return Task(
            name: item.taskName,
            start: item.startDate,
            end: item.dueDate,
            participants: [item.displayName],
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.projectName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple, Color.fromARGB(255, 159, 116, 232)],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.file_download_outlined),
              tooltip: 'Xuất Excel',
              onPressed: () {
                exportTasksToExcel(
                  context: context,
                  projectName: widget.projectName,
                  tasks: newTasks,
                );
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_task, color: Colors.white),
        label: const Text(
          "Thêm Task",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => AddTaskFormScreen(idProject: widget.idProject),
            ),
          );

          if (result != null && result is Task) {
            // Xử lý khi nhận được task mới từ form
            // Ví dụ:
            // setState(() {
            //   taskList.add(result);
            // });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm task: ${result.name}'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }
        },
      ),
      body:
          tasks.isEmpty
              ? Center(
                child: const Text(
                  'Chưa có task nào',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : Container(
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

    return Card(
      elevation: 3,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header với gradient
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
              ],
            ),
          ),

          // Body content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Người được giao
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 18,
                      color: Colors.deepPurple.shade400,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Giao cho: ${task.displayName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Thời gian
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.deepPurple.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$startDateStr - $endDateStr',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),

                    // Hiển thị ngày còn lại
                    if (task.status != 'completed')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              daysRemaining < 0
                                  ? Colors.red.shade50
                                  : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                daysRemaining < 0
                                    ? Colors.red.shade200
                                    : Colors.blue.shade200,
                            width: 0.5,
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

                // Nút hành động được cải tiến
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Xử lý khi nhấn nút "Chưa hoàn thành"
                      },
                      icon: const Icon(
                        Icons.pending_actions,
                        size: 16,
                        color: Colors.orange,
                      ),
                      label: const Text('Chưa hoàn thành'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Xử lý khi nhấn nút "Đã hoàn thành"
                      },
                      icon: const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text('Đã hoàn thành'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
