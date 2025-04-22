import 'package:f1/auth/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text(
          'Thêm dự án mới',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5E35B1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Hiển thị thông tin hướng dẫn
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                !isDarkMode
                    ? [Color(0xFF5E35B1), Color(0xFFF5F5F5)]
                    : [Color(0xFF5E35B1), Color(0xFF1C2841)],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: !isDarkMode ? Colors.white : const Color(0xFF1C2841),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E35B1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.assignment_add,
                              color: Color(0xFF5E35B1),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Thông tin dự án',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFF5E35B1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tên Dự Án
                      Text(
                        'Tên dự án',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _projectNameController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên dự án',
                          fillColor:
                              !isDarkMode
                                  ? Colors.grey[50]
                                  : const Color.fromARGB(255, 49, 67, 105),
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.edit_document,
                            color: Color(0xFF5E35B1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color:
                                  !isDarkMode
                                      ? Colors.grey[300]!
                                      : const Color.fromARGB(255, 76, 98, 145),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF5E35B1),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên dự án';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Mô tả
                      Text(
                        'Mô tả dự án',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              !isDarkMode
                                  ? Colors.grey[800]
                                  : const Color.fromARGB(255, 76, 98, 145),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descController,
                        decoration: InputDecoration(
                          hintText: 'Nhập mô tả chi tiết về dự án',
                          fillColor:
                              !isDarkMode
                                  ? Colors.grey[50]
                                  : const Color.fromARGB(255, 49, 67, 105),
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.description,
                            color: Color(0xFF5E35B1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color:
                                  !isDarkMode
                                      ? Colors.grey[300]!
                                      : const Color.fromARGB(255, 76, 98, 145),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF5E35B1),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Date Range Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: !isDarkMode ? Colors.white : const Color(0xFF1C2841),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E35B1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Color(0xFF5E35B1),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Thời gian dự án',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF5E35B1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Ngày bắt đầu
                      Text(
                        'Ngày bắt đầu',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              !isDarkMode
                                  ? Colors.grey[800]
                                  : const Color.fromARGB(255, 76, 98, 145),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickStartDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                !isDarkMode
                                    ? Colors.grey[50]
                                    : const Color.fromARGB(255, 49, 67, 105),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF5E35B1),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                _startDate == null
                                    ? 'Chọn ngày bắt đầu'
                                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _startDate == null
                                          ? Colors.grey[600]
                                          : Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Ngày kết thúc
                      Text(
                        'Ngày kết thúc',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              !isDarkMode
                                  ? Colors.grey[800]
                                  : const Color.fromARGB(255, 76, 98, 145),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickEndDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                !isDarkMode
                                    ? Colors.grey[50]
                                    : const Color.fromARGB(255, 49, 67, 105),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.event, color: Color(0xFF5E35B1)),
                              const SizedBox(width: 16),
                              Text(
                                _endDate == null
                                    ? 'Chọn ngày kết thúc'
                                    : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _endDate == null
                                          ? Colors.grey[600]
                                          : Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5E35B1).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E35B1),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save),
                        const SizedBox(width: 10),
                        Text(
                          'Lưu dự án',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                !isDarkMode
                                    ? const Color.fromARGB(255, 204, 182, 182)
                                    : Color.fromARGB(255, 220, 229, 166),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Quay lại màn hình trước
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.grey[700],
                    ),
                    child: const Text('Hủy', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
