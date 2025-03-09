import 'dart:async';

import 'package:f1/models/project.dart';
import 'package:f1/repositories/project_repository.dart';
import 'package:flutter/material.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Project>>? _projectSubscription;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Hàm này đăng ký lắng nghe stream từ Firebase
  void listenToProjects(String userId) {
    _isLoading = true;
    notifyListeners();

    // Hủy bất kỳ subscription cũ nào nếu có
    _projectSubscription?.cancel();

    _projectSubscription = getAllProjects(userId).listen(
      (projectsData) {
        _projects = projectsData;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void listenFilterPogressToProjects(String userId) {
    _isLoading = true;
    notifyListeners();

    // Hủy bất kỳ subscription cũ nào nếu có
    _projectSubscription?.cancel();

    _projectSubscription = filterProjectByProgress(userId).listen(
      (projectsData) {
        _projects = projectsData;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void listenFilterOldProjects(String userId) {
    _isLoading = true;
    notifyListeners();

    // Hủy bất kỳ subscription cũ nào nếu có
    _projectSubscription?.cancel();

    _projectSubscription = filterProjectByStartDate(userId).listen(
      (projectsData) {
        _projects = projectsData;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void listenSearchToProjects(String userId, String nameProject) {
    _isLoading = true;
    notifyListeners();

    // Hủy bất kỳ subscription cũ nào nếu có
    _projectSubscription?.cancel();

    _projectSubscription = searchProjectByName(userId, nameProject).listen(
      (projectsData) {
        _projects = projectsData;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _projectSubscription?.cancel();
    super.dispose();
  }
}
