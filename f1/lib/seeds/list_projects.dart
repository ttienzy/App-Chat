import 'package:f1/models/project.dart';

class ListProjects {
  List<Project> getProjects() {
    return [
      Project(
        idProject: '123',
        name: 'Dự án Phát triển Website',
        description:
            'Xây dựng website thương mại điện tử với tính năng thanh toán trực tuyến',
        progress: 0.2,
        membersCount: 5,
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 4, 30),
        status: 'ongoing',
        role: 'leader',
      ),
      Project(
        idProject: '1234',
        name: 'Dự án App Mobile',
        description:
            'Phát triển ứng dụng di động đa nền tảng cho doanh nghiệp SME',
        progress: 0.4,
        membersCount: 8,
        startDate: DateTime(2025, 1, 15),
        endDate: DateTime(2025, 3, 15),
        status: 'delayed',
        role: 'leader',
      ),
      Project(
        idProject: '12345',
        name: 'Dự án AI Chatbot',
        description:
            'Xây dựng chatbot tích hợp trí tuệ nhân tạo hỗ trợ khách hàng',
        progress: 0.6,
        membersCount: 3,
        startDate: DateTime(2025, 2, 10),
        endDate: DateTime(2025, 3, 25),
        status: 'ongoing',
        role: 'member',
      ),
    ];
  }
}
