import 'package:f1/models/feature.dart';
import 'package:f1/widgets/feature_card.dart';
import 'package:flutter/material.dart';

/// Trang Dashboard với header gradient và danh sách chức năng theo dạng grid
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final List<Feature> features = const [
    Feature(title: 'Quản lý dự án', icon: Icons.folder_open),
    Feature(title: 'Phân công nhiệm vụ', icon: Icons.assignment_ind),
    Feature(title: 'Theo dõi tiến độ', icon: Icons.track_changes),
    Feature(title: 'Tài liệu dự án', icon: Icons.description),
    Feature(title: 'Chat nhóm', icon: Icons.chat),
    Feature(title: 'Báo cáo thống kê', icon: Icons.bar_chart),
    Feature(title: 'Biểu đồ Gantt', icon: Icons.timeline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text("Project Management"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header với gradient và bo góc dưới
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Chào mừng bạn đến",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Quản lý dự án & làm việc nhóm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Grid hiển thị các chức năng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: features.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return FeatureCard(feature: feature);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
