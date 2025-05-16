import 'package:f1/models/tasks.dart';
import 'package:f1/repositories/task_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TasksProvider extends ChangeNotifier {
  List<TaskDTO> _tasks = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _messagesSubscription;

  // Getters
  List<TaskDTO> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  final StreamController<String> _deleteTaskController =
      StreamController<String>.broadcast();
  StreamSubscription? _deleteSubscription;
  final StreamController<Map<String, dynamic>> _statusUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _statusUpdateSubscription;
  TasksProvider() {
    _listenToStatusUpdates();
  }
  void _listenToStatusUpdates() {
    _statusUpdateSubscription = _statusUpdateController.stream.listen(
      (updateData) async {
        final String taskId = updateData['taskId'];
        final String newStatus = updateData['newStatus'];
        await _handleStatusUpdate(taskId, newStatus);
      },
      onError: (e) {
        _error = 'Lỗi stream: ${e.toString()}';
        notifyListeners();
      },
    );
  }

  Future<void> _handleStatusUpdate(String taskId, String newStatus) async {
    try {
      if (newStatus != 'ongoing' && newStatus != 'completed') {
        throw Exception('Trạng thái không hợp lệ');
      }

      // Tối ưu tìm kiếm task bằng Map để tránh duyệt toàn bộ danh sách
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return; // Không tìm thấy task

      final currentStatus = _tasks[taskIndex].status;
      if (currentStatus == newStatus) return; // Trạng thái không thay đổi

      // CẬP NHẬT TRẠNG THÁI TRÊN LUỒNG RIÊNG
      _isLoading = true;
      notifyListeners(); // Chỉ gọi 1 lần

      // Cập nhật Firestore và local state trong background
      await updateTaskStatus(taskId, newStatus);

      _isLoading = false;
      _error = null;
      notifyListeners(); // Chỉ gọi 1 lần
    } catch (e) {
      _isLoading = false;
      _error = 'Lỗi cập nhật: ${e.toString()}';
      notifyListeners();
    }
  }

  // Hàm public để kích hoạt cập nhật trạng thái từ UI
  void triggerStatusUpdate(String taskId, String newStatus) {
    _statusUpdateController.add({'taskId': taskId, 'newStatus': newStatus});
  }

  void initDeleteStream() {
    _deleteSubscription = _deleteTaskController.stream.listen((name) {
      _deleteTaskByName(name); // Gọi hàm xóa
    });
  }

  Future<void> _deleteTaskByName(String name) async {
    try {
      // Gọi repository/repository xóa task
      deleteTaskByName(name);

      // Cập nhật danh sách tasks sau khi xóa
      notifyListeners();
    } catch (e) {
      _error = 'Lỗi xóa task: ${e.toString()}';
      notifyListeners();
    }
  }

  // Hàm public để kích hoạt xóa
  void deleteTask(String name) {
    _deleteTaskController.add(name); // Đẩy sự kiện vào stream
  }

  // Khởi tạo stream và đăng ký lắng nghe
  void getTask(String projectId) {
    _isLoading = true;
    notifyListeners();

    // Hủy subscription cũ nếu đã tồn tại
    _messagesSubscription?.cancel();

    // Đăng ký stream mới
    _messagesSubscription = getTasksByProjectId(projectId).listen(
      (taskList) {
        _tasks = taskList;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _deleteSubscription?.cancel(); // Hủy subscription xóa
    _deleteTaskController.close();
    _statusUpdateSubscription?.cancel();
    _statusUpdateController.close();
    super.dispose();
  }
}
