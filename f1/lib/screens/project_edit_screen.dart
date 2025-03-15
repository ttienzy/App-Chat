import 'package:f1/models/project.dart';
import 'package:f1/repositories/project_repository.dart';
import 'package:flutter/material.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project; // Nhận project cần chỉnh sửa

  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  // Controllers cho TextField
  late TextEditingController _nameController;
  late TextEditingController _descController;
  double _progressPercentage = 00;

  // Biến lưu tạm ngày start/end
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị ban đầu từ widget.project
    _nameController = TextEditingController(text: widget.project.name);
    _descController = TextEditingController(text: widget.project.description);
    _progressPercentage = widget.project.progress * 100;

    _startDate = widget.project.startDate;
    _endDate = widget.project.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  // Hàm lưu/ cập nhật
  void _saveProject() {
    // Cập nhật lại thuộc tính project
    String projectName = _nameController.text.trim();
    String projectDesc = _descController.text.trim();
    DateTime startDate = _startDate;
    DateTime endDate = _endDate;
    double progress = _progressPercentage / 100;
    String status = 'ongoing';
    if (progress == 1.toDouble()) {
      status = 'completed';
    }
    if (progress < 1 && endDate.isBefore(DateTime.now())) {
      status = 'delayed';
    }
    // TODO: Nếu bạn muốn cập nhật Firestore hay Provider,
    // bạn gọi hàm update ở đây, hoặc trả project về màn hình trước:
    // Example:
    // Provider.of<ProjectProvider>(context, listen: false).updateProject(widget.project);
    updateProjectAttributes(
      projectId: widget.project.idProject,
      progress: progress,
      name: projectName,
      description: projectDesc,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
    Navigator.pop(context, {
      'name': projectName,
      'description': projectDesc,
      'startDate': startDate,
      'endDate': endDate,
      'progress': progress,
      'status': status,
    });
    // Hoặc chỉ pop nếu bạn đã xử lý cập nhật xong
  }

  void _deleteProject() {
    // TODO: Thực hiện xóa (Firestore, Provider, v.v.)
    Navigator.pop(context);
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa dự án này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false), // Hủy
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProject(projectId: widget.project.idProject);
                Navigator.pop(ctx, true);
              }, // Xác nhận xóa
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Người dùng chọn Xóa
      _deleteProject();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điều chỉnh dự án')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên dự án
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên dự án'),
            ),
            const SizedBox(height: 16),

            // Mô tả dự án
            TextField(
              controller: _descController,
              //maxLines: 4,
              decoration: const InputDecoration(labelText: 'Mô tả dự án'),
            ),
            const SizedBox(height: 16),

            // Ngày bắt đầu
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ngày bắt đầu: ${_startDate.toString().split(' ').first}',
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickStartDate,
                  child: const Text('Chọn ngày'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ngày kết thúc
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ngày kết thúc: ${_endDate.toString().split(' ').first}',
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickEndDate,
                  child: const Text('Chọn ngày'),
                ),
              ],
            ),
            // Thanh điều chỉnh tiến độ
            Text(
              'Tiến độ hiện tại : ${widget.project.progress * 100}%',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _progressPercentage,
              min: 1,
              max: 100,
              divisions: 99, // để chia đều từ 1 -> 100
              label: '${_progressPercentage.round()}%',
              onChanged: (value) {
                setState(() {
                  _progressPercentage = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Nút Lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveProject,
                icon: const Icon(Icons.save),
                label: const Text('Lưu dự án'),
              ),
            ),
            const SizedBox(height: 16),

            // Nút Xóa dự án (có icon + xác nhận)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showDeleteConfirmationDialog,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.delete),
                label: const Text('Xóa dự án'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
