import 'package:flutter/material.dart';

class Feature {
  final String title;
  final IconData icon;

  const Feature({required this.title, required this.icon});
}

class ListFeatures {
  List<Feature> getFeatures() {
    return [
      Feature(title: 'Quản lý dự án', icon: Icons.folder_open),
      Feature(title: 'Phân công nhiệm vụ', icon: Icons.assignment_ind),
      Feature(title: 'Theo dõi tiến độ', icon: Icons.track_changes),
      Feature(title: 'Tài liệu dự án', icon: Icons.description),
      Feature(title: 'Chat nhóm', icon: Icons.chat),
      Feature(title: 'Báo cáo thống kê', icon: Icons.bar_chart),
      Feature(title: 'Biểu đồ Gantt', icon: Icons.timeline),
    ];
  }
}
