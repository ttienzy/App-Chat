import 'package:f1/models/feature.dart';
import 'package:f1/screens/profile_screen.dart';
import 'package:f1/widgets/feature_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _user = FirebaseAuth.instance.currentUser;
  final List<Feature> features = ListFeatures().getFeatures();

  // Biến trạng thái để chuyển đổi giữa GridView và ListView
  bool isGrid = true;

  // Danh sách màu cho các Feature Card
  final List<Color> cardColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.amberAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng cho giao diện Material
      appBar: AppBar(
        backgroundColor: Colors.blue, // Màu chủ đạo
        elevation: 0,
        centerTitle: false, // Chuyển title về bên trái
        title: InkWell(
          // Dùng InkWell hoặc GestureDetector để có hiệu ứng nhấn
          onTap: () {
            // Khi nhấn vào vùng chứa avatar + tên, chuyển sang trang cá nhân
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundImage: NetworkImage(
                  _user!.photoURL ?? 'https://via.placeholder.com/150',
                ),
                radius: 14,
              ),
              const SizedBox(width: 10),
              // Tên hiển thị
              Text(
                'Xin chào, ${_user.displayName ?? 'User'}',
                style: const TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header với gradient đa màu và bo góc dưới
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo, Colors.blue],
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
                    "Welcome to",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Project Management & Teamwork Platform",
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
            // Layout thay đổi: Grid hoặc List tùy theo giá trị của isGrid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  isGrid
                      ? GridView.builder(
                        itemCount: features.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 cột
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.1,
                            ),
                        itemBuilder: (context, index) {
                          final feature = features[index];
                          final cardColor =
                              cardColors[index % cardColors.length];
                          return FeatureCard(
                            feature: feature,
                            backgroundColor:
                                cardColor, // Cập nhật FeatureCard để nhận tham số này
                          );
                        },
                      )
                      : ListView.builder(
                        itemCount: features.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final feature = features[index];
                          final cardColor =
                              cardColors[index % cardColors.length];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: FeatureCard(
                              feature: feature,
                              backgroundColor: cardColor,
                            ),
                          );
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
