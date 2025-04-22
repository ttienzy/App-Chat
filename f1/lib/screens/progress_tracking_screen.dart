import 'package:f1/auth/task_progress_notifier.dart';
import 'package:f1/models/project_progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({super.key});

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  // final List<ProjectProgress> projects = [
  //   ProjectProgress(
  //     name: 'Phát triển App Flutter',
  //     progress: 0.35,
  //     startDate: DateTime(2025, 3, 1),
  //     endDate: DateTime(2025, 5, 30),
  //     color: const Color(0xFF5E35B1),
  //   ),
  //   ProjectProgress(
  //     name: 'Xây dựng API Backend',
  //     progress: 0.75,
  //     startDate: DateTime(2025, 2, 15),
  //     endDate: DateTime(2025, 4, 25),
  //     color: const Color(0xFF00897B),
  //   ),
  //   ProjectProgress(
  //     name: 'Thiết kế UI/UX',
  //     progress: 0.50,
  //     startDate: DateTime(2025, 3, 10),
  //     endDate: DateTime(2025, 4, 15),
  //     color: const Color(0xFFE53935),
  //   ),
  //   ProjectProgress(
  //     name: 'Kiểm thử và QA',
  //     progress: 0.20,
  //     startDate: DateTime(2025, 4, 1),
  //     endDate: DateTime(2025, 5, 15),
  //     color: const Color(0xFFFFB300),
  //   ),
  // ];

  int _selectedTabIndex = 0;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProgressProvider = Provider.of<ProjectProgressNotifier>(
        context,
        listen: false,
      );
      taskProgressProvider.getProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProgressProvider = Provider.of<ProjectProgressNotifier>(context);
    if (taskProgressProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (taskProgressProvider.error != null) {
      return Center(
        child: Text(
          'Lỗi: ${taskProgressProvider.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (taskProgressProvider.projects.isEmpty) {
      return const Center(
        child: Text('Không có dự án nào', style: TextStyle(color: Colors.grey)),
      );
    }
    final projects = taskProgressProvider.projects;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard Dự án',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF5E35B1),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              children: [
                _buildProgressChart(projects),
                _buildGanttChart(projects),
                _buildProjectStats(projects),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF5E35B1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            _buildTab(0, Icons.pie_chart, 'Tiến độ'),
            _buildTab(1, Icons.date_range, 'Timeline'),
            _buildTab(2, Icons.analytics, 'Thống kê'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressChart(List<ProjectProgress> projects) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tiến độ dự án',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E35B1),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                project.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    project.isOnTrack
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      project.isOnTrack
                                          ? Colors.green
                                          : Colors.red,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                project.isOnTrack
                                    ? 'Đúng tiến độ'
                                    : 'Chậm tiến độ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      project.isOnTrack
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildProgressIndicator(
                              'Hoàn thành',
                              '${(project.progress * 100).toInt()}%',
                              project.progress,
                              project.color,
                            ),
                            _buildProgressIndicator(
                              'Thời gian',
                              '${(project.timePercentage * 100).toInt()}%',
                              project.timePercentage,
                              Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(project.startDate)}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Ngày kết thúc: ${DateFormat('dd/MM/yyyy').format(project.endDate)}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            'Còn lại: ${project.daysRemaining} ngày',
                            style: TextStyle(
                              color:
                                  project.daysRemaining < 7
                                      ? Colors.red
                                      : Colors.grey[700],
                              fontWeight:
                                  project.daysRemaining < 7
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    String label,
    String value,
    double progress,
    Color color,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildGanttChart(List<ProjectProgress> projects) {
    // Tìm ngày sớm nhất và muộn nhất trong các dự án
    final DateTime earliestDate = projects
        .map((project) => project.startDate)
        .reduce((value, element) => value.isBefore(element) ? value : element);

    final DateTime latestDate = projects
        .map((project) => project.endDate)
        .reduce((value, element) => value.isAfter(element) ? value : element);

    // Tính tổng số ngày để hiển thị
    final totalDays = latestDate.difference(earliestDate).inDays + 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline dự án',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E35B1),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 120), // Space for project names
                        Expanded(
                          child: Stack(
                            children: [
                              // Today marker
                              Positioned(
                                left: _calculatePosition(
                                  DateTime.now(),
                                  earliestDate,
                                  totalDays,
                                ),
                                top: 0,
                                bottom: 0,
                                child: Container(width: 2, color: Colors.red),
                              ),

                              // Timeline header
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat(
                                        'MMM yyyy',
                                      ).format(earliestDate),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      DateFormat('MMM yyyy').format(latestDate),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: projects.length,
                        separatorBuilder:
                            (context, index) => Divider(height: 24),
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          final startPosition = _calculatePosition(
                            project.startDate,
                            earliestDate,
                            totalDays,
                          );
                          final duration =
                              project.endDate
                                  .difference(project.startDate)
                                  .inDays /
                              totalDays;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  project.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      height: 2,
                                      color: Colors.grey[200],
                                    ),
                                    Positioned(
                                      left: startPosition,
                                      child: Container(
                                        height: 24,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            duration *
                                            0.65,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color: project.color.withOpacity(0.7),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${(project.progress * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePosition(DateTime date, DateTime startDate, int totalDays) {
    final daysDifference = date.difference(startDate).inDays;
    return daysDifference /
        totalDays *
        MediaQuery.of(context).size.width *
        0.65;
  }

  Widget _buildProjectStats(List<ProjectProgress> projects) {
    // Đếm số dự án theo trạng thái
    int onTrackProjects = 0;
    int delayedProjects = 0;

    for (var project in projects) {
      if (project.isOnTrack) {
        onTrackProjects++;
      } else {
        delayedProjects++;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê dự án',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E35B1),
            ),
          ),
          const SizedBox(height: 16),
          // Overview cards
          Row(
            children: [
              _buildStatCard(
                'Tổng dự án',
                projects.length.toString(),
                Icons.folder,
                const Color(0xFF5E35B1),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Đúng tiến độ',
                onTrackProjects.toString(),
                Icons.check_circle,
                Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Chậm tiến độ',
                delayedProjects.toString(),
                Icons.warning,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Days remaining summary
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thời gian còn lại',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (var project in projects) ...[
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: project.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                project.daysRemaining < 7
                                    ? Colors.red.withOpacity(0.1)
                                    : project.daysRemaining < 14
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${project.daysRemaining} ngày',
                            style: TextStyle(
                              color:
                                  project.daysRemaining < 7
                                      ? Colors.red
                                      : project.daysRemaining < 14
                                      ? Colors.orange
                                      : Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (project != projects.last) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
