import 'package:f1/models/project.dart';
import 'package:f1/screens/project_edit_screen.dart';
import 'package:f1/screens/project_with_task_screen.dart';
import 'package:f1/widgets/hover_copy_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:f1/shared/color_shared.dart';

Widget buildProjectCard(Project project, BuildContext context) {
  // Định dạng date
  final dateFormat = DateFormat('dd/MM/yyyy');
  final startDateStr = dateFormat.format(project.startDate);
  final endDateStr = dateFormat.format(project.endDate);

  // Tính số ngày còn lại
  final daysRemaining = project.endDate.difference(DateTime.now()).inDays;

  // Xác định màu sắc dựa vào trạng thái
  Color statusColor;
  String statusText;
  switch (project.status) {
    case 'completed':
      statusColor = Colors.green;
      statusText = 'Hoàn thành';
      break;
    case 'delayed':
      statusColor = Colors.orange;
      statusText = 'Chậm tiến độ';
      break;
    case 'ongoing':
    default:
      statusColor = Colors.blue;
      statusText = 'Đang thực hiện';
  }

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Theme.of(context).scaffoldBackgroundColor,
    elevation: 8,
    shadowColor: const Color.fromARGB(66, 13, 68, 217),
    margin: const EdgeInsets.symmetric(vertical: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Phần tiêu đề (header) của Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 108, 129, 172),
                const Color.fromARGB(255, 43, 65, 135),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tên dự án
              Expanded(
                child: Text(
                  project.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Badge trạng thái
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Phần nội dung (body) của Card
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin thời gian và thành viên
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$startDateStr - $endDateStr',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    '${project.membersCount} - ${project.role}(you)',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mô tả
              Text(
                project.description,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Hiển thị số ngày còn lại
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (project.status != 'completed')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            daysRemaining < 7
                                ? Colors.red.shade50
                                : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              daysRemaining < 7
                                  ? Colors.red.shade200
                                  : Colors.blue.shade200,
                        ),
                      ),
                      child: Text(
                        daysRemaining > 0
                            ? 'Còn $daysRemaining ngày'
                            : 'Quá hạn ${-daysRemaining} ngày',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              daysRemaining < 7
                                  ? Colors.red.shade700
                                  : Colors.blue.shade700,
                        ),
                      ),
                    ),
                  HoverCopyText(text: project.idProject),
                ],
              ),
              const SizedBox(height: 16),

              // Tiến độ label và phần trăm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tiến độ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    '${(project.progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: getProgressColor(project.progress),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Thanh tiến độ cải tiến (đã sửa không sử dụng MediaQuery để tránh tràn viền)
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        // Background của progress bar
                        Container(
                          height: 10,
                          width: maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Foreground của progress bar
                        Container(
                          height: 10,
                          width: maxWidth * project.progress,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                getProgressColor(
                                  project.progress,
                                ).withOpacity(0.8),
                                getProgressColor(project.progress),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed:
                        project.role ==
                                'leader' // Điều kiện kiểm tra ở đây
                            ? () async {
                              // Nếu là 'leader', gán hàm xử lý
                              final updatedProject = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EditProjectScreen(project: project),
                                ),
                              );
                              if (updatedProject != null) {
                                print(
                                  'Dự án đã được cập nhật: ${updatedProject}',
                                );
                                // Bạn có thể muốn cập nhật UI ở đây nếu cần
                                // setState(() { ... });
                              }
                            }
                            : null, // Nếu không phải 'leader', gán null để disable button
                    icon: Icon(
                      Icons.edit_document,
                      size: 16,
                      // Tùy chọn: thay đổi màu icon khi bị disable để rõ ràng hơn
                      color:
                          project.role == 'leader' ? Colors.blue : Colors.grey,
                    ),
                    label: Text(
                      'Điều chỉnh',
                      // Tùy chọn: thay đổi màu text khi bị disable
                      style: TextStyle(
                        color:
                            project.role == 'leader'
                                ? Colors.deepPurple
                                : Colors.grey,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      // foregroundColor sẽ được Flutter tự động xử lý khi button bị disable (thường là màu xám)
                      // Tuy nhiên, nếu bạn muốn kiểm soát hoàn toàn, bạn có thể đặt điều kiện ở đây:
                      // foregroundColor: project.role == 'leader' ? Colors.deepPurple : Colors.grey,
                      side: BorderSide(
                        // Tùy chọn: thay đổi màu viền khi bị disable
                        color:
                            project.role == 'leader'
                                ? Colors.deepPurple
                                : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TaskAssignmentScreen(
                                idProject: project.idProject,
                                projectName: project.name,
                              ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.visibility,
                      size: 16,
                      color: Colors.blue,
                    ),
                    label: const Text('Xem tiến độ'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
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
