import 'package:flutter/material.dart';

class TaskModel {
  final String name;
  final String member;
  final DateTime start;
  final DateTime due;
  final String project;

  TaskModel({
    required this.name,
    required this.member,
    required this.start,
    required this.due,
    required this.project,
  });
}

class TaskAssignmentScreen extends StatefulWidget {
  const TaskAssignmentScreen({super.key});

  @override
  State<TaskAssignmentScreen> createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  final List<String> _projects = ['Dự án A', 'Dự án B', 'Dự án C'];
  String? _selectedProject;
  final List<TaskModel> _tasks = [];

  final TextEditingController _taskNameController = TextEditingController();
  String? _selectedMember;
  DateTime? _startDate;
  DateTime? _dueDate;

  final List<String> _teamMembers = [
    'Nguyễn Văn A',
    'Trần Thị B',
    'Lê Văn C',
    'Phạm Thị D',
  ];

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _submitAssignment() {
    if (_selectedProject == null ||
        _taskNameController.text.isEmpty ||
        _selectedMember == null ||
        _startDate == null ||
        _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn dự án và điền đầy đủ thông tin')),
      );
      return;
    }
    final newTask = TaskModel(
      name: _taskNameController.text,
      member: _selectedMember!,
      start: _startDate!,
      due: _dueDate!,
      project: _selectedProject!,
    );
    setState(() {
      _tasks.add(newTask);
      _taskNameController.clear();
      _selectedMember = null;
      _startDate = null;
      _dueDate = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã phân công "${newTask.name}" cho ${newTask.member} trong ${newTask.project}',
        ),
      ),
    );
  }

  List<TaskModel> get _filteredTasks {
    if (_selectedProject == null) return [];
    return _tasks.where((t) => t.project == _selectedProject).toList();
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quản Lý Nhiệm Vụ'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit), text: 'Phân Công'),
              Tab(icon: Icon(Icons.list), text: 'Danh Sách'),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedProject,
                decoration: InputDecoration(
                  labelText: 'Chọn dự án',
                  border: OutlineInputBorder(),
                ),
                items:
                    _projects
                        .map(
                          (proj) =>
                              DropdownMenuItem(value: proj, child: Text(proj)),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedProject = val;
                  });
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab Phân Công
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _taskNameController,
                            decoration: InputDecoration(
                              labelText: 'Tên nhiệm vụ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedMember,
                            decoration: InputDecoration(
                              labelText: 'Chọn thành viên',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                _teamMembers
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(m),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (v) => setState(() => _selectedMember = v),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _pickDate(context, true),
                                  child: Text(
                                    _startDate == null
                                        ? 'Chọn ngày bắt đầu'
                                        : 'Bắt đầu: ${_formatDate(_startDate!)}',
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _pickDate(context, false),
                                  child: Text(
                                    _dueDate == null
                                        ? 'Chọn ngày kết thúc'
                                        : 'Kết thúc: ${_formatDate(_dueDate!)}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: _submitAssignment,
                              child: Text('Giao Nhiệm Vụ'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tab Danh Sách
                    _selectedProject == null
                        ? Center(child: Text('Chọn dự án để xem danh sách'))
                        : _filteredTasks.isEmpty
                        ? Center(child: Text('Chưa có nhiệm vụ nào'))
                        : ListView.builder(
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, i) {
                            final t = _filteredTasks[i];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(t.name),
                                subtitle: Text(
                                  '${t.member} • ${_formatDate(t.start)} → ${_formatDate(t.due)}',
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
