import 'package:f1/models/feature.dart';
import 'package:f1/screens/feature_detail_screen.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị card của từng tính năng với hiệu ứng shadow và gradient nhẹ
class FeatureCard extends StatelessWidget {
  final Feature feature;
  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Colors.deepPurple.withAlpha((0.3 * 255).toInt()),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeatureDetailPage(feature: feature),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF8F8F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature.icon, size: 50, color: Colors.deepPurple),
              const SizedBox(height: 12),
              Text(
                feature.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
