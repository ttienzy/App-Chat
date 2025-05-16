import 'package:f1/models/task_parameters.dart';
import 'package:f1/repositories/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskFormScreen extends StatefulWidget {
  final String idProject;
  const AddTaskFormScreen({super.key, required this.idProject});

  @override
  State<AddTaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<AddTaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _assigneeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _assigneeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  final List<String> demoEmailList = [
    'tiennd.23ce@vku.udn.vn',
    'alice@example.com',
    'bob@example.com',
    'charlie@example.com',
    'david@example.com',
    'emma@example.com',
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStartDate
              ? (_startDate ?? DateTime.now())
              : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);

          // Nếu ngày kết thúc đã chọn và trước ngày bắt đầu mới, reset ngày kết thúc
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
            _endDateController.text = '';
          }
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newTask = TaskParameters(
        name: _nameController.text,
        assignee: await getUserIdByEmail(_assigneeController.text),
        startDate: _startDate!,
        endDate: _endDate!,
        idProject: widget.idProject,
        status: 'ongoing',
      );
      print(newTask);
      await createTask(newTask);

      // Đóng form và trả về task mới
      Navigator.of(context).pop(newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tạo Task Mới',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple, Color.fromARGB(255, 141, 114, 223)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade50),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Card bao bọc tất cả trường nhập liệu
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề
                        Text(
                          'Thông tin task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tên Task
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Tên Task',
                            hintText: 'Nhập tên task',
                            prefixIcon: Icon(
                              Icons.task_alt,
                              color: Colors.deepPurple.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.deepPurple),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tên task';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Người được giao
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return demoEmailList.where((String option) {
                              return option.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              );
                            });
                          },
                          onSelected: (String selection) {
                            _assigneeController.text = selection;
                          },
                          fieldViewBuilder: (
                            context,
                            controller,
                            focusNode,
                            onEditingComplete,
                          ) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: 'Người được giao',
                                hintText: 'Chọn người thực hiện',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.deepPurple.shade400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập người được giao task';
                                }
                                return null;
                              },
                              onEditingComplete: onEditingComplete,
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Row chứa hai trường ngày
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ngày bắt đầu
                            Expanded(
                              child: TextFormField(
                                controller: _startDateController,
                                decoration: InputDecoration(
                                  labelText: 'Ngày bắt đầu',
                                  hintText: 'Chọn ngày',
                                  prefixIcon: Icon(
                                    Icons.event_available,
                                    color: Colors.deepPurple.shade400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn ngày bắt đầu';
                                  }
                                  return null;
                                },
                                onTap: () => _selectDate(context, true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Ngày kết thúc
                            Expanded(
                              child: TextFormField(
                                controller: _endDateController,
                                decoration: InputDecoration(
                                  labelText: 'Ngày kết thúc',
                                  hintText: 'Chọn ngày',
                                  prefixIcon: Icon(
                                    Icons.event_busy,
                                    color: Colors.deepPurple.shade400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn ngày kết thúc';
                                  }
                                  return null;
                                },
                                onTap: () => _selectDate(context, false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nút lưu với hiệu ứng nâng cao
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save),
                      const SizedBox(width: 8),
                      const Text(
                        'Lưu Task',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
