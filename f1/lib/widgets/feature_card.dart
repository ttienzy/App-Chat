import 'package:f1/models/feature.dart';
import 'package:f1/widgets/feature_detail_screen.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị card của từng tính năng với hiệu ứng shadow và gradient nhẹ
class FeatureCard extends StatelessWidget {
  final Feature feature;
  final Color? backgroundColor;
  const FeatureCard({super.key, required this.feature, this.backgroundColor});

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
            // Nếu backgroundColor được truyền vào thì sử dụng gradient dựa trên màu đó,
            // nếu không thì sử dụng gradient mặc định.
            gradient:
                backgroundColor != null
                    ? LinearGradient(
                      colors: [
                        backgroundColor!,
                        backgroundColor!.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : const LinearGradient(
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 211, 128, 128),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                feature.icon,
                size: 50,
                color: const Color.fromARGB(255, 44, 8, 225),
              ),
              const SizedBox(height: 12),
              Text(
                feature.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(221, 85, 146, 157),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
