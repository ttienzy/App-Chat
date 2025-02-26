import 'package:f1/models/feature.dart';
import 'package:flutter/material.dart';

/// Trang chi tiết cho từng tính năng
class FeatureDetailPage extends StatelessWidget {
  final Feature feature;
  const FeatureDetailPage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng AppBar có màu nền đồng bộ với theme
      appBar: AppBar(
        title: Text(feature.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          '${feature.title} UI demo\n(Chưa tích hợp dữ liệu thực tế)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
    );
  }
}
