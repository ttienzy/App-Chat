import 'package:f1/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:f1/screens/projects_screen.dart';

/// Trang chi tiết cho từng tính năng
class FeatureDetailPage extends StatelessWidget {
  final Feature feature;
  const FeatureDetailPage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProjectManagementScreen());
  }
}
