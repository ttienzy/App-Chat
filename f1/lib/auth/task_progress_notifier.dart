// lib/notifiers/project_progress_notifier.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:f1/models/project_progress.dart';
import 'package:f1/repositories/task_progress_repo.dart';

class ProjectProgressNotifier extends ChangeNotifier {
  List<ProjectProgress> _projects = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<ProjectProgress>>? _sub;

  List<ProjectProgress> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void getProjects() {
    _isLoading = true;
    notifyListeners();

    // Hủy subscription cũ nếu đã tồn tại
    _sub?.cancel();

    // Đăng ký stream mới
    _sub = watchProjectProgresses().listen(
      (projectsList) {
        _projects = projectsList;
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
    _sub?.cancel();
    super.dispose();
  }
}
