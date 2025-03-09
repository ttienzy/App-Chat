import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Biến lưu trữ ngày bắt đầu và kết thúc
  DateTime? _startDate;
  DateTime? _endDate;

  // Hàm chọn ngày bắt đầu
  Future<void> _pickStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Giới hạn ngày sớm nhất
      lastDate: DateTime(2100), // Giới hạn ngày muộn nhất
    );
    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  // Hàm chọn ngày kết thúc
  Future<void> _pickEndDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // Lấy dữ liệu
      final projectName = _projectNameController.text.trim();
      final projectDesc = _descController.text.trim();
      final startDate = _startDate;
      final endDate = _endDate;

      // Kiểm tra hợp lệ ngày
      if (startDate == null || endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ngày bắt đầu và kết thúc'),
          ),
        );
        return;
      }
      if (endDate.isBefore(startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ngày kết thúc phải sau ngày bắt đầu')),
        );
        return;
      }
      //Trả dữ liệu về (nếu muốn)
      Navigator.pop(context, {
        'name': projectName,
        'description': projectDesc,
        'startDate': startDate,
        'endDate': endDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('Thêm dự án mới'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      // Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                'Thông tin dự án',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Nhập Tên Dự Án
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên dự án',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên dự án';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nhập Mô tả
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả dự án',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Chọn Ngày Bắt Đầu
              Text(
                'Ngày bắt đầu:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _startDate == null
                            ? 'Chưa chọn'
                            : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickStartDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Chọn ngày'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Chọn Ngày Kết Thúc
              Text(
                'Ngày kết thúc:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _endDate == null
                            ? 'Chưa chọn'
                            : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickEndDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Chọn ngày'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Nút Lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Lưu dự án',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
