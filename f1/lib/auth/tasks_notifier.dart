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
    super.dispose();
  }
}
