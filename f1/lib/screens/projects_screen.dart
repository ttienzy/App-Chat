import 'package:f1/auth/projects_notifier.dart';
import 'package:f1/dialog/join_project_dialog.dart';
import 'package:f1/screens/project_add_screen.dart';
import 'package:f1/services/project_services.dart';
import 'package:f1/widgets/build_project_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectManagementScreen extends StatefulWidget {
  const ProjectManagementScreen({super.key});

  @override
  State<ProjectManagementScreen> createState() =>
      _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<ProjectManagementScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      projectProvider.listenToProjects(_user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy instance của ProjectProvider
    final projectProvider = Provider.of<ProjectProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nhập từ khóa...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    projectProvider.listenSearchToProjects(_user!.uid, value);
                  },
                )
                : const Text('Quản lý dự án'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  // Đóng search, clear nội dung search
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  // Mở search
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () => showJoinProjectDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  100,
                  80,
                  0,
                  0,
                ), // toạ độ hiển thị
                items: [
                  PopupMenuItem(
                    value: 'All',
                    child: Row(
                      children: [
                        Icon(Icons.all_inbox_outlined, color: Colors.blue),
                        SizedBox(width: 8), // Thêm khoảng cách
                        Text('Tất cả'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'progress',
                    child: Row(
                      children: [
                        Icon(Icons.percent_outlined, color: Colors.blue),
                        SizedBox(width: 8), // Thêm khoảng cách
                        Text('Tiến độ'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'due_date',
                    child: Row(
                      children: [
                        Icon(Icons.history, color: Colors.blue),
                        SizedBox(width: 8), // Thêm khoảng cách
                        Text('Dự án cũ'),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  switch (value) {
                    case 'All':
                      projectProvider.listenToProjects(_user!.uid);
                      break;
                    case 'progress':
                      projectProvider.listenFilterPogressToProjects(_user!.uid);
                      break;
                    case 'due_date':
                      projectProvider.listenFilterOldProjects(_user!.uid);
                      break;
                    default:
                      break;
                  }
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProjectScreen()),
          );
          if (result != null) {
            bool data = await addProjectServices(result, _user!.uid);
            if (!data) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Có lỗi xảy ra khi thêm project.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
      body: _buildBody(projectProvider),
    );
  }

  Widget _buildBody(ProjectProvider projectProvider) {
    if (projectProvider.isLoading) {
      // Hiển thị vòng xoay khi đang tải
      return Center(child: CircularProgressIndicator());
    }
    if (projectProvider.error != null) {
      // Hiển thị lỗi nếu có
      return Center(child: Text("Error: ${projectProvider.error}"));
    }
    if (projectProvider.projects.isEmpty) {
      return const Center(child: Text('Không có dự án nào'));
    }
    // Nếu không loading và không lỗi, hiển thị danh sách
    final projects = projectProvider.projects;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        print(project.idProject);
        return buildProjectCard(project, context);
      },
    );
  }
}
