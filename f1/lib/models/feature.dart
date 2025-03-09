import 'package:flutter/material.dart';

enum FeatureType {
  projectManagement,
  taskAssignment,
  progressTracking,
  projectDocumentation,
  groupChat,
  statisticsReport,
  ganttChart,
}

class Feature {
  final FeatureType type;
  final String title;
  final IconData icon;

  const Feature({required this.type, required this.title, required this.icon});
}

class ListFeatures {
  List<Feature> getFeatures() {
    return [
      Feature(
        type: FeatureType.projectManagement,
        title: 'Quản lý dự án',
        icon: Icons.folder_open,
      ),
      Feature(
        type: FeatureType.taskAssignment,
        title: 'Phân công nhiệm vụ',
        icon: Icons.assignment_ind,
      ),
      Feature(
        type: FeatureType.progressTracking,
        title: 'Theo dõi tiến độ',
        icon: Icons.track_changes,
      ),
      Feature(
        type: FeatureType.projectDocumentation,
        title: 'Tài liệu dự án',
        icon: Icons.description,
      ),
      Feature(
        type: FeatureType.groupChat,
        title: 'Chat nhóm',
        icon: Icons.chat,
      ),
      Feature(
        type: FeatureType.statisticsReport,
        title: 'Báo cáo thống kê',
        icon: Icons.bar_chart,
      ),
      Feature(
        type: FeatureType.ganttChart,
        title: 'Biểu đồ Gantt',
        icon: Icons.timeline,
      ),
    ];
  }
}
