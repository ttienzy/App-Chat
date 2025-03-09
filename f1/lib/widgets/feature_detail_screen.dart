import 'package:f1/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:f1/screens/projects_screen.dart';

/// Trang chi tiết cho từng tính năng
class FeatureDetailPage extends StatelessWidget {
  final Feature feature;
  const FeatureDetailPage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: ProjectManagementScreen());
    switch (feature.type) {
      case FeatureType.projectManagement:
        return Scaffold(body: ProjectManagementScreen());
      case FeatureType.taskAssignment:
        return Scaffold(body: Center(child: Text('Tính năng chưa khả dụng1')));
      case FeatureType.progressTracking:
        return Scaffold(body: Center(child: Text('Tính năng chưa khả dụng2')));
      case FeatureType.projectDocumentation:
        return Scaffold(body: Center(child: Text('Tính năng chưa khả dụng3')));
      case FeatureType.groupChat:
        return Scaffold(body: Center(child: Text('Tính năng chưa khả dụng4')));
      case FeatureType.statisticsReport:
        return Scaffold(body: Center(child: Text('Tính năng chưa khả dụng5')));
      case FeatureType.ganttChart:
        return Scaffold(body: Center(child: Text('Tính năng chưa khả dụng6')));
    }
  }
}
