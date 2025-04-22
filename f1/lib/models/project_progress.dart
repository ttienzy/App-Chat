import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectProgress {
  final String name;
  final double progress;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;

  ProjectProgress({
    required this.name,
    required this.progress,
    required this.startDate,
    required this.endDate,
    required this.color,
  });
  factory ProjectProgress.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    Color fixedColor = Colors.blue,
  }) {
    final data = doc.data()!;
    return ProjectProgress(
      name: data['name_p'] as String,
      progress: (data['progress_p'] as num).toDouble(),
      startDate: (data['start_date'] as Timestamp).toDate(),
      endDate: (data['end_date'] as Timestamp).toDate(),
      color: fixedColor,
    );
  }

  // Tính số ngày đã trôi qua từ khi bắt đầu dự án
  int get daysElapsed {
    final today = DateTime.now();
    return today.difference(startDate).inDays;
  }

  // Tính tổng số ngày của dự án
  int get totalDays {
    return endDate.difference(startDate).inDays;
  }

  // Tính phần trăm thời gian đã trôi qua
  double get timePercentage {
    if (totalDays == 0) return 1.0;
    return daysElapsed / totalDays;
  }

  // Kiểm tra xem dự án có đang tiến độ tốt không
  bool get isOnTrack {
    // Nếu phần trăm hoàn thành >= phần trăm thời gian đã qua, dự án đang đúng tiến độ
    return progress >= timePercentage;
  }

  // Tính số ngày còn lại đến hạn
  int get daysRemaining {
    final today = DateTime.now();
    return endDate.difference(today).inDays;
  }
}
